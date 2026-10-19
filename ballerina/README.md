## Overview

[Avaza](https://www.avaza.com/) is a cloud-based platform that brings project management, timesheets, expenses, invoicing and team scheduling together in one workspace. This connector provides access to the Avaza REST API (version `v1`) from Ballerina, covering customers and contacts, projects, tasks, timesheets, expenses, invoices, payments, schedules, users and webhook subscriptions. It authenticates with an OAuth 2.0 access token or an Avaza personal access token.

### Key features

- Manage customer companies and their contacts
- Create and track projects, sections, tasks and project members
- Log, review and approve timesheet entries and running timers
- Capture expenses, estimates, invoices and payments
- Schedule bookings and leave for team members
- Subscribe to Avaza events through webhooks

## Setup guide

To use the connector you need an Avaza account and an access token.

1. Sign in to your Avaza account. Creating API credentials requires Administrator permissions.

2. Open the API settings of your account and either create a personal access token, or register an OAuth 2.0 application to obtain a client ID and client secret.

3. For an OAuth 2.0 application, authorize it against `https://any.avaza.com/oauth2/authorize` with the scopes your integration needs (for example `read_projects` and `write_projects`), then exchange the authorization code at `https://any.avaza.com/oauth2/token` for an access token and a refresh token.

4. Keep the token (or the client ID, client secret and refresh token) safe. You supply it to the connector through `Config.toml`.

## Quickstart

To use the `avaza` connector in your Ballerina application, update the `.bal` file as follows:

Step 1: Import the connector.

```ballerina
import ballerinax/avaza;
```

Step 2: Create a `Config.toml` file with your access token.

```toml
accessToken = "<Your Avaza access token>"
```

Step 3: Create a client using the token.

```ballerina
configurable string accessToken = ?;

final avaza:Client avazaClient = check new ({auth: {token: accessToken}});
```

Step 4: List the projects in your account.

```ballerina
public function main() returns error? {
    avaza:ProjectList _ = check avazaClient->listProjects(pageSize = 10);
}
```

## Examples

The `Avaza` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-avaza/tree/main/examples/), covering the following use cases:

1. [Project kickoff setup](../examples/project_kickoff_setup/project_kickoff_setup.md) - Create a project for an existing customer, add a kickoff section and task, and confirm the result.
2. [Weekly timesheet summary](../examples/weekly_timesheet_summary/weekly_timesheet_summary.md) - Page through the timesheet entries of a date range and total the hours logged per project.
