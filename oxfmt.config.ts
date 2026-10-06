import { defineConfig } from "oxfmt";

export default defineConfig({
	printWidth: 100,
	sortImports: true,
	ignorePatterns: [
		"html/**",
		"saxon/**",
		"data/**",
		"oai-pmh/**",
		".github/**",
		"pnpm-lock.yaml",
		"pyproject.toml",
	],
});
