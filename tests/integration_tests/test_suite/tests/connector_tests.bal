import ballerina/test;
import ballerina/http;
// import ballerina/io;

@test:Config { }
function testConnectorMain() returns error? {
    test:assertTrue(connectorMain());
    test:assertTrue(check connectorClientOne());
    test:assertTrue(check connectorClientTwo());
}

@test:Config {dependsOn: [testNormalPackage] } //For some reason parreral execusion does not work with the frontend
function testConnectorPackage() returns error? {

    // UI Page
    http:Response resp = check centralClient -> get("anjanasupun/sample_connector");
    test:assertEquals(resp.statusCode, 200);

    //API
    Package packageResp = check centralApiClient -> get("registry/packages/anjanasupun/sample_connector/0.1.0");
    test:assertEquals(packageResp.organization, "anjanasupun");
    test:assertEquals(packageResp.name, "sample_connector");
    test:assertEquals(packageResp.'version, "0.1.0");
    test:assertEquals(packageResp.URL, "/anjanasupun/sample_connector/0.1.0");
    test:assertEquals(packageResp.visibility, "public");

    Module[] modules = packageResp.modules;
    test:assertEquals(modules.length(), 3);

    test:assertEquals(modules[0].name, "sample_connector");
    test:assertEquals(modules[1].name, "sample_connector.module1");
    test:assertEquals(modules[2].name, "sample_connector.module2");
}

@test:Config { }
function testConnectorApiDocs() returns error? {
    http:Response resp = check apiDocsClient -> get("anjanasupun/sample_connector/0.1.0");
    test:assertEquals(resp.statusCode, 200);

    string[] versions = check centralApiClient -> get("registry/packages/anjanasupun/sample_connector?include-prereleases=true");
    test:assertEquals(versions[0], "0.1.0");

    APIDocResponse apiDocsResp = check centralApiClient -> get("docs/anjanasupun/sample_connector/0.1.0");
    test:assertEquals(apiDocsResp.searchData.functions[0].id, "testFuncMain");

    ModuleInfo modules = apiDocsResp.docsData.modules[0];
    
    test:assertEquals(modules.id, "sample_connector");
    test:assertEquals(modules.functions[0].name, "testFuncMain");

    RelatedModule[] relatedModules = modules.relatedModules;
    test:assertEquals(relatedModules[0].id, "sample_connector");
    test:assertEquals(relatedModules[1].id, "sample_connector.module1");
    test:assertEquals(relatedModules[2].id, "sample_connector.module2");
}


@test:Config { }
function testConnectorApi() returns error? {
    ConnectorResponse connectorResp = check centralApiClient -> get("registry/connectors?org=anjanasupun");
    Connector[] connectors = connectorResp.connectors;
    test:assertEquals(connectors.length(), 2);

    Connector connector1 = connectors[0];
    test:assertEquals(connector1.name, "FirstClient");
    test:assertEquals(connector1.displayName, "Test Connector2");
    test:assertEquals(connector1.moduleName, "sample_connector.module1");
    test:assertEquals(connector1.displayAnnotation.iconPath, "icon.png");
    test:assertEquals(connector1.displayAnnotation.label, "Test Connector2");
    test:assertEquals(connector1.package.name, "sample_connector");

    Connector connector2 = connectors[1];
    test:assertEquals(connector2.name, "SecondClient");
    test:assertEquals(connector2.displayName, "Test Connector2");
    test:assertEquals(connector2.moduleName, "sample_connector.module2");
    test:assertEquals(connector2.displayAnnotation.iconPath, "icon.png");
    test:assertEquals(connector2.displayAnnotation.label, "Test Connector2");
    test:assertEquals(connector2.package.name, "sample_connector");
}

type ConnectorResponse record {
    Connector[] connectors;
};

type Connector record {
    int id;
    string name;
    string displayName;
    string moduleName;
    DisplayAnnotation displayAnnotation;
    Package package;

};

type DisplayAnnotation record {
    string label;
    string iconPath;
};
