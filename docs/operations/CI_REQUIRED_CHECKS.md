# Required status checks (platform-ci)

| Check | When |
|-------|------|
| `quality / Quality` | PR → main |
| `build / Resolve targets` | PR → main |
| `build / Build (web)` | PR → main |

Android/iOS desktop verify removed from PR CI (opt-in later via `ci.yaml`).
