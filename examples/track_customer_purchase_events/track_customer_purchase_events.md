# Track customer purchase events

This example sends a single custom event the moment a customer completes a purchase, then batch-reports a set of page-view events the same customer generated earlier in their session — demonstrating both the real-time (`sendEvent`) and batch (`sendEventBatch`) operations together.

## Prerequisites

- Ballerina Swan Lake 2201.x or later
- A HubSpot [Service Key](../../README.md#step-1-create-a-service-key) with the
  `analytics.behavioral_events.send` scope, and two existing
  [custom event definitions](../../README.md#step-2-create-a-custom-event-definition) — one for the
  purchase event, one for the page-view event — since this API only reports occurrences of events
  that already exist in your account.
- Push the connector to the local repository (run from the repository root; the parentheses run this
  in a subshell so your current directory doesn't change):
  ```bash
  (cd ballerina && bal pack && bal push --repository=local)
  ```
- Create a `Config.toml` in this directory (`examples/track_customer_purchase_events/`), using the
  internal tracking IDs of your two custom event definitions (format `pe<hub-id>_<event-name>`):
  ```toml
  accessToken = "<your-hubspot-access-token>"
  purchaseEventName = "<your-purchase-event-tracking-id>"
  pageViewEventName = "<your-page-view-event-tracking-id>"
  ```

## Run the example

From the repository root:

```bash
cd examples/track_customer_purchase_events
bal run
```
