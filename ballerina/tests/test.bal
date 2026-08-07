// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.hubapi.com/events/v3/send" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("HUBSPOT_ACCESS_TOKEN") : "test-token";

final Client baseClient = check new ({auth: {token}}, serviceUrl = serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testSendEvent() returns error? {
    EventOccurrence payload = {
        eventName: "pe1234_custom_event",
        email: "test@example.com",
        occurredAt: "2026-08-07T10:00:00Z",
        properties: {
            "amount": "100"
        }
    };
    http:Response response = check baseClient->sendEvent(payload);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testSendEventBatch() returns error? {
    BatchEventOccurrence payload = {
        inputs: [
            {
                eventName: "pe1234_custom_event",
                email: "test1@example.com",
                occurredAt: "2026-08-07T10:00:00Z",
                properties: {
                    "amount": "100"
                }
            },
            {
                eventName: "pe1234_custom_event",
                email: "test2@example.com",
                occurredAt: "2026-08-07T10:05:00Z",
                properties: {
                    "amount": "200"
                }
            }
        ]
    };
    http:Response response = check baseClient->sendEventBatch(payload);
    test:assertEquals(response.statusCode, 204);
}
