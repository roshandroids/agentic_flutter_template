# release/

Local staging directory for build artifacts (APKs, app bundles, IPAs, web
builds) produced by `flutter build` or the release scripts - never
committed. `.gitignore` ignores everything under here except this file and
`.gitkeep`, so the directory itself persists in git while its contents
never do.

CI does not write here - `.github/workflows/build_verify.yml` and
`web_deploy.yml` use `actions/upload-artifact`/`upload-pages-artifact`
instead, which don't touch the working tree. This directory is for local,
manual builds (`flutter build apk --output-dir=../../release`-style
workflows) when you want a build artifact on disk without hunting through
each platform's own `build/` output path.
