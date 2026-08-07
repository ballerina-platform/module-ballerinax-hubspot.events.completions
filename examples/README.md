# Examples

The `ballerinax/hubspot.events.completions` connector provides practical examples illustrating usage in various scenarios.

| Example | Description |
|---------|-------------|
| [`track_customer_purchase_events`](./track_customer_purchase_events/track_customer_purchase_events.md) | Send a single purchase event in real time, then batch-report a set of accumulated page-view events. |

## Prerequisites

1. Build and push the connector to your local Ballerina repository (run from the repository root;
   the parentheses run this in a subshell so your current directory doesn't change):
   ```bash
   (cd ballerina && bal pack && bal push --repository=local)
   ```

2. For each example, create a `Config.toml` in the example directory with the required credentials.
   Some examples require additional configuration (e.g. HubSpot custom event tracking IDs) — see the
   example's own README for the exact fields:
   ```toml
   accessToken = "<your-hubspot-access-token>"
   ```

## Running an example

From the repository root, enter the example's directory, then build or run it from there:

* To build an example:

    ```bash
    cd examples/<example-name>
    bal build
    ```

* To run an example:

    ```bash
    cd examples/<example-name>
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
