# Ballerina Avaza connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-avaza/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-avaza/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-avaza.svg)](https://github.com/ballerina-platform/module-ballerinax-avaza/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/avaza.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Favaza)

## Overview

[Avaza](https://www.avaza.com/) is a cloud-based platform that brings project management, timesheets, expenses, invoicing and team scheduling together in one workspace. This connector provides access to the Avaza REST API (version `v1`) from Ballerina, covering customers and contacts, projects, tasks, timesheets, expenses, invoices, payments, schedules, users and webhook subscriptions. It authenticates with an OAuth 2.0 access token or an Avaza personal access token.

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

1. [Project kickoff setup](examples/project_kickoff_setup/project_kickoff_setup.md) - Create a project for an existing customer, add a kickoff section and task, and confirm the result.
2. [Weekly timesheet summary](examples/weekly_timesheet_summary/weekly_timesheet_summary.md) - Page through the timesheet entries of a date range and total the hours logged per project.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`avaza` package](https://central.ballerina.io/ballerinax/avaza/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
