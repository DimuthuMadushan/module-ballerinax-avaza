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

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Deletes a task by its Task ID.
    #
    # + id - The ID of the task to delete. Supplied in the URL path, e.g. DELETE /api/Task/123
    # + sendWebhooks - If true, fires the task_deleted webhook to subscribed endpoints. Defaults to false
    # + return - returns can be any of following types 
    # http:Ok (The task was deleted successfully)
    # http:Forbidden (The authenticated user does not have permission to delete this task.)
    # http:NotFound (No task with the given ID was found.)
    # http:Conflict (Deletion is blocked because the task or a subtask has linked timesheets, invoiced fixed amounts, expenses, or schedule bookings.)
    resource function delete Task/[int id](@http:Query {name: "SendWebhooks"} boolean? sendWebhooks) returns record {}|xml|http:Forbidden|http:NotFound|http:Conflict {
        if id <= 0 {
            return http:NOT_FOUND;
        }
        return {"message": "Task deleted successfully", "taskID": id};
    }

    # Deletes a timesheet entry by its Timesheet Entry ID.
    #
    # + id - The Timesheet Entry ID of the entry to be deleted
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:Ok (Returns confirmation of the timesheet entry deletion.)
    resource function delete Timesheet/[int id](@http:Query {name: "SendWebhooks"} boolean? sendWebhooks) returns http:Unauthorized|http:NotFound|record {}|xml {
        if id <= 0 {
            return http:NOT_FOUND;
        }
        return {"message": "Timesheet entry deleted successfully", "timesheetEntryID": id};
    }

    # Retrieves configuration details for the authenticated Avaza account, including timesheet settings, currency, branding, and feature flags.
    #
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns the account configuration details.)
    resource function get Account() returns http:Unauthorized|AccountDetails|xml {
        AccountDetails account = {
            accountID: 48213,
            timesheetDayOfWeek: 1,
            currentServerTimeISO: "2026-03-14T09:30:00Z",
            accountEmail: "billing@acmeconsulting.io",
            allowHidingCompletedTasksOnTimesheet: true,
            companyName: "Acme Consulting Ltd",
            receiptAIEnabled: true,
            has24HourTimesheetFormat: true,
            subdomain: "acmeconsulting",
            hasStartEndTimesheets: false,
            expenseApprovalRequired: true,
            lockApprovedTimesheets: true,
            defaultCurrencyCode: "USD",
            timesheetDisplayFormatCode: "HoursMinutes",
            brandPrimaryColor: "#1e88e5",
            lockApprovedExpenses: false,
            weeklyTimesheetReminder: true
        };
        return account;
    }

    # Retrieves a paginated list of customer companies with full details including contacts, billing address, and financial settings.
    #
    # + updatedAfter - Only return companies updated after this date-time (ISO 8601). Useful for incremental sync
    # + pageSize - Number of results per page. Maximum 1000, default 20
    # + pageNumber - 1-based page number to retrieve. Default 1
    # + sort - Sort results by: DateUpdated, DateCreated (append ' desc' for descending)
    # + includeCustomFields - Set false to omit the CustomFields collection from each company. Defaults to true
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns a paginated list of companies with full details including contacts.)
    resource function get Company(@http:Query {name: "UpdatedAfter"} string? updatedAfter, int:Signed32? pageSize, int:Signed32? pageNumber, @http:Query {name: "Sort"} string? sort, @http:Query {name: "IncludeCustomFields"} boolean? includeCustomFields) returns http:Unauthorized|CompanyList|xml {
        Company[] companies = [
            {
                companyID: 1001,
                companyName: "Globex Corporation",
                currencyCode: "USD",
                billingAddress: "742 Evergreen Terrace",
                billingAddressCity: "Springfield",
                billingAddressState: "OR",
                billingAddressPostCode: "97477",
                billingCountryCode: "US",
                phone: "+1-541-555-0142",
                website: "https://www.globex-corp.net",
                dateCreated: "2026-01-12T08:15:00Z",
                dateUpdated: "2026-02-20T14:05:00Z"
            },
            {
                companyID: 1002,
                companyName: "Initech Solutions",
                currencyCode: "EUR",
                billingAddress: "12 Rue de Rivoli",
                billingAddressCity: "Paris",
                billingCountryCode: "FR",
                phone: "+33-1-5555-0199",
                dateCreated: "2026-01-30T10:00:00Z",
                dateUpdated: "2026-02-28T09:40:00Z"
            }
        ];
        CompanyList result = {totalCount: 2, pageSize: 20, pageNumber: 1, companies};
        return result;
    }

    # Retrieves a single customer company by its Company ID, including contacts and billing address details.
    #
    # + id - The Company ID to retrieve
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:Ok (Returns the company details with contacts and billing address.)
    resource function get Company/[int id]() returns http:Unauthorized|http:NotFound|Company|xml {
        if id != 1001 {
            return http:NOT_FOUND;
        }
        Company company = {
            companyID: 1001,
            companyName: "Globex Corporation",
            currencyCode: "USD",
            billingAddress: "742 Evergreen Terrace",
            billingAddressCity: "Springfield",
            billingAddressState: "OR",
            billingAddressPostCode: "97477",
            billingCountryCode: "US",
            phone: "+1-541-555-0142",
            website: "https://www.globex-corp.net",
            viewCompanyURL: "https://acmeconsulting.avaza.com/Company/View/1001",
            contacts: [
                {
                    contactID: 5001,
                    companyIDFK: 1001,
                    firstname: "Hank",
                    lastname: "Scorpio",
                    email: "hank.scorpio@globex-corp.net",
                    positionTitle: "Procurement Lead"
                }
            ],
            dateCreated: "2026-01-12T08:15:00Z",
            dateUpdated: "2026-02-20T14:05:00Z"
        };
        return company;
    }

    # Retrieves a paginated list of external contacts (customer contacts) with company association details.
    #
    # + updatedAfter - Only return contacts updated after this date-time
    # + pageSize - Number of results per page. Maximum 1000, default 20
    # + pageNumber - 1-based page number to retrieve. Default 1
    # + sort - Sort results by: DateUpdated, DateCreated (append ' desc' for descending)
    # + companyIDFK - Filter contacts to a specific company by Company ID
    # + includeCustomFields - Set false to omit the CustomFields collection from each contact. Defaults to true
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns a paginated list of contacts with company association.)
    resource function get Contact(@http:Query {name: "UpdatedAfter"} string? updatedAfter, int:Signed32? pageSize, int:Signed32? pageNumber, @http:Query {name: "Sort"} string? sort, @http:Query {name: "CompanyIDFK"} int:Signed32? companyIDFK, @http:Query {name: "IncludeCustomFields"} boolean? includeCustomFields) returns http:Unauthorized|ContactList|xml {
        CompanyContact[] contacts = [
            {
                contactID: 5001,
                companyIDFK: 1001,
                companyName: "Globex Corporation",
                firstname: "Hank",
                lastname: "Scorpio",
                email: "hank.scorpio@globex-corp.net",
                phone: "+1-541-555-0143",
                positionTitle: "Procurement Lead"
            },
            {
                contactID: 5002,
                companyIDFK: 1002,
                companyName: "Initech Solutions",
                firstname: "Claire",
                lastname: "Dubois",
                email: "claire.dubois@initech-solutions.fr",
                positionTitle: "Finance Manager"
            }
        ];
        ContactList result = {totalCount: 2, pageSize: 20, pageNumber: 1, contacts};
        return result;
    }

    # Retrieves a paginated list of expense entries with rich filtering by date range, user, project, category, chargeable/invoiced status, approval status, and merchant.
    #
    # + updatedAfter - Only return expenses updated after this date-time. Format: MM/dd/yyyy hh:mm:ss tt
    # + expenseDateFrom - Filter expenses with an ExpenseDate on or after this date. Format: MM/dd/yyyy hh:mm:ss tt
    # + expenseDateTo - Filter expenses with an ExpenseDate on or before this date. Format: MM/dd/yyyy hh:mm:ss tt
    # + userEmail - Filter expenses by the email address of the expense user
    # + userID - Filter expenses by the UserID of the expense user
    # + categoryName - Filter expenses by expense category name (exact match)
    # + customerID - Filter expenses by Customer/Company ID
    # + projectID - Filter expenses by Project ID
    # + isChargeable - Filter by chargeable (billable) status: true for chargeable, false for non-chargeable
    # + isInvoiced - Filter by invoiced status: true for invoiced expenses, false for uninvoiced
    # + expenseReimbursementIDFK - Filter expenses by a specific reimbursement batch ID
    # + expensePaymentMethodIDFK - Filter expenses by payment method ID
    # + expenseApprovalStatusCode - Filter by approval status. Values: Draft, Rejected, Approved, AutoApproved, Pending, Verified
    # + search - Search expenses by matching against Merchant name and Expense Category Name
    # + pageSize - Number of items per page (max 1000)
    # + pageNumber - Page to display. Starts from 1
    # + sort - Sort by: DateUpdated, DateCreated, ExpenseDate (append ' desc' for descending)
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns a paginated list of expense entries with full details.)
    resource function get Expense(@http:Query {name: "UpdatedAfter"} string? updatedAfter, @http:Query {name: "ExpenseDateFrom"} string? expenseDateFrom, @http:Query {name: "ExpenseDateTo"} string? expenseDateTo, @http:Query {name: "UserEmail"} string? userEmail, @http:Query {name: "UserID"} int:Signed32? userID, @http:Query {name: "CategoryName"} string? categoryName, @http:Query {name: "CustomerID"} int:Signed32? customerID, @http:Query {name: "ProjectID"} int:Signed32? projectID, boolean? isChargeable, boolean? isInvoiced, @http:Query {name: "ExpenseReimbursementIDFK"} int? expenseReimbursementIDFK, @http:Query {name: "ExpensePaymentMethodIDFK"} int:Signed32? expensePaymentMethodIDFK, @http:Query {name: "ExpenseApprovalStatusCode"} string? expenseApprovalStatusCode, @http:Query {name: "Search"} string? search, int:Signed32? pageSize, int:Signed32? pageNumber, @http:Query {name: "Sort"} string? sort) returns http:Unauthorized|ExpenseList|xml {
        ExpenseDetails[] expenses = [
            {
                expenseID: 7001,
                merchant: "Skyline Airlines",
                notes: "Flight to client workshop",
                currencyCode: "USD",
                projectIDFK: 2001,
                expenseCategoryIDFK: 12,
                expenseApprovalStatusCode: "Approved",
                isReimbursable: true,
                taxAmount: 18.50,
                dateCreated: "2026-02-10T11:20:00Z"
            },
            {
                expenseID: 7002,
                merchant: "Downtown Cafe",
                notes: "Team lunch",
                currencyCode: "USD",
                projectIDFK: 2001,
                expenseCategoryIDFK: 14,
                expenseApprovalStatusCode: "Pending",
                isReimbursable: false,
                taxAmount: 4.20,
                dateCreated: "2026-02-12T13:45:00Z"
            }
        ];
        ExpenseList result = {totalCount: 2, pageSize: 20, pageNumber: 1, expenses};
        return result;
    }

    # Gets list of Invoices
    #
    # + updatedAfter - Only return invoices updated after this date-time
    # + pageSize - Number of items per page (max 1000)
    # + pageNumber - Page to display. Starts from 1
    # + transactionStatusCode - Filter by invoice status. Values: Draft, Sent, Late, Paid, Partial, Void
    # + issueDateFrom - Filter invoices issued on or after this date (ISO 8601)
    # + issueDateTo - Filter invoices issued before this date (ISO 8601)
    # + dueDateFrom - Filter invoices due on or after this date (ISO 8601)
    # + dueDateTo - Filter invoices due before this date (ISO 8601)
    # + sort - Sort results by: DateUpdated, DateCreated (append ' desc' for descending)
    # + companyIDFK - Filter invoices to a specific customer company by Company ID
    # + includeSourceLinks - When true, each line item also lists the IDs of the timesheets, expenses and fixed amounts linked to it (TimesheetEntryIDs / ExpenseIDs / FixedAmountIDs). Defaults to false to keep large list responses small
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns a paginated list of invoices with line items.)
    resource function get Invoice(@http:Query {name: "UpdatedAfter"} string? updatedAfter, int:Signed32? pageSize, int:Signed32? pageNumber, @http:Query {name: "TransactionStatusCode"} string? transactionStatusCode, @http:Query {name: "IssueDateFrom"} string? issueDateFrom, @http:Query {name: "IssueDateTo"} string? issueDateTo, @http:Query {name: "DueDateFrom"} string? dueDateFrom, @http:Query {name: "DueDateTo"} string? dueDateTo, @http:Query {name: "Sort"} string? sort, @http:Query {name: "CompanyIDFK"} int:Signed32? companyIDFK, @http:Query {name: "IncludeSourceLinks"} boolean? includeSourceLinks) returns http:Unauthorized|InvoiceList|xml {
        Invoice[] invoices = [
            {
                transactionID: 9001,
                invoiceNumber: "INV-0001",
                subject: "Website redesign - milestone 1",
                companyIDFK: 1001,
                companyName: "Globex Corporation",
                currencyCode: "USD",
                transactionStatusCode: "Sent",
                dateIssued: "2026-02-01",
                dueDate: "2026-03-03",
                totalAmount: 4800.00,
                balance: 4800.00
            },
            {
                transactionID: 9002,
                invoiceNumber: "INV-0002",
                subject: "Monthly retainer - February",
                companyIDFK: 1002,
                companyName: "Initech Solutions",
                currencyCode: "EUR",
                transactionStatusCode: "Paid",
                dateIssued: "2026-02-05",
                dueDate: "2026-03-07",
                totalAmount: 2500.00,
                balance: 0.00
            }
        ];
        InvoiceList result = {totalCount: 2, pageSize: 20, pageNumber: 1, invoices};
        return result;
    }

    # Retrieves a single invoice by its Transaction ID, including line items, issuer/recipient address details, and web links.
    #
    # + id - Invoice Transaction ID number
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:Ok (Returns the invoice details with line items, issuer/recipient, and links.)
    resource function get Invoice/[int id]() returns http:Unauthorized|http:NotFound|Invoice|xml {
        if id != 9001 {
            return http:NOT_FOUND;
        }
        Invoice invoice = {
            transactionID: 9001,
            invoiceNumber: "INV-0001",
            subject: "Website redesign - milestone 1",
            companyIDFK: 1001,
            companyName: "Globex Corporation",
            currencyCode: "USD",
            transactionStatusCode: "Sent",
            dateIssued: "2026-02-01",
            dueDate: "2026-03-03",
            notes: "Payment due within 30 days",
            taxAmount: 0.00,
            totalAmount: 4800.00,
            balance: 4800.00
        };
        return invoice;
    }

    # Retrieves a paginated list of projects with details including status, billing type, budget, category, and date range. Supports filtering by company, category, owner, status, billable type, budget type, and creation date.
    #
    # + updatedAfter - Only return projects updated after this UTC date-time (ISO 8601)
    # + pageSize - Number of items per page (max 1000)
    # + pageNumber - Page to display. Starts from 1
    # + sort - A column to sort on. Current possible values: "DateUpdated", "DateCreated", "DateUpdated desc", "DateCreated desc"
    # + timesheetUserID - Filter to the projects that the supplied UserID can add timesheets to
    # + companyID - Filter projects belonging to a specific customer company by Company ID
    # + projectCategoryID - Filter projects by project category ID
    # + projectOwnerUserID - Filter projects owned by a specific user by User ID
    # + projectStatusCode - Filter by project status code. Per-account configurable; default codes are NotStarted, InProgress, Complete, OnHold (seeded for every account); admins may add custom codes
    # + projectBillableTypeCode - Filter by billing type. Values: CategoryHourly, NoRate, NotBillable, PersonHourly, ProjectHourly
    # + projectBudgetTypeCode - Filter by budget type. Values: CategoryHours, NoBudget, PersonHours, ProjectFees, ProjectHours
    # + dateCreatedFrom - Filter projects created on or after this date (ISO 8601)
    # + dateCreatedTo - Filter projects created on or before this date (ISO 8601)
    # + includeArchived - Include Archived Projects in the results
    # + tags - Filter to projects assigned the supplied tag name(s). Repeat the parameter for multiple tags (e.g. ?Tags=Urgent&amp;Tags=Retainer). Names are matched case-insensitively; a name not in the account simply matches nothing. By default a project matches if it has ANY of the supplied tags (see TagMatchMode)
    # + tagMatchMode - How multiple Tags combine. "any" (default) returns projects with at least one of the supplied tags; "all" returns only projects that have every supplied tag
    # + includeCustomFields - Set false to omit the CustomFields collection from each project. Defaults to true
    # + includeBudget - Set true to include the computed budget fields on each project (EffectiveBudgetHours, SpentHours, SpentAmount - the same Budget and Spent the All Projects page shows). The page size is capped at 100 when set, because the values are computed per request. Defaults to false. The stored settings BudgetAmount / BudgetHours are always returned
    # + return - Returns a paginated list of projects with details 
    resource function get Project(@http:Query {name: "UpdatedAfter"} string? updatedAfter, int:Signed32? pageSize, int:Signed32? pageNumber, @http:Query {name: "Sort"} string? sort, @http:Query {name: "TimesheetUserID"} int:Signed32? timesheetUserID, @http:Query {name: "CompanyID"} int:Signed32? companyID, @http:Query {name: "ProjectCategoryID"} int:Signed32? projectCategoryID, @http:Query {name: "ProjectOwnerUserID"} int:Signed32? projectOwnerUserID, @http:Query {name: "ProjectStatusCode"} string? projectStatusCode, @http:Query {name: "ProjectBillableTypeCode"} string? projectBillableTypeCode, @http:Query {name: "ProjectBudgetTypeCode"} string? projectBudgetTypeCode, @http:Query {name: "DateCreatedFrom"} string? dateCreatedFrom, @http:Query {name: "DateCreatedTo"} string? dateCreatedTo, boolean? includeArchived, @http:Query {name: "Tags"} string[]? tags, @http:Query {name: "TagMatchMode"} string? tagMatchMode, @http:Query {name: "IncludeCustomFields"} boolean? includeCustomFields, @http:Query {name: "IncludeBudget"} boolean? includeBudget) returns ProjectList|xml {
        ProjectListDetails[] projects = [
            {
                projectID: 2001,
                title: "Website Redesign",
                projectCode: "WEB-01",
                companyIDFK: 1001,
                companyName: "Globex Corporation",
                projectStatusCode: "InProgress",
                projectBillableTypeCode: "ProjectHourly",
                projectBudgetTypeCode: "ProjectHours",
                budgetHours: 320.0,
                spentHours: 112.5,
                currencyCode: "USD",
                startDate: "2026-01-15",
                endDate: "2026-06-30",
                isArchived: false
            },
            {
                projectID: 2002,
                title: "ERP Migration",
                projectCode: "ERP-07",
                companyIDFK: 1002,
                companyName: "Initech Solutions",
                projectStatusCode: "NotStarted",
                projectBillableTypeCode: "PersonHourly",
                projectBudgetTypeCode: "NoBudget",
                currencyCode: "EUR",
                startDate: "2026-04-01",
                isArchived: false
            }
        ];
        ProjectList result = {totalCount: 2, pageSize: 20, pageNumber: 1, projects};
        return result;
    }

    # Retrieves full project details by Project ID, including sections, team members with rates and permissions, and project tags.
    #
    # + id - Project ID number
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:Ok (Returns full project details including sections, members, and tags.)
    resource function get Project/[int id]() returns http:Unauthorized|http:NotFound|ProjectDetails|xml {
        if id != 2001 {
            return http:NOT_FOUND;
        }
        ProjectDetails project = {
            projectID: 2001,
            title: "Website Redesign",
            projectCode: "WEB-01",
            companyIDFK: 1001,
            companyName: "Globex Corporation",
            projectStatusCode: "InProgress",
            projectStatusName: "In Progress",
            projectBillableTypeCode: "ProjectHourly",
            projectBudgetTypeCode: "ProjectHours",
            projectHourlyRate: 120.0,
            budgetHours: 320.0,
            spentHours: 112.5,
            currencyCode: "USD",
            startDate: "2026-01-15",
            endDate: "2026-06-30",
            notes: "Full redesign of the customer portal",
            isArchived: false,
            viewProjectURL: "https://acmeconsulting.avaza.com/Project/View/2001"
        };
        return project;
    }

    # Retrieves a paginated list of tasks with details including assignees, dates, status, priority, tags, and time tracking. Supports filtering by project, section, status, priority, due date range, assigned user, completion state, and parent task / hierarchy.
    #
    # + updatedAfter - Optional filter to records updated after a specific date
    # + pageSize - Number of items per page. Defaults to 20
    # + pageNumber - Page to display. Starts from 1. Defaults to 1
    # + sort - Optional sorting instruction. Currently possible values: "DateUpdated", "DateCreated", "DateUpdated desc", "DateCreated desc", "SectionTitle", "Title"
    # + isComplete - Optional filter to only display tasks linked to a Task Status where isComplete=false, or where isComplete=true
    # + projectID - Optional filter to only display tasks belonging to a specific ProjectID
    # + taskStatusCode - Optional filter to only display tasks with a specific status
    # + taskPriorityCode - Optional filter to only display tasks with a specific priority
    # + dueDateFrom - Optional filter to only display tasks with a Due Date after DueDateFrom
    # + dueDateTo - Optional filter to only display tasks with a Due Date before DueDateTo
    # + assignedToUserIDs - Optional filter to only display tasks with at least one of the provided UserIDs set as the Assigned User
    # + parentTaskIDFK - Optional filter to only display subtasks of the given parent task ID (i.e. tasks where ParentTaskIDFK = value)
    # + isRootLevel - Optional filter on task hierarchy. true = only root-level tasks (ParentTaskIDFK IS NULL); false = only subtasks (ParentTaskIDFK IS NOT NULL); omitted = no filter
    # + includeCustomFields - Set false to omit the CustomFields collection from each task. Defaults to true
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns a paginated list of tasks with full details.)
    resource function get Task(@http:Query {name: "UpdatedAfter"} string? updatedAfter, int:Signed32? pageSize, int:Signed32? pageNumber, @http:Query {name: "Sort"} string? sort, boolean? isComplete, @http:Query {name: "ProjectID"} int:Signed32? projectID, @http:Query {name: "TaskStatusCode"} string? taskStatusCode, @http:Query {name: "TaskPriorityCode"} string? taskPriorityCode, @http:Query {name: "DueDateFrom"} string? dueDateFrom, @http:Query {name: "DueDateTo"} string? dueDateTo, @http:Query {name: "AssignedToUserIDs"} int:Signed32[]? assignedToUserIDs, @http:Query {name: "ParentTaskIDFK"} int:Signed32? parentTaskIDFK, boolean? isRootLevel, @http:Query {name: "IncludeCustomFields"} boolean? includeCustomFields) returns http:Unauthorized|TaskList|xml {
        TaskDetails[] tasks = [
            {
                taskID: 3001,
                title: "Design homepage mockups",
                projectIDFK: 2001,
                sectionIDFK: 4001,
                sectionTitle: "Design",
                taskStatusCode: "InProgress",
                taskStatusName: "In Progress",
                taskPriorityCode: "High",
                estimatedEffort: 16.0,
                dateStart: "2026-02-02",
                dateDue: "2026-02-13"
            },
            {
                taskID: 3002,
                title: "Set up staging environment",
                projectIDFK: 2001,
                sectionIDFK: 4002,
                sectionTitle: "Engineering",
                taskStatusCode: "NotStarted",
                taskStatusName: "Not Started",
                taskPriorityCode: "Normal",
                estimatedEffort: 8.0,
                dateDue: "2026-02-20"
            }
        ];
        TaskList result = {totalCount: 2, pageSize: 20, pageNumber: 1, tasks};
        return result;
    }

    # Retrieves full task details by Task ID, including project context, section, assignees, dates, status, priority, tags, and time tracking information.
    #
    # + id - Task ID number
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:Ok (Returns the task details including assignees, tags, and status.)
    resource function get Task/[int id]() returns http:Unauthorized|http:NotFound|TaskDetails|xml {
        if id != 3001 {
            return http:NOT_FOUND;
        }
        TaskDetails task = {
            taskID: 3001,
            title: "Design homepage mockups",
            description: "Produce desktop and mobile mockups for the new homepage",
            projectIDFK: 2001,
            sectionIDFK: 4001,
            sectionTitle: "Design",
            taskStatusCode: "InProgress",
            taskStatusName: "In Progress",
            taskPriorityCode: "High",
            taskPriorityName: "High",
            estimatedEffort: 16.0,
            actualTime: 6.5,
            dateStart: "2026-02-02",
            dateDue: "2026-02-13",
            viewTaskURL: "https://acmeconsulting.avaza.com/Task/View/3001"
        };
        return task;
    }

    # Retrieves a paginated list of timesheet entries with rich filtering by date range, user, project, task, category, billable/invoiced status, approval status, and running timer state.
    #
    # + updatedAfter - Only return timesheets updated after this date-time
    # + entryDateFrom - Filter timesheets with an entry date on or after this date (ISO 8601)
    # + entryDateTo - Filter timesheets with an entry date on or before this date (ISO 8601)
    # + userID - The UserID of a timesheet user to filter timesheets for. Only api users with certain higher roles can see timesheets across multiple users
    # + userEmail - Filter timesheets by the email address of the timesheet user
    # + categoryName - Filter timesheets by category name
    # + timesheetEntryApprovalStatusCode - Filter by approval status. Values: Draft, Pending, AutoApproved, Approved, Rejected
    # + projectID - Filter timesheets by Project ID
    # + customerID - Only return timesheets whose project belongs to this customer company
    # + taskID - Filter timesheets by Task ID
    # + isBillable - Filter by billable status: true or false
    # + isInvoiced - Filter by invoiced status: true or false
    # + isTimerRunning - Filter to only entries that currently have a running timer (true) or not (false)
    # + pageSize - Number of items per page (max 1000)
    # + pageNumber - Page to display. Starts from 1
    # + includeInvoiceDetails - When true, includes invoice Transaction ID and line item ID for invoiced entries
    # + sort - Optional sorting instruction. Currently possible values: "DateUpdated", "DateCreated", "DateUpdated desc", "DateCreated desc","EntryDate", "EntryDate desc", "StartTimeLocal","StartTimeLocal desc", "TimeSheetEntryID", "TimeSheetEntryID desc"
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns a paginated list of timesheet entries with full details.)
    resource function get Timesheet(@http:Query {name: "UpdatedAfter"} string? updatedAfter, @http:Query {name: "EntryDateFrom"} string? entryDateFrom, @http:Query {name: "EntryDateTo"} string? entryDateTo, @http:Query {name: "UserID"} int:Signed32? userID, @http:Query {name: "UserEmail"} string? userEmail, @http:Query {name: "CategoryName"} string? categoryName, @http:Query {name: "TimesheetEntryApprovalStatusCode"} string? timesheetEntryApprovalStatusCode, @http:Query {name: "ProjectID"} int:Signed32? projectID, @http:Query {name: "CustomerID"} int:Signed32? customerID, @http:Query {name: "TaskID"} int:Signed32? taskID, boolean? isBillable, boolean? isInvoiced, boolean? isTimerRunning, int:Signed32? pageSize, int:Signed32? pageNumber, boolean? includeInvoiceDetails, @http:Query {name: "Sort"} string? sort) returns http:Unauthorized|TimesheetList|xml {
        TimesheetListDetails[] timesheets = [
            {
                timesheetEntryID: 6001,
                projectIDFK: 2001,
                projectTitle: "Website Redesign",
                taskIDFK: 3001,
                taskTitle: "Design homepage mockups",
                firstname: "Maria",
                lastname: "Lopez",
                email: "maria.lopez@acmeconsulting.io",
                duration: 3.5,
                isBillable: true,
                isInvoiced: false,
                notes: "Wireframe review with client",
                hasTimer: false
            },
            {
                timesheetEntryID: 6002,
                projectIDFK: 2001,
                projectTitle: "Website Redesign",
                taskIDFK: 3002,
                taskTitle: "Set up staging environment",
                firstname: "Tom",
                lastname: "Baker",
                email: "tom.baker@acmeconsulting.io",
                duration: 2.0,
                isBillable: true,
                isInvoiced: false,
                hasTimer: false
            }
        ];
        TimesheetList result = {totalCount: 2, pageSize: 20, pageNumber: 1, timesheets};
        return result;
    }

    # Retrieves a single timesheet entry by its Timesheet Entry ID, including user, project, category, approval, and timer details.
    #
    # + id - Timesheet Entry ID number
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:NotFound (Not Found)
    # http:Ok (Returns the timesheet entry details with user, project, and approval info.)
    resource function get Timesheet/[int id]() returns http:Unauthorized|http:NotFound|TimesheetDetails|xml {
        if id != 6001 {
            return http:NOT_FOUND;
        }
        TimesheetDetails timesheet = {
            timesheetEntryID: 6001,
            projectIDFK: 2001,
            projectTitle: "Website Redesign",
            taskIDFK: 3001,
            taskTitle: "Design homepage mockups",
            firstname: "Maria",
            lastname: "Lopez",
            email: "maria.lopez@acmeconsulting.io",
            duration: 3.5,
            isBillable: true,
            isInvoiced: false,
            notes: "Wireframe review with client",
            hasTimer: false,
            dateCreated: "2026-02-03T16:10:00Z"
        };
        return timesheet;
    }

    # Get Collection of Users who have roles in the current Avaza account.
    #
    # + roles - Optional list of comma separated role codes to filter users by (e.g. "TimesheetUser,Admin")
    # + tags - Comma-separated list of user tag names to filter users by
    # + currentUserOnly - Optional boolean (true/false) to filter to only show current authenticated user (always true for non Admin/Finance Manager users)
    # + companyIDFK - Optionally filter by Company ID
    # + email - Optionally filter by user email address
    # + includeCustomFields - Set false to omit the CustomFields collection from each user. Defaults to true
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns the list of users/team members with roles and tags.)
    resource function get UserProfile(@http:Query {name: "Roles"} string? roles, @http:Query {name: "Tags"} string? tags, @http:Query {name: "CurrentUserOnly"} boolean? currentUserOnly, @http:Query {name: "CompanyIDFK"} int:Signed32? companyIDFK, @http:Query {name: "Email"} string? email, @http:Query {name: "IncludeCustomFields"} boolean? includeCustomFields) returns http:Unauthorized|UserList|xml {
        UserDetails[] users = [
            {
                userID: 801,
                firstname: "Maria",
                lastname: "Lopez",
                email: "maria.lopez@acmeconsulting.io",
                positionTitle: "Senior Designer",
                isTeamMember: true,
                defaultBillableRate: 120.0,
                defaultCostRate: 55.0
            },
            {
                userID: 802,
                firstname: "Tom",
                lastname: "Baker",
                email: "tom.baker@acmeconsulting.io",
                positionTitle: "Software Engineer",
                isTeamMember: true,
                defaultBillableRate: 110.0,
                defaultCostRate: 50.0
            }
        ];
        UserList result = {users};
        return result;
    }

    # Retrieves all active webhook subscriptions for the authenticated account.
    #
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns all active webhook subscriptions.)
    resource function get Webhook() returns http:Unauthorized|WebhookList|xml {
        WebhookList result = {
            webhooks: [
                {
                    subscriptionID: 11,
                    notificationURL: "https://hooks.acmeconsulting.io/avaza/tasks",
                    userIDFK: 801,
                    eventCode: "task_created"
                },
                {
                    subscriptionID: 12,
                    notificationURL: "https://hooks.acmeconsulting.io/avaza/invoices",
                    userIDFK: 801,
                    eventCode: "invoice_created"
                }
            ]
        };
        return result;
    }

    # Creates a new customer company record in Avaza.
    #
    # + payload - The request body containing the new company details. CompanyName is required 
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns the created company with assigned Company ID.)
    resource function post Company(@http:Payload map<json> payload) returns http:Unauthorized|CompanyXmlOk {
        Company company = {
            companyID: 1003,
            companyName: str(payload, "CompanyName") ?: "New Company",
            currencyCode: str(payload, "CurrencyCode") ?: "USD",
            billingAddressCity: str(payload, "BillingAddressCity"),
            billingCountryCode: str(payload, "BillingCountryCode"),
            phone: str(payload, "Phone"),
            dateCreated: "2026-03-14T09:30:00Z",
            dateUpdated: "2026-03-14T09:30:00Z"
        };
        return <CompanyXmlOk>{body: company};
    }

    # Creates a new expense entry. Requires at minimum an expense date, amount, and expense category (by ID or name).
    #
    # + payload - The new expense details 
    # + return - returns can be any of following types 
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns the created expense with assigned Expense ID.)
    resource function post Expense(@http:Payload map<json> payload) returns http:BadRequest|http:Unauthorized|ExpenseDetailsXmlOk {
        ExpenseDetails expense = {
            expenseID: 7003,
            merchant: str(payload, "Merchant") ?: "Unknown",
            notes: str(payload, "Notes"),
            currencyCode: str(payload, "CurrencyCode") ?: "USD",
            projectIDFK: int32(payload, "ProjectIDFK"),
            expenseCategoryIDFK: int32(payload, "ExpenseCategoryIDFK"),
            expenseApprovalStatusCode: "Draft",
            isReimbursable: false,
            dateCreated: "2026-03-14T09:30:00Z"
        };
        return <ExpenseDetailsXmlOk>{body: expense};
    }

    # Creates a new draft invoice. Optionally creates a new customer company and contact if no matching company is found.
    #
    # + payload - The request body containing the new invoice details, line items, and optional company/contact information 
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns the created invoice with assigned Transaction ID and line items.)
    resource function post Invoice(@http:Payload map<json> payload) returns http:Unauthorized|InvoiceXmlOk {
        Invoice invoice = {
            transactionID: 9003,
            invoiceNumber: str(payload, "InvoiceNumber") ?: "INV-0003",
            subject: str(payload, "Subject"),
            companyIDFK: int32(payload, "CompanyIDFK"),
            companyName: str(payload, "CompanyName"),
            currencyCode: str(payload, "CurrencyCode") ?: "USD",
            transactionStatusCode: "Draft",
            dateIssued: str(payload, "DateIssued"),
            dueDate: str(payload, "DueDate"),
            totalAmount: 0.00,
            balance: 0.00
        };
        return <InvoiceXmlOk>{body: invoice};
    }

    # Creates a new project in Avaza, linked to a customer company. Optionally creates a new company if CompanyName is provided and not matched.
    #
    # + payload - The request body containing the data for the new project 
    # + return - returns can be any of following types 
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns the created project with assigned Project ID.)
    resource function post Project(@http:Payload map<json> payload) returns http:Unauthorized|ProjectDetailsXmlOk {
        ProjectDetails project = {
            projectID: 2003,
            title: str(payload, "ProjectTitle") ?: "New Project",
            projectCode: str(payload, "ProjectCode"),
            companyIDFK: int32(payload, "CompanyIDFK"),
            companyName: str(payload, "CompanyName"),
            projectStatusCode: str(payload, "ProjectStatusCode") ?: "NotStarted",
            projectBillableTypeCode: str(payload, "ProjectBillableTypeCode"),
            projectBudgetTypeCode: str(payload, "ProjectBudgetTypeCode"),
            currencyCode: str(payload, "CurrencyCode") ?: "USD",
            startDate: str(payload, "StartDate"),
            endDate: str(payload, "EndDate"),
            notes: str(payload, "ProjectNotes"),
            isArchived: false
        };
        return <ProjectDetailsXmlOk>{body: project};
    }

    # Creates a new task in a project section. Requires ProjectIDFK, SectionIDFK, and Title. Optionally assign users, set dates, priority, estimated effort, and tags.
    #
    # + payload - The request body containing the data for the new task 
    # + return - Returns the created task with assigned Task ID 
    resource function post Task(@http:Payload map<json> payload) returns TaskDetailsXmlOk {
        TaskDetails task = {
            taskID: 3003,
            title: str(payload, "Title") ?: "New Task",
            description: str(payload, "Description"),
            projectIDFK: int32(payload, "ProjectIDFK"),
            sectionIDFK: int32(payload, "SectionIDFK"),
            taskStatusCode: "NotStarted",
            taskPriorityCode: str(payload, "TaskPriorityCode") ?: "Normal",
            dateStart: str(payload, "DateStart"),
            dateDue: str(payload, "DateDue")
        };
        return <TaskDetailsXmlOk>{body: task};
    }

    # Creates a new timesheet entry. If Duration is null or 0, a timer will be started automatically. Requires ProjectIDFK and TimesheetCategoryIDFK.
    #
    # + payload - The request body containing the data for the new timesheet entry 
    # + return - returns can be any of following types 
    # http:BadRequest (Bad Request)
    # http:Unauthorized (Unauthorized)
    # http:Ok (Returns the created timesheet entry. If Duration was 0 or null, a timer is started.)
    resource function post Timesheet(@http:Payload map<json> payload) returns http:BadRequest|http:Unauthorized|TimesheetDetailsXmlOk {
        TimesheetDetails timesheet = {
            timesheetEntryID: 6003,
            projectIDFK: int32(payload, "ProjectIDFK"),
            taskIDFK: int32(payload, "TaskIDFK"),
            timesheetCategoryIDFK: int32(payload, "TimesheetCategoryIDFK"),
            duration: 1.5,
            notes: str(payload, "Notes"),
            isInvoiced: false,
            hasTimer: false,
            dateCreated: "2026-03-14T09:30:00Z"
        };
        return <TimesheetDetailsXmlOk>{body: timesheet};
    }

    # Updates an existing project. Only fields listed in the FieldsToUpdate array will be modified. When ProjectBillableTypeCode is updated, use ScheduleRateUpdateOption and TimesheetRateUpdateOption to control whether rate changes cascade to existing schedule bookings and timesheet entries respectively.
    #
    # + payload - The request body containing the fields to update and their new values 
    # + return - Returns the updated project details 
    resource function put Project(@http:Payload map<json> payload) returns ProjectDetails|xml {
        ProjectDetails project = {
            projectID: 2001,
            title: "Website Redesign",
            projectCode: "WEB-01",
            companyIDFK: 1001,
            companyName: "Globex Corporation",
            projectStatusCode: "InProgress",
            currencyCode: "USD",
            isArchived: false
        };
        project.projectID = int32(payload, "ProjectID") ?: 2001;
        project.title = str(payload, "ProjectTitle") ?: "Website Redesign";
        project.projectStatusCode = str(payload, "ProjectStatusCode") ?: "InProgress";
        project.notes = str(payload, "ProjectNotes");
        return project;
    }

    # Update a Task.
    #
    # + payload - The request body containing the task ID, fields to update, and updated values 
    # + return - Returns the updated task details 
    resource function put Task(@http:Payload map<json> payload) returns TaskDetails|xml {
        TaskDetails task = {
            taskID: 3001,
            title: "Design homepage mockups",
            projectIDFK: 2001,
            sectionIDFK: 4001,
            taskStatusCode: "InProgress",
            taskPriorityCode: "High"
        };
        task.taskID = int32(payload, "TaskID") ?: 3001;
        task.title = str(payload, "Title") ?: "Design homepage mockups";
        task.taskStatusCode = str(payload, "TaskStatusCode") ?: "InProgress";
        task.taskPriorityCode = str(payload, "TaskPriorityCode") ?: "High";
        task.description = str(payload, "Description");
        return task;
    }
}

// The service binds request payloads as raw JSON maps because the wire field names are PascalCase.
function str(map<json> payload, string key) returns string? {
    json value = payload[key];
    return value is string ? value : ();
}

function int32(map<json> payload, string key) returns int:Signed32? {
    json value = payload[key];
    if value is int {
        int:Signed32|error converted = value.ensureType();
        return converted is int:Signed32 ? converted : ();
    }
    return ();
}

public type CompanyXmlOk record {|
    *http:Ok;
    Company|xml body;
|};

public type ExpenseDetailsXmlOk record {|
    *http:Ok;
    ExpenseDetails|xml body;
|};

public type InvoiceXmlOk record {|
    *http:Ok;
    Invoice|xml body;
|};

public type ProjectDetailsXmlOk record {|
    *http:Ok;
    ProjectDetails|xml body;
|};

public type TaskDetailsXmlOk record {|
    *http:Ok;
    TaskDetails|xml body;
|};

public type TimesheetDetailsXmlOk record {|
    *http:Ok;
    TimesheetDetails|xml body;
|};
