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
final string serviceUrl = isLiveServer ? "https://api.avaza.com/api" : "http://localhost:9090";
final string accessToken = isLiveServer ? os:getEnv("AVAZA_ACCESS_TOKEN") : "test_token";

final Client avaza = check new ({auth: {token: accessToken}, httpVersion: http:HTTP_1_1}, serviceUrl);

// Identifiers of entities that exist in the mock. Live runs read them from the environment.
final int:Signed32 companyId = isLiveServer ? <int:Signed32>(check int:fromString(os:getEnv("AVAZA_COMPANY_ID"))) : 1001;
final int:Signed32 invoiceId = isLiveServer ? <int:Signed32>(check int:fromString(os:getEnv("AVAZA_INVOICE_ID"))) : 9001;
final int:Signed32 projectId = isLiveServer ? <int:Signed32>(check int:fromString(os:getEnv("AVAZA_PROJECT_ID"))) : 2001;
final int:Signed32 sectionId = isLiveServer ? <int:Signed32>(check int:fromString(os:getEnv("AVAZA_SECTION_ID"))) : 4001;
final int:Signed32 taskId = isLiveServer ? <int:Signed32>(check int:fromString(os:getEnv("AVAZA_TASK_ID"))) : 3001;
final int:Signed32 timesheetId = isLiveServer ? <int:Signed32>(check int:fromString(os:getEnv("AVAZA_TIMESHEET_ID"))) : 6001;
final int:Signed32 timesheetCategoryId = isLiveServer ? <int:Signed32>(check int:fromString(os:getEnv("AVAZA_TIMESHEET_CATEGORY_ID"))) : 10;

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetAccount() returns error? {
    AccountDetails account = check avaza->getAccount();
    test:assertTrue(account.accountID is int);
    test:assertTrue(account.companyName is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListCompanies() returns error? {
    CompanyList result = check avaza->listCompanies(pageSize = 20, pageNumber = 1);
    Company[] companies = result.companies ?: [];
    test:assertTrue(companies.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetCompany() returns error? {
    Company company = check avaza->getCompany(companyId);
    test:assertEquals(company.companyID, companyId);
}

@test:Config {groups: ["mock_tests"]}
function testCreateCompany() returns error? {
    if isLiveServer {
        return;
    }
    Company company = check avaza->createCompany({companyName: "Umbrella Logistics", currencyCode: "USD"});
    test:assertEquals(company.companyName, "Umbrella Logistics");
    test:assertTrue(company.companyID is int);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListContacts() returns error? {
    ContactList result = check avaza->listContacts(pageSize = 20);
    CompanyContact[] contacts = result.contacts ?: [];
    // A live account may have no contacts; the call returning a typed list is the check there.
    if !isLiveServer {
        test:assertTrue(contacts.length() > 0);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListInvoices() returns error? {
    InvoiceList result = check avaza->listInvoices(pageSize = 20);
    Invoice[] invoices = result.invoices ?: [];
    // A live account may have no invoices; the call returning a typed list is the check there.
    if !isLiveServer {
        test:assertTrue(invoices.length() > 0);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetInvoice() returns error? {
    Invoice invoice = check avaza->getInvoice(invoiceId);
    test:assertEquals(invoice.transactionID, invoiceId);
}

@test:Config {groups: ["mock_tests"]}
function testCreateInvoice() returns error? {
    if isLiveServer {
        return;
    }
    Invoice invoice = check avaza->createInvoice({companyIDFK: companyId, subject: "Consulting - March", currencyCode: "USD"});
    test:assertEquals(invoice.subject, "Consulting - March");
    test:assertEquals(invoice.transactionStatusCode, "Draft");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListProjects() returns error? {
    ProjectList result = check avaza->listProjects(pageSize = 20);
    ProjectListDetails[] projects = result.projects ?: [];
    test:assertTrue(projects.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetProject() returns error? {
    ProjectDetails project = check avaza->getProject(projectId);
    test:assertEquals(project.projectID, projectId);
}

@test:Config {groups: ["mock_tests"]}
function testCreateProject() returns error? {
    if isLiveServer {
        return;
    }
    ProjectDetails project = check avaza->createProject({projectTitle: "Mobile App", companyIDFK: companyId});
    test:assertEquals(project.title, "Mobile App");
}

@test:Config {groups: ["mock_tests"]}
function testUpdateProject() returns error? {
    if isLiveServer {
        return;
    }
    ProjectDetails project = check avaza->updateProject({
        projectID: projectId,
        projectTitle: "Website Redesign Phase 2",
        fieldsToUpdate: ["ProjectTitle"]
    });
    test:assertEquals(project.title, "Website Redesign Phase 2");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListTasks() returns error? {
    TaskList result = check avaza->listTasks(projectID = projectId);
    TaskDetails[] tasks = result.tasks ?: [];
    test:assertTrue(tasks.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetTask() returns error? {
    TaskDetails task = check avaza->getTask(taskId);
    test:assertEquals(task.taskID, taskId);
}

@test:Config {groups: ["mock_tests"]}
function testCreateTask() returns error? {
    if isLiveServer {
        return;
    }
    TaskDetails task = check avaza->createTask({projectIDFK: projectId, sectionIDFK: sectionId, title: "Write release notes"});
    test:assertEquals(task.title, "Write release notes");
}

@test:Config {groups: ["mock_tests"]}
function testUpdateTask() returns error? {
    if isLiveServer {
        return;
    }
    TaskDetails task = check avaza->updateTask({taskID: taskId, title: "Review homepage mockups", fieldsToUpdate: ["Title"]});
    test:assertEquals(task.title, "Review homepage mockups");
}

@test:Config {groups: ["mock_tests"]}
function testDeleteTask() returns error? {
    if isLiveServer {
        return;
    }
    TaskDetails created = check avaza->createTask({projectIDFK: projectId, sectionIDFK: sectionId, title: "Temporary task"});
    int createdId = check created.taskID.ensureType();
    record {} result = check avaza->deleteTask(createdId);
    test:assertTrue(result.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListTimesheets() returns error? {
    TimesheetList result = check avaza->listTimesheets(pageSize = 20);
    TimesheetListDetails[] timesheets = result.timesheets ?: [];
    test:assertTrue(timesheets.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetTimesheet() returns error? {
    TimesheetDetails timesheet = check avaza->getTimesheet(timesheetId);
    test:assertEquals(timesheet.timesheetEntryID, timesheetId);
}

@test:Config {groups: ["mock_tests"]}
function testCreateTimesheet() returns error? {
    if isLiveServer {
        return;
    }
    TimesheetDetails timesheet = check avaza->createTimesheet({
        projectIDFK: projectId,
        timesheetCategoryIDFK: timesheetCategoryId,
        duration: 1.5,
        notes: "Sprint planning"
    });
    test:assertEquals(timesheet.notes, "Sprint planning");
}

@test:Config {groups: ["mock_tests"]}
function testDeleteTimesheet() returns error? {
    if isLiveServer {
        return;
    }
    TimesheetDetails created = check avaza->createTimesheet({
        projectIDFK: projectId,
        timesheetCategoryIDFK: timesheetCategoryId,
        duration: 0.5
    });
    int createdId = check created.timesheetEntryID.ensureType();
    record {} result = check avaza->deleteTimesheet(createdId);
    test:assertTrue(result.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListExpenses() returns error? {
    ExpenseList result = check avaza->listExpenses(pageSize = 20);
    ExpenseDetails[] expenses = result.expenses ?: [];
    // A live account may have no expenses; the call returning a typed list is the check there.
    if !isLiveServer {
        test:assertTrue(expenses.length() > 0);
    }
}

@test:Config {groups: ["mock_tests"]}
function testCreateExpense() returns error? {
    if isLiveServer {
        return;
    }
    ExpenseDetails expense = check avaza->createExpense({
        merchant: "Metro Rail",
        amount: 24.00,
        expenseDate: "2026-03-10",
        expenseCategoryName: "Travel",
        projectIDFK: projectId
    });
    test:assertEquals(expense.merchant, "Metro Rail");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListUserProfiles() returns error? {
    UserList result = check avaza->listUserProfiles();
    UserDetails[] users = result.users ?: [];
    test:assertTrue(users.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testListWebhooks() returns error? {
    WebhookList result = check avaza->listWebhooks();
    WebhookDetails[] webhooks = result.webhooks ?: [];
    // A live account may have no webhooks; the call returning a typed list is the check there.
    if !isLiveServer {
        test:assertTrue(webhooks.length() > 0);
    }
}
