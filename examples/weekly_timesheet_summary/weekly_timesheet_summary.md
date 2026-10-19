# Weekly timesheet summary

This example pages through every timesheet entry between two dates and prints the total hours logged for each project. It only reads data, so it is safe to run against a live account.

## Prerequisites

- Ballerina Swan Lake 2201.x or later
- An Avaza access token with the `read_timesheets` scope
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<Avaza access token>"
  entryDateFrom = "2026-03-02"
  entryDateTo = "2026-03-08"
  ```

## Run the example

```bash
bal run
```
