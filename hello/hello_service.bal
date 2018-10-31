import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerinax/docker;

endpoint http:Listener listener {
    port: 9090
};

@docker:Config {
    name: "helloworld",
    tag: "v1.0"
}

@http:ServiceConfig {
    basePath: "/"
}

service<http:Service> hello bind listener {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/hi"
    }

    hello (endpoint caller, http:Request request) {

        // Create object to carry data back to caller
        http:Response response = new;

        // Objects and structs can have function calls
        response.setTextPayload("Hello Ballerina!\n");

        caller->respond(response) but {
            error e => log:printError("Error sending response", err = e)
        };
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/bye"
    }
    bye (endpoint caller, http:Request request) {
        http:Response response = new;
        response.setTextPayload("Byee!\n");

        caller-> respond(response) but {
            error e => log:printError("Error sending response", err = e)
        };
    }

    
}
