# Tests

This test suite covers both connector operations: sending a single custom event occurrence (`sendEvent`) and sending a batch of event occurrences (`sendEventBatch`).

## Prerequisites

- JDK 21, Ballerina Swan Lake, and Docker running (per the root `README.md` "Build from the source"
  section).
- A GitHub PAT with `read:packages`, exported as `packageUser`/`packagePAT`, if building via Gradle.

## Running Tests

Run from the `ballerina` directory (the package root):

```bash
bal test
```

By default, the test suite runs against a local mock server (`tests/mock_service.bal`) that intercepts
HTTP calls, so **no real HubSpot credentials are required** for this default mode.

To run against a real HubSpot account instead, set `IS_LIVE_SERVER=true` and export
`HUBSPOT_ACCESS_TOKEN` with a valid [Service Key](../../README.md#step-1-create-a-service-key) — in
that mode, real credentials (and an existing custom event definition, see the root README's setup
guide) are required:

```bash
IS_LIVE_SERVER=true HUBSPOT_ACCESS_TOKEN="<your-access-token>" bal test
```
