# CI / release (binding)

Same model as [platform-ci RELEASE.md](https://github.com/roshandroids/platform-ci/blob/main/docs/RELEASE.md):

```text
Cheap proves mergeability.
Release PR proves shipability.
Tag publishes (rebuild).
```

| Lane | When | What |
|------|------|------|
| Feature PR | → main | `quality` only (format/analyze/test/golden/boundaries) |
| Release PR | `release/*` → main | quality + **web** build |
| Tag `v*` | after merge | rebuild web → GitHub Release → Pages |

Config: [`ci.yaml`](../../ci.yaml). No Android/iOS on PRs. No permanent `dev`.

Required checks: [`CI_REQUIRED_CHECKS.md`](CI_REQUIRED_CHECKS.md).
