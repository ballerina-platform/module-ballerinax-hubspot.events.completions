# Track customer purchase events

This example sends a single custom event the moment a customer completes a purchase, then batch-reports a set of page-view events the same customer generated earlier in their session — demonstrating both the real-time (`sendEvent`) and batch (`sendEventBatch`) operations together.

## Prerequisites

- Ballerina Swan Lake 2201.x or later
- Push the connector to the local repository:
  ```bash
  cd ballerina
  bal pack && bal push --repository=local
  ```
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<your-hubspot-access-token>"
  ```

## Run the example

```bash
bal run
```
