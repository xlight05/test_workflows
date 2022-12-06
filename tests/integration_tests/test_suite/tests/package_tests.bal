import ballerina/test;
import ballerina/http;

@test:Config { }
function testPackageUse() {
    string greetingResponse = greetAnimal();
    test:assertEquals(greetingResponse, "Hello Woof!");
}

@test:Config { }
function testNormalPackage() returns error? {

    //UI Page
    http:Response resp = check centralClient -> get("anjanasupun/normal_package");
    test:assertEquals(resp.statusCode, 200);

    //API
    Package packageResp = check centralApiClient -> get("registry/packages/anjanasupun/normal_package/0.1.0");
    test:assertEquals(packageResp.organization, "anjanasupun");
    test:assertEquals(packageResp.name, "normal_package");
    test:assertEquals(packageResp.'version, "0.1.0");
    test:assertEquals(packageResp.URL, "/anjanasupun/normal_package/0.1.0");
    test:assertEquals(packageResp.visibility, "public");
}

@test:Config { }
function testNormalPackageApiDocs() returns error? {
    http:Response resp = check apiDocsClient -> get("anjanasupun/normal_package/0.1.0");
    test:assertEquals(resp.statusCode, 200);

    string[] versions = check centralApiClient -> get("registry/packages/anjanasupun/normal_package?include-prereleases=true");
    test:assertEquals(versions[0], "0.1.0");

    APIDocResponse apiDocsResp = check centralApiClient -> get("docs/anjanasupun/normal_package/0.1.0");
    test:assertEquals(apiDocsResp.searchData.functions[0].id, "greet");
}
