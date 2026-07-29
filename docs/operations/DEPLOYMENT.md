# Deployment

| Platform | How it ships | Workflow |
|---|---|---|
| Web | GitHub Pages by default (works immediately, no secrets needed) | `.github/workflows/web_deploy.yml` |
| Android | Manual today - build an app bundle (`flutter build appbundle`) and upload to Play Console; automate via a `play_publish.yml` workflow once a service-account secret exists | `.github/workflows/build_verify.yml` builds a debug APK for verification only |
| iOS | Manual today - `flutter build ipa` + Transporter/Xcode Cloud; automate once signing certificates are provisioned as CI secrets | `.github/workflows/build_verify.yml` builds unsigned for verification only |

Swap the web deploy target for your real hosting (Firebase Hosting, S3 +
CloudFront, Netlify) by replacing `web_deploy.yml`'s deploy job once you
have credentials - GitHub Pages exists here so the template works
out of the box, not as a permanent recommendation.
