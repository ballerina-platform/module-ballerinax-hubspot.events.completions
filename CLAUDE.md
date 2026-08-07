# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository state

This is a **Ballerina connector for the HubSpot Events Completions API**, scaffolded from the
`ballerina-platform` library repo template. As of now the connector has **not yet been generated**:

- `ballerina/client.bal` contains only the license header — no client code yet.
- `sendEventCompletions.json` (untracked, repo root) is the raw HubSpot OpenAPI spec
  ("Events Send Event Completions", v3 — send single/batch custom behavioral event occurrences)
  that the client is meant to be generated from.
- `README.md`, `ballerina/README.md`, `examples/README.md`, and `docs/spec/sanitations.md` are all
  template stubs with `TODO` markers — fill these in as part of connector generation, not before.

If asked to build/generate the connector, use the **connector-creator** skill — do not hand-write an
OpenAPI-to-Ballerina pipeline. The expected pipeline (mirrors `.claude/settings.local.json`) is:

1. `bal openapi flatten -i sendEventCompletions.json -o docs/spec` (run from `ballerina/`)
2. `bal openapi align -i docs/spec/flattened_openapi.json -o docs/spec`
3. `bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --license docs/license.txt --client-methods remote --mode client`
4. `bal build` (in `ballerina/`)
5. `bal pack` then `bal push --repository=local` (to make the module available to examples)
6. `bal build` inside each example under `examples/`

## Build / test commands

This is a Gradle multi-project build wrapping the Ballerina module (`settings.gradle` includes only
`ballerina/` as `hubspot.events.completions-ballerina`; `examples/` is built separately via its own
scripts, not part of the Gradle build).

From the repo root:

```bash
./gradlew clean build              # build the connector module
./gradlew clean test               # run tests (requires Docker daemon running)
./gradlew clean build -x test      # build without tests
./gradlew clean test -Pgroups=<g1,g2>   # run specific test groups/cases
./gradlew clean build -Pdebug=<port>        # debug with remote Java debugger
./gradlew clean build -PbalJavaDebug=<port> # debug with Ballerina language debugger
./gradlew clean build -PpublishToLocalCentral=true  # publish to local Ballerina Central
```

Prerequisites: JDK 21 (`JAVA_HOME` set), Ballerina Swan Lake, Docker running, and
`packageUser`/`packagePAT` (GitHub PAT with read:packages) exported for the WSO2/ballerina-platform
Maven package repos referenced in `build.gradle`/`settings.gradle`.

Inside `ballerina/` directly (once client code exists), standard `bal` commands apply: `bal build`,
`bal test`, `bal pack`.

For `examples/`, use `./build.sh build` / `./build.sh run` (or `build.bat` on Windows) from
`examples/` — this packs+pushes the local module build to the local Central repo first, then builds
every example subdirectory against it (see `examples/build.sh`). Plain `bal build`/`bal run` inside an
individual example only works once the module is available in a resolvable repository.

## Architecture

- **Root (`build.gradle`, `settings.gradle`, `gradle.properties`)** — Gradle wrapper around the
  Ballerina module; applies `net.researchgate.release` for versioning/tagging (`tagTemplate =
  'v${version}'`, requires branch `release-<version>`) and delegates `build` to the ballerina
  subproject.
- **`ballerina/`** — the actual Ballerina package (`hubspot.events.completions`, org `ballerinax`).
  `ballerina/build.gradle` applies the `io.ballerina.plugin` Gradle plugin, marks
  `isConnector = true`, and regenerates `ballerina/Ballerina.toml` on each build from the template at
  `build-config/resources/Ballerina.toml` (placeholders `@project.version@` / `@toml.version@` are
  substituted by the `updateTomlFiles` task) — **don't hand-edit version fields in
  `ballerina/Ballerina.toml` directly**, edit `gradle.properties`/`build-config/resources/Ballerina.toml`
  instead.
- **`examples/`** — standalone Ballerina programs demonstrating connector usage; intentionally
  *outside* the Gradle build graph and built via `bal`/the `build.sh`/`build.bat` scripts against a
  locally-pushed module, since Ballerina doesn't support resolving unpublished local packages
  directly from single files.
- **`docs/spec/`** — holds the OpenAPI processing artifacts (flattened/aligned specs) and
  `sanitations.md`, which must document any manual changes made to the upstream OpenAPI spec before
  client generation (usability fixes, workarounds for Ballerina language limitations).
- **CI (`.github/workflows/`)** — every workflow is a thin wrapper calling a reusable workflow from
  `ballerina-platform/ballerina-library`; there is no connector-specific CI logic in this repo:
  - `ci.yml` → `build-connector-template.yml` (push to `main`/release branches)
  - `pull-request.yml` → `pr-build-connector-template.yml`
  - `release.yml` → `release-package-connector-template.yml`
  - `dev-stg-release.yml` → `dev-stage-central-publish-connector-template.yml` (manual dev/stage Central publish)
  - `auto-generate.yml` → `auto_generate_connector_template.yml@connector-automation` (manual, regenerates the connector from an OpenAPI URL)
