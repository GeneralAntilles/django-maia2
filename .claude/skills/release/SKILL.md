---
name: release
description: Cut a django-maia2 release. Use when the user wants to publish a new version of this package — drafts plain-language CHANGELOG.md bullets from the commits since the last tag, bumps the version in pyproject.toml, tags, and pushes. The release GitHub Action then builds + publishes the wheel and uses the new CHANGELOG section as the GitHub Release notes.
---

# Release django-maia2

Cut a new release of this package. The `release` workflow
(`.github/workflows/release.yml`) builds + publishes the wheel on a `vX.Y.Z`
tag and uses the matching `CHANGELOG.md` section as the GitHub Release body —
so **the changelog bullets must be written before the tag is pushed.**

## Input

- **Target version**: from the user (e.g. `/release 0.1.5`). If they didn't give
  one, propose the next patch bump from the latest tag and confirm before doing
  anything.

## Steps

1. **Preflight.** Make sure you're on `main`, the working tree is clean, and
   you're up to date (`git switch main && git pull`). Stop if the tree is dirty.

2. **Gather what changed.** Find the last tag and review the range:
   ```
   LAST=$(git describe --tags --abbrev=0)
   git log --no-merges --stat "$LAST"..HEAD
   git diff "$LAST"..HEAD        # skim for user-visible behavior changes
   ```

3. **Draft plain-language bullets.** Write for someone *using* the questionnaire
   app, not for developers:
   - Describe the **effect** ("answer buttons line up under their 0–5 numbers"),
     not the implementation ("flex `display:contents`").
   - One bullet per user-visible change. Group under `### Added` / `### Changed`
     / `### Fixed` only if there are several; a flat list is fine otherwise.
   - Leave out pure internal churn (CI tweaks, refactors, formatting) unless
     that's all there is — then summarize as "Maintenance: …".

4. **Update `CHANGELOG.md`.** Insert a new section at the top (newest first),
   dated today, **exactly** in this format (note the single space after the
   version — the workflow extracts the section by matching `## <version> `):
   ```
   ## <version> - <YYYY-MM-DD>

   - <bullet>
   - <bullet>
   ```

5. **Bump the version.** Set `version = "<version>"` in `pyproject.toml`.

6. **Confirm.** Show the user the drafted CHANGELOG section and the version bump.
   Get a yes before pushing (the push triggers a public release).

7. **Commit, tag, push:**
   ```
   git add CHANGELOG.md pyproject.toml
   git commit -m "Release <version>"
   git tag "v<version>"
   git push origin main "v<version>"
   ```

8. **Verify.** Watch the run (`gh run watch <id> --exit-status`) and confirm the
   wheel published and the notes match the changelog
   (`gh release view "v<version>"`).

## Notes

- You do **not** build the CSS or the wheel here — the workflow does that and
  gates that the wheel contains `maia_v2/static/css/main.css`.
- If this app is pinned by a deployment (e.g. the abelify site's
  `MAIA2_WHEEL_VERSION`), remind the user to bump that pin separately — it is
  **not** part of this release.
