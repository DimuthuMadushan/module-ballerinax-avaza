import ballerina/io;
import ballerinax/avaza;

configurable string accessToken = ?;
configurable string entryDateFrom = ?;
configurable string entryDateTo = ?;

const int:Signed32 PAGE_SIZE = 100;

public function main() returns error? {
    avaza:Client avazaClient = check new ({auth: {token: accessToken}});

    map<decimal> hoursByProject = {};
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
            string project = entry.projectTitle ?: "Unassigned";
            hoursByProject[project] = (hoursByProject[project] ?: 0d) + (entry.duration ?: 0d);
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
    foreach [string, decimal] [project, hours] in hoursByProject.entries() {
        io:println(project, ": ", hours);
    }
}
