# Secrets

Never committed - `.gitignore` blocks `.env`, `*.jks`/`*.keystore`,
`google-services.json`, `GoogleService-Info.plist`.

## Local development

Copy `.env.example` (create one per module you enable - see
[`../../modules/README.md`](../../modules/README.md)) to `.env.local` and
fill in real values. `.env.local` stays untracked.

## CI

Secrets live in GitHub repository/environment secrets, referenced in
workflows as `${{ secrets.NAME }}` - never inlined. `package_publish.yml`
uses OIDC trusted publishing to pub.dev instead of a long-lived token
where possible - see that workflow's comments.

## Rotation

Rotating a secret means updating the GitHub secret and, for anything
distributed to running clients (an API key baked into a build), also
shipping a new release - a rotated secret doesn't retroactively invalidate
already-installed builds using the old one unless the backend enforces it.
