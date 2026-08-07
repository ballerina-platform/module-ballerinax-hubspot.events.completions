// Track a single customer purchase event in real time, then batch-report a set of
// accumulated page-view events collected earlier in the same session.

import ballerina/io;
import ballerinax/hubspot.events.completions;

// Configuration — create a Config.toml with these values before running.
// purchaseEventName/pageViewEventName must be internal names of custom event definitions
// that already exist in your HubSpot account (format: pe<hub-id>_<event-name>).
configurable string accessToken = ?;
configurable string purchaseEventName = ?;
configurable string pageViewEventName = ?;

public function main() returns error? {
    completions:Client baseClient = check new ({
        auth: {token: accessToken}
    });

    // Step 1: Send a single event the moment a customer completes a purchase.
    completions:EventOccurrence purchaseEvent = {
        eventName: purchaseEventName,
        email: "customer@example.com",
        occurredAt: "2026-08-07T10:00:00Z",
        properties: {
            "amount": "149.99",
            "product": "annual_subscription"
        }
    };
    _ = check baseClient->sendEvent(purchaseEvent);
    io:println("Purchase event sent");

    // Step 2: Batch-report the page views the same customer generated earlier.
    completions:BatchEventOccurrence pageViewBatch = {
        inputs: [
            {
                eventName: pageViewEventName,
                email: "customer@example.com",
                occurredAt: "2026-08-07T09:45:00Z",
                properties: {"page": "/pricing"}
            },
            {
                eventName: pageViewEventName,
                email: "customer@example.com",
                occurredAt: "2026-08-07T09:50:00Z",
                properties: {"page": "/checkout"}
            }
        ]
    };
    _ = check baseClient->sendEventBatch(pageViewBatch);
    io:println("Page view batch sent");
}
