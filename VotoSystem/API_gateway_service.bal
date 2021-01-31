import ballerina/auth;
import ballerina/http;
import ballerina/log;
import ballerinax/docker;

http:AuthProvider basicAuthProvider = {
    tittle: "voting",
    scheme: "BASIC_AUTH",
    authStoreProvider: "CONFIG_AUTH_STORE"
};
http:ServiceSecureSocket secureSocket = {
    keyStore: {
        path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
        password: "ballerina"
    }
};
@docker:Config {
    registry: "ballerina_2nd_project",
    name: "api_gateway",
    tag: "v1.0"
}
@docker:CopyFiles {
    files: [{
        source: "ballerina.conf",
        target: "ballerina.conf"
    }]
}
//  'http:Listener', which tries to authenticate and authorize each request.
listener http:Listener apiListener = new(9090, config = { authProviders: [basicAuthProvider],
        secureSocket: secureSocket });

// Add the authConfig in the ServiceConfig annotation to protect the service using Auth
@http:ServiceConfig {
    basePath: "C:/Users/Sacky/Desktop/VoTo/src/API_gateway",
    authConfig: {
        authProviders: ["voter"],
        authentication: {
            enabled: true
        }
    }
}
service topic on apiListener {

    # Resource that handles the HTTP POST requests that are directed
    # to the path '/note' to create a new vote.
    // Add authConfig param to the ResourceConfig to limit the access for scopes
    @http:ResourceConfig {
        methods: ["POST"],
        path: "C:/Users/Sacky/Desktop/VoTo/src/API_gateway",
        // Authorize only users with "registered voter id" scope
        authConfig: {
            scopes: ["voter"]
        }
    }
    resource function castBallot(http:Caller caller, http:Request req) {
        // Retrieve the notification details from the request
        var ballotReq = req.getJsonPayload();

        if (ballotReq is json) {
            // Extract voter ID from the request from the voter
            string ordertittle = ballotReq.vote.id.toString();

            // Create response message.
            json payload = {
                status: "ballot Created.",
                voteid: untaint voteid
            };

            // Send response to the client.
            var result = caller->respond(payload);
            if (result is error) {
                log:printError("Error while responding", err = result);
            }
            log:printInfo("vote created: " + voteid);
        } else {
            log:printError("Invalid vote request");
            var result = caller->respond({
                "^error": "Invalid vote request"
            });
            if (result is error) {
                log:printError("Error while responding");
            }
        }
    }
}