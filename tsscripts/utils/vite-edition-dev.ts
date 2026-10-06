import { spawn } from "node:child_process";
import path from "node:path";

import type { Plugin } from "vite";

// Dev server only: serves the ant output in html/ (as Vite publicDir) with hot reload.
// - /js/main.js and /css/index.css, linked by the XSLT head partial, are answered with
//   the Vite client + tsscripts/main.ts + styles/index.css, so CSS/TS changes hot-swap
//   without a build
// - changes in xslt/, data/ or translations.csv re-run ant, then the browser reloads
// - any other change in html/ (e.g. other html/js/*.js files) reloads the browser
export function editionDev(): Plugin {
	return {
		name: "edition-dev",
		apply: "serve",
		configureServer(server) {
			const { root, logger } = server.config;
			const htmlDir = path.join(root, "html") + path.sep;
			// written by `vite build`; in dev they are replaced by the middleware below
			const builtFiles = new Set([
				path.join(root, "html", "js", "main.js"),
				path.join(root, "html", "css", "index.css"),
			]);
			const antInputDirs = ["xslt", "data"].map((dir) => path.join(root, dir) + path.sep);
			const antInputFiles = new Set([
				path.join(root, "translations.csv"),
				path.join(root, "build.xml"),
			]);

			server.middlewares.use((req, res, next) => {
				const url = new URL(req.url ?? "/", "http://localhost");
				if (url.pathname === "/js/main.js") {
					res.setHeader("Content-Type", "text/javascript");
					res.end(
						'import "/@vite/client";\nimport "/styles/index.css";\nimport "/tsscripts/main.ts";\n',
					);
					return;
				}
				if (url.pathname === "/css/index.css") {
					// in dev the styles are injected by the /js/main.js response above
					res.setHeader("Content-Type", "text/css");
					res.end("");
					return;
				}
				if (url.pathname.endsWith("/")) req.url = `${url.pathname}index.html${url.search}`;
				next();
			});

			let reloadTimer: ReturnType<typeof setTimeout> | undefined;
			const reload = () => {
				clearTimeout(reloadTimer);
				reloadTimer = setTimeout(() => server.ws.send({ type: "full-reload" }), 100);
			};

			let antRunning = false;
			let antQueued = false;
			const runAnt = () => {
				if (antRunning) {
					antQueued = true;
					return;
				}
				antRunning = true;
				logger.info("ant inputs changed, running ant …", { timestamp: true });
				const ant = spawn("ant", ["-quiet"], { cwd: root, stdio: "inherit" });
				ant.on("error", (err) => logger.error(`ant failed to start: ${err.message}`));
				ant.on("close", (code) => {
					antRunning = false;
					if (antQueued) {
						antQueued = false;
						runAnt();
					} else if (code === 0) {
						logger.info("ant done, reloading", { timestamp: true });
						reload();
					} else {
						logger.error(`ant exited with code ${code}`, { timestamp: true });
					}
				});
			};

			const onFileEvent = (file: string) => {
				if (antInputFiles.has(file) || antInputDirs.some((dir) => file.startsWith(dir))) runAnt();
				else if (file.startsWith(htmlDir) && !builtFiles.has(file) && !antRunning) reload();
			};
			server.watcher.on("add", onFileEvent);
			server.watcher.on("change", onFileEvent);
			server.watcher.on("unlink", onFileEvent);
		},
	};
}
