# Prompt fragment: writing a test

Used by [`../roles/tester.md`](../roles/tester.md).

Before writing a test, state in one sentence: what input/state, and what
wrong behavior would this test catch? If you can't state a concrete failure
scenario, the test is asserting structure, not behavior - reconsider it.

Name the test after the behavior, not the method: `throws
InvalidCredentialsFailure when the token refresh returns 401`, not
`test refreshToken`.

Pick the layer per [`../../docs/testing/README.md`](../../docs/testing/README.md):
domain/application logic → unit test, no Flutter import; presentation →
widget test; visual regression → golden test; cross-feature flow →
integration test.
