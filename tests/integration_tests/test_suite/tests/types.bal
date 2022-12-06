type Package record {
    string organization;
    string name;
    string 'version;
    string URL;
    string visibility;
    Module[] modules;
};

type Module record {
    string name;
    string apiDocURL;
    string packageURL;
};

type DocModule record {
    ModuleInfo[] modules;
};

type ModuleInfo record {
    string id;
    RelatedModule[] relatedModules;
    FunctionInfo[] functions;
    anydata[] records;
    anydata[] objectTypes;
    anydata[] listeners; 
    anydata[] types; 
    anydata[] enums; 
};

type FunctionInfo record {
    string name;
};

type RelatedModule record {
    string id;
    string summary;
    string orgName;
    string 'version;
    boolean isDefaultModule;
};

type APIDocResponse record {
    DocModule docsData;
    SearchData searchData;
};

type SearchData record {
    Function[] functions;
};

type Function record {
    string description;
    string id;
    string moduleId;
    string moduleOrgName;
    string moduleVersion;
};
