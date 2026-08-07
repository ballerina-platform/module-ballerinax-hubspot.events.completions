## Overview

[HubSpot](https://www.hubspot.com/) is a CRM platform that lets you track custom behavioral events for the contacts and objects in your account. The Events Send Event Completions API lets external systems report that a custom-defined event occurred, so that HubSpot workflows, reporting, and CRM timelines stay up to date with real-world activity happening outside of HubSpot.

The `ballerinax/hubspot.events.completions` connector provides Ballerina bindings for the HubSpot Events Send API v3. It supports:

- Sending a single custom event occurrence in real time (`sendEvent`).
- Sending a batch of accumulated event occurrences in one call (`sendEventBatch`).

## Setup guide

To use this connector, you need a HubSpot access token authorized with the `analytics.behavioral_events.send` scope, and at least one existing custom event definition to report completions for.

### Step 1: Create a Service Key

HubSpot is moving single-account API access from legacy Private Apps to **Service Keys**, which get full ongoing platform support. To create one:

1. Log in to your [HubSpot account](https://app.hubspot.com/).
2. Go to **Settings** > **Account Setup** > **Integrations** > **Service Keys**, and click **Create service key**.
3. Give it a name (e.g. `hubspot-events-completions`), then click **Add new scope** and search for `behavioral_events.send`. Select `analytics.behavioral_events.send`.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.events.completions/main/docs/setup/resources/service-key-select-scope.jpg" alt="Selecting the analytics.behavioral_events.send scope" width="600">

4. Click **Create**. Copy the generated **service key** — this is the bearer token the connector uses to authenticate. Treat it like a password; it is only shown in full once.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.events.completions/main/docs/setup/resources/service-key-created.jpg" alt="Service key created with scopes assigned" width="600">

   All your service keys are listed under **Service Keys** for future reference:

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.events.completions/main/docs/setup/resources/service-keys-list.jpg" alt="Service Keys list page" width="600">

> **Note:** If your account doesn't have access to the `analytics.behavioral_events.send` scope, this feature requires an **Enterprise-tier** subscription on the relevant HubSpot product. A [HubSpot developer test account](https://developers.hubspot.com/get-started) can be used to test against this API without a production Enterprise subscription.

### Step 2: Create a custom event definition

The Send Event Completions API only reports occurrences of events that **already exist** in your account — it does not create the event definition itself. Before calling `sendEvent`/`sendEventBatch`, create one:

1. Go to **Reports** > **Analytics Tools** > **Custom Events**, then **Create an event** > **Create custom event**.
2. Choose **Send via API** as the setup type, since this connector reports completions programmatically rather than from a tracked webpage.
3. Fill in the event name and any properties you plan to send (e.g. `amount`), link it to the **Contacts** object, and finish the wizard.
4. Note the **internal tracking ID** shown on the last step (format `pe<hub-id>_<event-name>`, e.g. `pe12345678_purchase_completed`) — this is the value to use as `eventName` in `EventOccurrence`/`BatchEventOccurrence`.

## Quickstart

To use the `hubspot.events.completions` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/hubspot.events.completions;
```

### Step 2: Instantiate a new connector

```ballerina
configurable string accessToken = ?;

completions:Client hubspotEvents = check new ({
    auth: {token: accessToken}
});
```

### Step 3: Invoke the connector operation

```ballerina
public function main() returns error? {
    completions:EventOccurrence event = {
        eventName: "pe1234_purchase_completed",
        email: "customer@example.com",
        properties: {"amount": "149.99"}
    };
    check hubspotEvents->sendEvent(event);
}
```

## Examples

The `hubspot.events.completions` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.events.completions/tree/main/examples/), covering the following use cases:

1. [Track customer purchase events](../examples/track_customer_purchase_events/track_customer_purchase_events.md) — Send a single purchase event in real time, then batch-report a set of accumulated page-view events.
