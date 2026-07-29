# Localization

Strings live in `apps/app/lib/l10n/arb/app_en.arb` (source of truth) and one
ARB file per additional locale (`app_fr.arb`, ...). Run `melos run
generate` to regenerate `AppLocalizations`. Never hardcode a user-facing
string in `presentation/` - use `AppLocalizations.of(context)!.yourKey`.

Adding a new locale is additive - a new ARB file plus `generate`, no code
change, since `presentation/` code already goes through
`AppLocalizations` for every string.
