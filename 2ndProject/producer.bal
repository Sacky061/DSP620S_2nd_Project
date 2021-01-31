import ballerina/io;
import ballerinax/kafka;
//import ballerina/log;

kafka:ProducerConfiguration prodConf = {
	bootstrapServers: "localhost:9092",
	clientId: "basic-producer",
	acks: "all",
	retryCount: 3
	//valueSerializerType: kafka:SER_STRING,
	//keySerializerType: kafka:SER_INT
};

kafka:Producer prod =  new (prodConf);

public function main() returns error? {
    
	//Sacky Insert code for reading all the candidates from database and create a json object called ballot
    // lists all the candidates and positions
        json ballot = {
            //example
            President: {
                
                Candidate1: "Sacky Simon",
                Candidate2: "Kudumo Andreas"             
                
                },

            Secretary: {
                Candidate1: "Leo Boois",
                Candidate2: "Shifidi Daniel"
            }

    };

    //Sacky Insert Code here for reading election results from database and create a json object called results
	//Example:
    json results {
        Presidency: {
            Sacky: 56,
            Kudumo: 27
        },

        Secretary: {
            Leo: 60,
            Shifidi: 20
        }
    };

    //Sacky Insert Code here for reading all voter usenames and passwords from database and create a json object called results
	//Example:
    json voters {

        Sacky: {
            Name: "Sacky",
            Password: "Sacky2017"
        }

        Kudumo: {
            Name: "Kudumo",
            Password: "Andreas"
        }

    }
		
	var sendBallot = prod -> send(ballotPaper.toString(), "ballot paper", partition = 2);
    var sendResults = prod -> send(results.tostrring(), "Election Results", partition = 2);
    var sendVoters = prod -> send(results.toString(), "Registered Voters", partition = 2);

}