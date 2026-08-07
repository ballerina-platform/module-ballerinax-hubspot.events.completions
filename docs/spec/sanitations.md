_Author_: @daneshk \
_Created_: 2026/08/07 \
_Updated_: 2026/08/07 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Hubspot.events.completions.
The OpenAPI specification is obtained from HubSpot's [Custom Events Completions Guide](https://developers.hubspot.com/docs/guides/api/analytics-and-events/custom-events/custom-event-completions).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. The top-level API description ("Endpoint to create, delete and get behavioral event definitions")
   describes a different HubSpot API (event *definition* management) than what this spec's two
   operations actually do (report event *occurrences*). The original description is preserved
   verbatim in `sendEventCompletions.json` (the upstream input), but corrected in the aligned spec —
   and therefore in the generated `client.bal` doc comment — to accurately describe this API:
   "Send single or batched custom behavioral event occurrences to HubSpot for existing event
   definitions."
2. Added `maxItems: 500` to `BatchEventOccurrence.inputs` (generates a `@constraint:Array
   {maxLength: 500}` on `BatchEventOccurrence.inputs` in `types.bal`). HubSpot's batch endpoint
   (`POST /events/v3/send/batch`) enforces a hard limit of 500 event occurrences per request; the
   original spec left `inputs` unbounded. This makes the connector reject an oversized batch locally
   with a clear constraint-violation error instead of only after a round trip to HubSpot.
3. Removed the `developer_hapikey`, `private_apps`, and `private_apps_legacy` API-key security
   schemes from `components.securitySchemes`. Both operations in this spec declare only
   `oauth2: [analytics.behavioral_events.send]` as their security requirement — the API-key schemes
   were never referenced by either operation, but `bal openapi` generates auth configuration for
   every declared scheme regardless of use, producing an `ApiKeysConfig` type and constructor branch
   in the client that accepted credentials the API never actually sends. Removing the unused schemes
   from the aligned spec keeps `ConnectionConfig.auth` limited to what these two operations actually
   support (`http:BearerTokenConfig | OAuth2RefreshTokenGrantConfig`).

Operation ID renames, schema renames, and description/summary enhancements made by the
`generating-connectors` skill's AI-assisted sanitation stage are tracked separately in
`docs/spec/ai-mappings.json`, keyed by path/method and schema name, so that a future regeneration
against an updated spec reuses the same names instead of re-deciding them.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the `ballerina` directory.

```bash
bal openapi -i ../docs/spec/aligned_ballerina_openapi.json -o . --mode client --client-methods remote --license ../docs/license.txt
```
