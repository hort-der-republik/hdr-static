import { spawn } from "node:child_process";
import { readFileSync } from "node:fs";
import path from "node:path";

import type { Plugin } from "vite";

// Dev server only: serves the ant output in html/ (as Vite publicDir) with hot reload.
// - /js/main.js and /css/index.css, linked by the XSLT head partial, are answered with
//   the Vite client + tsscripts/main.ts + styles/index.css, so CSS/TS changes hot-swap
//   without a build
// - changes in xslt/, data/ or translations.csv re-run ant, then the browser reloads
// - any other change in html/ (e.g. other html/js/*.js files) reloads the browser
// - the pages are read from disk on every request: Vite serves publicDir from a file list built
//   at startup and kept up to date by the watcher, which ignores the pages (vite.config.ts), so
//   pages missing at startup (ant deletes and rewrites them) would stay 404 until a restart
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
					// the injected styles take over from the <link> (see below), so drop it: otherwise
					// rules removed during HMR would stay in effect until the next reload
					res.end(
						'import "/@vite/client";\nimport "/styles/index.css";\nimport "/tsscripts/main.ts";\n' +
							'document.querySelector(\'link[rel="stylesheet"][href*="css/index.css"]\')?.remove();\n',
					);
					return;
				}
				if (url.pathname === "/css/index.css") {
					// the compiled CSS as a plain stylesheet, so the page renders styled right away instead
					// of flashing unstyled until /js/main.js has injected the styles
					req.url = "/styles/index.css?direct";
				}
				const pathname = url.pathname.endsWith("/") ? `${url.pathname}index.html` : url.pathname;
				const page = pathname.endsWith(".html") ? readPage(pathname) : undefined;
				if (!page) return next();
				res.setHeader("Content-Type", "text/html; charset=utf-8");
				res.setHeader("Cache-Control", "no-cache");
				res.end(page);
			});

			// a page from html/, or undefined if it doesn't exist or the path leads outside html/;
			// read synchronously, it's a small local file and only the dev server
			function readPage(pathname: string): Buffer | undefined {
				const file = path.join(htmlDir, decodeURIComponent(pathname));
				if (!file.startsWith(htmlDir)) return undefined;
				try {
					return readFileSync(file);
				} catch {
					return undefined;
				}
			}

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
