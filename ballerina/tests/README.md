# Tests

The suite covers 25 representative operations: reading the account, and listing and fetching companies, contacts, invoices, projects, tasks, timesheets, expenses, users and webhooks, plus creating companies, invoices, projects, tasks, timesheets and expenses, updating projects and tasks, and deleting tasks and timesheets. Each test that deletes an entry creates its own fixture first.

## Running Tests

```bash
bal test
```

By default the tests run against a mock server (`tests/mock_service.bal`) that intercepts HTTP calls, so no credentials are required.

To run the read-only tests against a real Avaza account, set `IS_LIVE_SERVER=true` and provide these environment variables:

| Variable | Purpose |
|---|---|
| `AVAZA_ACCESS_TOKEN` | Access token (personal access token or OAuth 2.0 token) |
| `AVAZA_COMPANY_ID` | ID of an existing customer company |
| `AVAZA_INVOICE_ID` | ID of an existing invoice |
| `AVAZA_PROJECT_ID` | ID of an existing project |
| `AVAZA_SECTION_ID` | ID of a section in that project |
| `AVAZA_TASK_ID` | ID of an existing task |
| `AVAZA_TIMESHEET_ID` | ID of an existing timesheet entry |
| `AVAZA_TIMESHEET_CATEGORY_ID` | ID of a timesheet category |

```bash
IS_LIVE_SERVER=true bal test --groups live_tests
```

Tests that create, update or delete records run against the mock server only.
