# Karl Kraus: Hort der Republik

- data is fetched from https://github.com/hort-der-republik/hdr-para-texts
- based on [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)
- published at https://hort-der-republik.github.io/hdr-static/

> [!WARNING]
> This project extends the DSE-Static-Cookiecutter base with a modern frontend setup (Vite,
> Tailwind CSS, TypeScript, responsive images, linting and formatting). Developing this setup is
> part of the project itself, so the code is still work in progress and will only be final at the
> end of the project. The extension may also become the subject of a paper at the end of the
> project. Until then it is not meant to be used outside of this project. Please do not reuse it
> as a template or copy code from it.

## setup

The easiest way is to open the repo in the dev container (`.devcontainer/`, image in
`docker/Dockerfile`); it comes with Java, ant, Node 24, pnpm and [uv](https://docs.astral.sh/uv/)
and installs all dependencies on creation.

Without the dev container, install those tools yourself, then run:

- `uv sync`
- `pnpm install`

Then:

- `./fetch_data.sh` to fetch the data and the imprint
- `ant` to build the pages into `html/`
- `pnpm build` to build the CSS and JS bundle into `html/`

## dev server

- run `ant` once, then `pnpm dev`
- go to [http://localhost:5173/de/](http://localhost:5173/de/)

Changes to `styles/` and `tsscripts/` are applied without reload; changes to `xslt/`, `data/`,
`translations.csv` or `build.xml` re-run `ant` and reload the browser.

To check the production build instead: `ant && pnpm build && pnpm serve`, then go to
[http://localhost:8000/de/](http://localhost:8000/de/).

## images

Source images go into `data/img/` (credits in `data/img/img-credits.csv`). `ant` turns them into
responsive WebP versions in `html/img/` (or by hand: `pnpm images`).

## translations

UI strings live in `translations.csv` and are read by the XSLT at build time. The JS translations in
`html/locales/` are generated from the same file and committed, so after editing
`translations.csv` run `uv run make_translations.py`.

## code quality

- `pnpm format:check` / `pnpm format:fix`
- `pnpm lint:check` / `pnpm lint:fix`
- `pnpm types:check`

## publish as GitHub Page

- go to https://github.com/hort-der-republik/hdr-static/actions/workflows/build.yml
- click the `Run workflow` button

The workflow fetches the data, builds everything with the base path `/hdr-static/` and deploys
`html/`. Generated files are not committed (see `.gitignore`).

## Licenses

Licence will be added later.

### third-party JavaScript libraries

The code for all third-party JavaScript libraries used is included in the `html/vendor` folder, their respective licenses can be found either in a `LICENSE.txt` file or directly in the header of the `.js` file

### SAXON-HE

The projects also includes Saxon-HE, which is licensed separately under the Mozilla Public License, Version 2.0 (MPL 2.0). See the dedicated [LICENSE.txt](saxon/notices/LICENSE.txt)
