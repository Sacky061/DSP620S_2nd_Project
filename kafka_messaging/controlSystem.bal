import ballerina/io;
import wso2/kafka;
import ballerina/encoding;

kafka:ConsumerConfig consumerConfig = 
{
    bootstrapServers: "localhost:9092, localhost:9093",
    groupId: "controlSystem",
    topics: ["registration"],
    pollingInterval: 1000,
    autoCommit:false
};

listener kafka:SimpleConsumer consumer = new(consumerConfig);

service kafkaService on consumer 
{
    resource function onMessage(kafka:SimpleConsumer simpleConsumer, kafka:ConsumerRecord[] records) 
    {
        foreach var entry in records 
        {
            byte[] serializedMsg = entry.value;
            string msg = encoding:byteArrayToString(serializedMsg);
            io:println("New message received from the admin");
            io:println("Topic: " + entry.topic + "; Received Message: " + msg);
            io:println("Database has been updated with the new Voter");
        }
    }
}
