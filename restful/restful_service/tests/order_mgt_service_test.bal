import ballerina/http;
import ballerina/test;

endpoint http:Client clientEP {
    url: "http://localhost:9090/ordermgt"
};

@test:Config
// Function to test POST resource 'addOrder'.
function testResourceAddOrder() {
    http:Request req = new;

    json payload = {
        "Order": { "ID":"100500", "Name":"XYZ", "Description":"Sample order"}
    };
    req.setJsonPayload(payload);

    http:Response response = check clientEP->post("/order", req);

    test:assertEquals(response.statusCode, 201, msg = "addOrder resource did not respond with expected response code!");

    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), "{\"status\":\"Order Created.\", \"orderId\":\"100500\"}", msg = "Response mismatch!");
}

@test:Config {
    dependsOn: ["testResourceAddOrder"]
}
// Function to test PUT resource 'updateOrder'.
function testResourceUpdateOrder() {
    // Initialize empty http requests and responses.
    http:Request req = new;
    // Construct the request payload.
    json payload = {
        "Order": {"Name":"XYZ", "Description":"Updated order."}
    };
    req.setJsonPayload(payload);
    // Send 'PUT' request and obtain the response.
    http:Response response = check clientEP -> put("/order/100500", req);
    // Expected response code is 200.
    test:assertEquals(response.statusCode, 200,
        msg = "updateOrder resource did not respond with expected response code!");
    // Check whether the response is as expected.
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(),
        "{\"Order\":{\"ID\":\"100500\", \"Name\":\"XYZ\", \"Description\":\"Updated order.\"}}",
        msg = "Response mismatch!");
}

@test:Config {
    dependsOn: ["testResourceUpdateOrder"]
}
// Function to test GET resource 'findOrder'.
function testResourceFindOrder() {

}

@test:Config {
    dependsOn: ["testResourceFindOrder"]
}
// Function to test DELETE resource 'cancelOrder'.
function testResourceCancelOrder() {

}
