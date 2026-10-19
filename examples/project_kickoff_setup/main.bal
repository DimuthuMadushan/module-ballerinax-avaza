import ballerina/io;
import ballerinax/avaza;

configurable string accessToken = ?;
configurable int companyId = ?;
configurable string projectTitle = ?;
configurable string kickoffTaskTitle = ?;
configurable string startDate = ?;
configurable string dueDate = ?;
configurable boolean createRecords = false;

public function main() returns error? {
    avaza:Client avazaClient = check new ({auth: {token: accessToken}});

    int:Signed32 companyKey = check companyId.ensureType();
    avaza:Company company = check avazaClient->getCompany(companyKey);
    string companyName = company.companyName ?: "";
    if companyName == "" {
        return error("Company " + companyId.toString() + " was not found or has no name");
    }
    io:println("Setting up a project for ", companyName);

    if !createRecords {
        io:println("Dry run: set createRecords = true in Config.toml to create the project, section and task");
        return;
    }

    avaza:ProjectDetails project = check avazaClient->createProject({
        projectTitle,
        companyIDFK: companyKey,
        startDate,
        endDate: dueDate
    });
    int:Signed32 projectId = check project.projectID.ensureType();
    io:println("Created project ", projectId);

    avaza:SectionDetails section = check avazaClient->createSection({projectIDFK: projectId, title: "Kickoff"});
    int:Signed32 sectionId = check section.sectionID.ensureType();
    io:println("Created section ", sectionId);

    avaza:TaskDetails task = check avazaClient->createTask({
        projectIDFK: projectId,
        sectionIDFK: sectionId,
        title: kickoffTaskTitle,
        dateStart: startDate,
        dateDue: dueDate
    });
    io:println("Created task ", task.taskID);

    avaza:TaskList tasks = check avazaClient->listTasks(projectID = projectId);
    io:println("Project ", projectId, " now has ", tasks.totalCount ?: 0, " task(s)");
}
