import { defineConfig } from "oxlint";

const plugins = ["eslint", "typescript", "unicorn", "oxc", "import", "promise"] as const;

export default defineConfig({
	plugins: [...plugins],
	categories: {
		correctness: "error",
		suspicious: "warn",
		perf: "warn",
	},
	env: {
		builtin: true,
		es2022: true,
		browser: true,
	},
	options: {
		typeAware: true,
		reportUnusedDisableDirectives: "warn",
	},
	ignorePatterns: ["html/**", "saxon/**", "data/**"],
	rules: {
		// main.ts imports the stylesheet and ui.ts for their side effects
		"import/no-unassigned-import": ["warn", { allow: ["**/*.css", "./ui"] }],
	},
	overrides: [
		{
			files: ["vite.config.ts", "oxlint.config.ts", "utils/**"],
			plugins: [...plugins, "node"],
			env: { browser: false, node: true },
		},
	],
});
