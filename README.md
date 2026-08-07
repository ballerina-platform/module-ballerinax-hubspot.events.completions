# Ballerina Hubspot.events.completions connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.events.completions/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.events.completions/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.events.completions.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.events.completions/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.events.completions.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.events.completions)

## Overview

[HubSpot](https://www.hubspot.com/) is a CRM platform that lets you track custom behavioral events for the contacts and objects in your account. The Events Send Event Completions API lets external systems report that a custom-defined event occurred, so that HubSpot workflows, reporting, and CRM timelines stay up to date with real-world activity happening outside of HubSpot.

The HubSpot Events Completions connector provides Ballerina bindings for the HubSpot Events Send API v3, allowing users to report custom behavioral event completions within their applications.

## Key Features

- Report a single custom behavioral event occurrence to HubSpot in real time
- Submit a batch of up to 500 event occurrences in a single call
- Authenticate using HubSpot OAuth bearer tokens, including the current Service Key flow

## Setup guide

To use this connector, you need a HubSpot access token authorized with the `analytics.behavioral_events.send` scope, and at least one existing custom event definition to report completions for.

### Step 1: Create a Service Key

HubSpot is moving single-account API access from legacy Private Apps to **Service Keys**. Service Keys are currently in **public beta** and subject to change, but are HubSpot's recommended path going forward. To create one:

1. Log in to your [HubSpot account](https://app.hubspot.com/).
2. Go to **Settings** > **Account Setup** > **Integrations** > **Service Keys**, and click **Create service key**.
3. Give it a name (e.g. `hubspot-events-completions`), then click **Add new scope** and search for `behavioral_events.send`. Select `analytics.behavioral_events.send`.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.events.completions/main/docs/setup/resources/service-key-select-scope.jpg" alt="Selecting the analytics.behavioral_events.send scope" width="600">

4. Click **Create**. Copy the generated **service key** — this is the bearer token the connector uses to authenticate. Treat it like a password; it is only shown in full once.

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.events.completions/main/docs/setup/resources/service-key-created.jpg" alt="Service key created with scopes assigned" width="600">

   All your service keys are listed under **Service Keys** for future reference:

   <img src="https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.events.completions/main/docs/setup/resources/service-keys-list.jpg" alt="Service Keys list page" width="600">

> **Note:** The `analytics.behavioral_events.send` scope is available to **Professional or Enterprise** HubSpot accounts. If your account doesn't have access to it, a [HubSpot developer test account](https://developers.hubspot.com/get-started) can be used to test against this API without a paid subscription.

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

1. [Track customer purchase events](examples/track_customer_purchase_events/track_customer_purchase_events.md) — Send a single purchase event in real time, then batch-report a set of accumulated page-view events.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.events.completions` package](https://central.ballerina.io/ballerinax/hubspot.events.completions/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
