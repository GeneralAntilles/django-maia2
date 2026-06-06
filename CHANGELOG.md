# Changelog

Notable changes to **django-maia2**, newest first, in plain language.
This project follows [semantic versioning](https://semver.org/). Each release
below corresponds to a `vX.Y.Z` git tag and a published wheel.

## 0.1.4 - 2026-06-06

- Lined the questionnaire's answer buttons up directly under their 0–5 scale
  numbers, and made the buttons round again — they had started rendering as
  ovals.

## 0.1.3 - 2026-06-06

- Aligned the answer buttons under the scale numbers on the questionnaire so
  each column lines up.

## 0.1.2 - 2026-06-06

- Fixed the questionnaire so the answer buttons lay out as a horizontal 0–5
  scale again instead of stacking in a single column. (Newer versions of
  django-crispy-forms changed how radio groups are rendered, which had broken
  the layout.)

## 0.1.1 - 2026-06-06

- Maintenance only: updated the release automation to current GitHub Actions.
  No changes to the app itself.

## 0.1.0 - 2026-06-06

- Initial release. The MAIA-2 (Multidimensional Assessment of Interoceptive
  Awareness, version 2) questionnaire packaged as a reusable, pip-installable
  Django app — questionnaire models and scoring, the question/category and
  norm-comparison fixtures, a `seed_maia2` management command to load them, and
  the compiled stylesheet shipped inside the wheel.
