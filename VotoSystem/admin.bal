import ballerina/http;
import wso2/kafka;

final string ADMIN_USERNAME = "Admin";
final string ADMIN_PASSWORD = "Admin";

kafka:ProducerConfig producerConfigs = 
{
    bootstrapServers: "localhost:9092",
    clientID: "basic-voter",
    acks: "all",
    noRetries: 3
};

kafka:SimpleProducer kafkaProducer = new(producerConfigs);

listener http:Listener httpListener = new(9090);

@http:ServiceConfig { basePath: "/product" }
service adminService on httpListener 
{

    @http:ResourceConfig { methods: ["POST"], consumes: ["application/json"], produces: ["application/json"] }
    resource function updateRegistration(http:Caller caller, http:Request request) 
    {
        http:Response response = new;
        int newVoter = 0;
        json|error reqPayload = request.getJsonPayload();

        if (reqPayload is error) 
        {
            response.statusCode = 400;
            response.setJsonPayload({ "Message": "Invalid payload - Not a valid JSON payload" });
            var result = caller->respond(response);
        } 
        else 
        {
            json username = reqPayload.Username;
            json password = reqPayload.Password;
            json voterName = reqPayload.Name;
            json voterId = reqPayload.Id;

            if (username == null || password == null || voterName == null || voterId == null) 
            {
                response.statusCode = 400;
                response.setJsonPayload({ "Message": "Bad Request: Invalid payload" });
                var responseResult = caller->respond(response);
            }

            var result = int.convert(voterId.toString());
            if (result is error) 
            {
                response.statusCode = 400;
                response.setJsonPayload({ "Message": "Invalid amount specified" });
                var responseResult = caller->respond(response);
            } 
            else 
            {
                int voterRegistrastionId = result;
            }

            if (username.toString() != ADMIN_USERNAME || password.toString() != ADMIN_PASSWORD) 
            {
                response.statusCode = 403;
                response.setJsonPayload({ "Message": "Access Forbidden" });
                var responseResult = caller->respond(response);
            }

            json registrationInfo = { "Name": voterName, "UpdatedRegistration": voterId };
            byte[] serializedMsg = registrationInfo.toString().toByteArray("UTF-8");

            var sendResult = kafkaProducer->send(serializedMsg, "Registration", partition = 0);
            if (sendResult is error) 
            {
                response.statusCode = 500;
                response.setJsonPayload({ "Message": "Kafka producer failed to send data" });
                var responseResult = caller->respond(response);
            }
            response.setJsonPayload({ "Status": "Success" });
            var responseResult = caller->respond(response);
        }
    }
}