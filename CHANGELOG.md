## [3.0.3] - 2023-06-02

- Updated for Flutter 3.10 and Dart 3.
- Update License wording (same license).
- Updated README to add shields.

## [3.0.2] - 2022-07-18

- Fixed `SchedulerBinding` warnings.
- Example app: Migrated to Android embedding v2. Updated Android dependencies.
- Reorganized CHANGELOG.md to have entries ordered from newest to oldest.

## [3.0.1] - 2021-05-25

- Fixed a bug causing the loader to not dismiss in some cases because of
  ProgressLoaderWidgetController.dismiss() future not completing in the default loader.
- Added an extension method in example code to show an nice way of handling FutureTicker.
- If you are using ProgressLoaderWidgetController in your code and awaiting an
  AnimationController.dismiss() to call ProgressLoaderWidgetController.dismiss() then check the
  updated example code to avoid making the same mistake as I did.

## [3.0.0] - 2021-05-24

* [BREAKING]
    - Fixed a bug causing the loader to not show if show was called before the previous loader was
      done dismissing.
    - Refactored example code, and added a test page to visually test sync issues like the one
      stated above.
    - This is probably not breaking anyone's code but could potentially do, so marking this as a
      breaking change.

## [2.0.0] - 2021-05-15

* [BREAKING] - Migrated to null-safety.

## [1.0.0] - 2020-11-05

* Initial release.

