# module_contracts

Pure-Dart interfaces every `modules/*` integration implements:
`AuthModule`, `AnalyticsModule`, `NotificationsModule`, `PaymentsModule`.

No provider SDK dependency here - a contract models the *capability*
(sign in, log an event, send a purchase) generically, so `modules/firebase`
and `modules/supabase` can both implement `AuthModule` and be swapped at
`apps/app/lib/composition_root.dart` without any other code caring which
one is active. See [../README.md](../README.md).
