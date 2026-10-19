import ballerina/io;
import ballerinax/avaza;

configurable string accessToken = ?;
configurable string entryDateFrom = ?;
configurable string entryDateTo = ?;

const int:Signed32 PAGE_SIZE = 100;
// Key for entries with no project. Project keys are numeric IDs, so it can't collide with one.
const UNASSIGNED = "unassigned";

type ProjectHours record {|
    string title;
    decimal hours;
|};

public function main() returns error? {
    avaza:Client avazaClient = check new ({auth: {token: accessToken}});

    // Totals are keyed by project ID, so two projects with the same title stay separate.
    map<ProjectHours> hoursByProject = {};
    int:Signed32 pageNumber = 1;
    while true {
        avaza:TimesheetList page = check avazaClient->listTimesheets(
            entryDateFrom = entryDateFrom,
            entryDateTo = entryDateTo,
            pageSize = PAGE_SIZE,
            pageNumber = pageNumber
        );
        avaza:TimesheetListDetails[] entries = page.timesheets ?: [];
        foreach avaza:TimesheetListDetails entry in entries {
            int:Signed32? projectId = entry.projectIDFK;
            string key = projectId is () ? UNASSIGNED : projectId.toString();
            ProjectHours totals = hoursByProject[key] ?: {
                title: projectId is () ? "Unassigned" : entry.projectTitle ?: string `Project ${projectId}`,
                hours: 0d
            };
            totals.hours += entry.duration ?: 0d;
            hoursByProject[key] = totals;
        }
        if entries.length() < PAGE_SIZE {
            break;
        }
        pageNumber = <int:Signed32>(pageNumber + 1);
    }

    if hoursByProject.length() == 0 {
        io:println("No timesheet entries between ", entryDateFrom, " and ", entryDateTo);
        return;
    }

    io:println("Hours logged between ", entryDateFrom, " and ", entryDateTo);
    foreach ProjectHours {title, hours} in hoursByProject {
        io:println(title, ": ", hours);
    }
}
