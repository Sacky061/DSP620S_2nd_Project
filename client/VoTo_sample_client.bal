import ballerina/log;
import ballerina/grpc;
import ballerina/io;

    VoToBlockingClient blockingEp = new("http://localhost:9090");

    function ballotDescription () {
        log:printInfo("**********************************************************************");
        log:printInfo("------------------------Creating a ballot description--------------------------");
        log:printInfo("**********************************************************************");
        ballotInfo value = {candidate:"", position:"", party: "", voteStatus: ""};

        value.candidate = io:readln("Enter the candidate's name: ");
        value.position = io:readln("Enter the candidate's position: ");
        value.party = io:readln("Enter the candidate's political party: ");

        var ballotResponse = VoToBlockingEp->ballotDescription(value);
        if (ballotResponse is error) 
        {
            log:printError("Error from Connector: " + ballotResponse.reason() + " - "
                                                    + <string>ballotResponse.detail().message + "\n");
        } 
        else 
        {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = ballotResponse;
            log:printInfo("Response - " + result + "\n");
        }
    
    }

    function voterProfile () {
        log:printInfo("**********************************************************************");
        log:printInfo("------------------------Creating a Voter--------------------------");
        log:printInfo("**********************************************************************");
        voterInfo value = {id:"", firstName:"", lastName:"", dob:"", country:"", region: "", constituency: ""};

        value.id = io:readln("Enter the Voter's ID: ");
        value.firstName = io:readln("Enter the Voter's first name: ");
        value.lastName = io:readln("Enter the Voter's last name: ");
        value.dob = io:readln("Enter the Voter's date of birth: ");
        value.country = io:readln("Enter the Voter's country: ");
        value.region = io:readln("Enter the Voter's region: ");
        value.constituency = io:readln("Enter the Voter's constituency: ");

        var voterResponse = VoToBlockingEp->voterProfile(value);
        if (voterResponse is error) 
        {
            log:printError("Error from Connector: " + voterResponse.reason() + " - "
                                                    + <string>voterResponse.detail().message + "\n");
        } 
        else 
        {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = voterResponse;
            log:printInfo("Response - " + result + "\n");
        }
    }

    function votingPeriod () {
        log:printInfo("**********************************************************************");
        log:printInfo("------------------------Creating a Voting Information--------------------------");
        log:printInfo("**********************************************************************");
        votingInfo value = {votingDate:"", votingTime: ""};

        value.votingDate = io:readln("Enter the Voting starting date and voting endind date: ");
        value.votingTime = io:readln("Enter the Voting starting time and voting ending time: ");

        var votingResponse = VoToBlockingEp->votingPeriod(bookReq);
        if (votingResponse is error) 
        {
            log:printError("Error from Connector: " + votingResponse.reason() + " - "
                                                    + <string>votingResponse.detail().message + "\n");
        } 
        else 
        {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = votingResponse;
            log:printInfo("Response - " + result + "\n");
        }

    }
    function votingOutcomeDeadline() {
        log:printInfo("**********************************************************************");
        log:printInfo("------------------------Creating outcome deadline--------------------------");
        log:printInfo("**********************************************************************");
        outcomeInfo value = {outcomeDeadlineDate:"", outcomeDeadlineTime: ""};

        value.outcomeDeadlineDate = io:readln("Enter the deadline date for outcome: ");
        value.outcomeDeadlineTime = io:readln("Enter the deadline time for outcome: ");

        var outcomeResponse = VoToBlockingEp->votingOutcomeDeadline(value);
        if (outcomeResponse is error) 
        {
            log:printError("Error from Connector: " + outcomeResponse.reason() + " - "
                                                    + <string>outcomeResponse.detail().message + "\n");
        } 
        else 
        {
            string result;
            grpc:Headers resHeaders;
            (result, resHeaders) = outcomeResponse;
            log:printInfo("Response - " + result + "\n");
        }

        
    }


