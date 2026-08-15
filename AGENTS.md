# Tracebook project guidance

## Product

Tracebook is a read-only iOS companion to trace-book.org, a community measurement library for live sound engineers. The website and its Bubble API are the source of truth. Upload, authentication, editing, and moderation remain website responsibilities.

The app should provide dependable access to public measurements, including previously synchronized data when internet access is unavailable. Prefer simple, low-maintenance, reliable designs over rapid feature growth. Marcus is the sole app maintainer and release owner; build numbers are managed by Xcode Cloud.

## Engineering priorities

- Preserve valid cached measurements and content when synchronization fails.
- Keep SwiftData models and their `ModelContext` on the main actor.
- Keep shared file and image-cache state actor-isolated.
- Do not regress interactive chart redraw performance; avoid repeated full-array construction in chart bodies.
- Treat API response shape and availability as external constraints. Decode and pagination failures must be explicit and testable.
- Keep production dependencies injectable where deterministic tests need substitutes, while retaining simple production defaults.
- Maintain Swift 6 compatibility and compile with concurrency warnings treated seriously.

## Workflow

- Orient to repository documentation, branch, and dirty state before changing files.
- Work on one coherent slice at a time unless Marcus approves parallel work.
- Define owned files, exclusions, acceptance criteria, and tests before delegating a specialist task.
- Preserve unrelated and user-authored changes. Never use broad staging in a dirty worktree; stage explicit paths only.
- Verify focused tests first, then the broader relevant suite and a warning-as-error build.
- Review the staged diff before making one focused commit. Do not push or trigger Xcode Cloud without Marcus's approval.
- Report the commit SHA, changed files, decisions, assumptions, exact test results, risks, and remaining work.
- Keep exploration separate from production changes. Record important architectural or product decisions in repository documentation.

## Release boundaries

- `main` triggers Xcode Cloud and TestFlight builds.
- `MARKETING_VERSION` is repository-managed; Xcode Cloud manages build numbers.
- A passing local build is not permission to publish. Keep release candidates behaviorally narrow and report any scope expansion.

## Verification

Use an installed simulator destination shown by `xcodebuild -showdestinations`. The core local gate is:

```sh
xcodebuild test -quiet \
  -project Tracebook.xcodeproj \
  -scheme Tracebook \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' \
  -only-testing:TracebookTests \
  SWIFT_TREAT_WARNINGS_AS_ERRORS=YES \
  GCC_TREAT_WARNINGS_AS_ERRORS=YES
```

Do not assume UI tests are configured to run merely because the UI-test target compiles.
