# Examples

The `ballerinax/avaza` connector provides practical examples illustrating usage in various scenarios.

1. [Project kickoff setup](https://github.com/ballerina-platform/module-ballerinax-avaza/tree/main/examples/project_kickoff_setup) - Create a project for an existing customer, add a kickoff section and task, and confirm the result.
2. [Weekly timesheet summary](https://github.com/ballerina-platform/module-ballerinax-avaza/tree/main/examples/weekly_timesheet_summary) - Total the hours logged per project over a date range.

## Prerequisites

Generate an Avaza access token (a personal access token or an OAuth 2.0 access token) and provide it as `accessToken` in a `Config.toml` file inside the example directory.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
