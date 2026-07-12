# Release Checklist

Run these checks before publishing a release.

## Automated Checks

- [ ] `flutter pub get`
- [ ] `dart format --set-exit-if-changed .`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] `flutter test --platform chrome`
- [ ] `dart pub publish --dry-run`

## Package Review

- [ ] README describes only currently implemented features.
- [ ] CHANGELOG has an entry for the release version.
- [ ] LICENSE is present and correct.
- [ ] `pubspec.yaml` version matches the CHANGELOG entry.
- [ ] `pubspec.yaml` metadata is ready for pub.dev.

## Later

- [ ] Example app is added and verified.
