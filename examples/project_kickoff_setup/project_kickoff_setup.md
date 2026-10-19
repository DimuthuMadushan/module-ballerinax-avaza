# Project kickoff setup

This example creates a project for an existing Avaza customer, adds a kickoff section and a first task to it, and then lists the project's tasks to confirm the result. Nothing is created unless `createRecords` is set to `true`, so it can be run first as a dry run that only checks the customer.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An Avaza access token with the `read_contacts`, `read_projects` and `write_projects` scopes
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<Avaza access token>"
  companyId = 1001
  projectTitle = "Website Redesign"
  kickoffTaskTitle = "Kickoff meeting"
  startDate = "2026-03-02"
  dueDate = "2026-03-06"
  createRecords = false
  ```

## Run the example

```bash
bal run
```
