# Tests

This test suite covers both connector operations: sending a single custom event occurrence (`sendEvent`) and sending a batch of event occurrences (`sendEventBatch`).

## Running Tests

```bash
bal test
```

The test suite uses a mock server (`tests/mock_service.bal`) that intercepts HTTP calls so no real credentials are required.
