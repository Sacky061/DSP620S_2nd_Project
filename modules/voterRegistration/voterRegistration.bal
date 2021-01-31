import ballerina/io;
import ballerinax/kafka; 
//Removed by Prof Jose: import ballerina/lang.'string;
//import ballerina/lang.'value;
import ballerina/log;

kafka:ConsumerConfiguration consConf = {
    bootstrapServers: "localhost:9092",
    groupId: "group-id",

    topics: ["Registered Voters"],
    pollingIntervalInMillis: 1000,
    //keyDeserializerType: kafka:DES_INT,
    //valueDeserializerType: kafka:DES_STRING,
    autoCommit: false
};

listener kafka:Listener cons = new (consConf);

service kafkaService on cons {
	remote function onConsumerRecord(kafka:Consumer kafkaConsumer, kafka:ConsumerRecord[] records) {
		//side note: On ballerina.io its kafka:Caller insted of consumer
		foreach var rec in records
		{
			processKafkaRecord(rec);
		}

		var commitResult = kafkaConsumer->commit();
		if (commitResult is error) {
            log:printError("Error occurred while committing the " +
                "offsets for the consumer ", err = commitResult);
        }
	}
}

function processKafkaRecord(kafka:ConsumerRecord rec) {
	anydata msgVal = rec.value;

	//string|error messageContent = string:fromBytes(msgVal);
	if(msgVal is string)
	{
		io:println("topc: " + msgVal + " received message " + msgVal);
	} else {
		log:printError("Invalid value type received");
	}
}


//?????????????????????????????????????????????????????????????????
//here we are supposed to send the retrived information ready to be displayed to the API-gateway (graphQL)
//??????????????????????????????????????????????????????????

 