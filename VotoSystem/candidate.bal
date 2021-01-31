import ballerina/io;
import wso2/kafka;
import ballerina/encoding;

// Kafka consumer listener configurations
kafka:ConsumerConfig consumerConfig = 
{
    bootstrapServers: "localhost:9092, localhost:9093",
    // Consumer group ID
    groupId: "candidates",
    // Listen from topic 'types-of-candidates'
    topics: ["types-of-candidates"],
    // Poll every 1 second
    pollingInterval: 1000
};

// Create kafka listener
listener kafka:SimpleConsumer consumer = new(consumerConfig);


service candidateService on consumer 
{
    // Triggered whenever a message added to the subscribed topic
    resource function onMessage(kafka:SimpleConsumer simpleConsumer, kafka:ConsumerRecord[] records) 
    {
        // Dispatched set of Kafka records to service, We process each one by one.
        foreach var entry in records 
        {
            byte[] serializedMsg = entry.value;
            // Convert the serialized message to string message
            string msg = encoding:byteArrayToString(serializedMsg);
            io:println("[INFO] New message received from the admin");
            // log the retrieved Kafka record
            io:println("[INFO] Topic: " + entry.topic + "; Received Message: " + msg);
            // Acknowledgement
            io:println("[INFO] Acknowledgement from candidate");
        }
    }
}