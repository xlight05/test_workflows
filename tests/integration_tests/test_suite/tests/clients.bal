import ballerina/http;

//TODO refactor this by making env configurable

http:Client centralApiClient = check new ("https://api.dev-central.ballerina.io/2.0/");
http:Client apiDocsClient = check new ("https://dev-lib.ballerina.io/");
http:Client centralClient = check new ("https://dev-central.ballerina.io/", {
    timeout: 20
});
