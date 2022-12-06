// Use packages pushed in previously pushed packages and implement something.
import anjanasupun/normal_package;
import anjanasupun/sample_connector;
import anjanasupun/sample_connector.module1;
import anjanasupun/sample_connector.module2;
import anjanasupun/sample_trigger;

public function greetAnimal() returns string {
    return "Hello " + normal_package:greet();
}

public function connectorMain() returns boolean {
    return sample_connector:testFuncMain("a",1,2);
}

public function connectorClientOne() returns boolean|error {
    module1:FirstClient firstClient = check new module1:FirstClient({}, "test");
    return firstClient.testFunc1("a",1,2);
}

public function connectorClientTwo() returns boolean|error {
    module2:SecondClient firstClient = check new module2:SecondClient("test");
    return firstClient.testFunc1("a",1,2);
}




boolean webhookRegistrationNotified = false;
string webhookHookType = "";

boolean issueCreationNotified = false;
string issueTitle = "";

boolean issueLabeledNotified = false;
string issueLabels = "";

boolean issueAssignedNotified = false;
string issueAssignee = "";

boolean issueEditedNotified = false;
sample_trigger:Changes? issueChanges = ();

int createdIssueNumber = -1;

configurable string githubSecret = "q234";

configurable sample_trigger:ListenerConfig userInput = {
    webhookSecret: githubSecret
};

listener sample_trigger:Listener githubListener = new (userInput, 8090);

service sample_trigger:IssuesService on githubListener {
    
    remote function onAssigned(sample_trigger:IssuesEvent payload) returns error? {
       issueAssignedNotified = true;
       sample_trigger:User assignee = <sample_trigger:User> payload.issue.assignee;
       issueAssignee = <@untainted> assignee.login;
    }

    remote function onClosed(sample_trigger:IssuesEvent payload) returns error? {
        return;
    } 

    remote function onLabeled(sample_trigger:IssuesEvent payload) returns error? {
        issueLabeledNotified = true;
        string receivedIssueLabels = "";
        foreach sample_trigger:Label label in payload.issue.labels {
            receivedIssueLabels += label.name;
        }
        issueLabels = <@untainted> receivedIssueLabels;
    }

    remote function onOpened(sample_trigger:IssuesEvent payload) returns error? {
        issueCreationNotified = true;
        issueTitle = <@untainted> payload.issue.title;
    }

    remote function onReopened(sample_trigger:IssuesEvent payload) returns error? {
        return;
    }

    remote function onUnassigned(sample_trigger:IssuesEvent payload) returns error? {
        return;
    }

    remote function onUnlabeled(sample_trigger:IssuesEvent payload) returns error? {
        return;
    }
}
