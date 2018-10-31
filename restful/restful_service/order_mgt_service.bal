import ballerina/http;

endpoint http:Listener listener {
    port: 9090
};

map<json> ordersMap;

@http:ServiceConfig {
    basePath: "/ordermgt"
}
service<http:Service> orderMgt bind listener {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/order/{orderId}"
    }
    findOrder (endpoint client, http:Request req, string orderId) {
        json payload = ordersMap[orderId];
        http:Response response;
        if (payload == null) {
            payload = "Order : " + orderId + " cannot be found";
        }

        response.setJsonPayload(untaint payload);

        _ = client->respond(response);
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/order"
    }
    addOrder (endpoint client, http:Request req) {
        json orderReq = check req.getJsonPayload();
        string orderId =
                         orderReq.Order.ID.toString();
        ordersMap[orderId] = orderReq;

        json payload = {
            status: "Order Created.",
            orderId: orderId
        };

        http:Response response;
        response.setJsonPayload(untaint payload);

        response.statusCode = 201;

        response.setHeader("Location", "http://localhost:9090/ordermgt/order/" + orderId);

        _ = client->respond(response);
    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/order/{orderId}"
    }
    updateOrder (endpoint client, http:Request req, string orderId) {
        json updatedOrder = check req.getJsonPayload();
        json existingOrder = ordersMap[orderId];

        if (existingOrder != null) {
            existingOrder.Order.Name = updatedOrder.Order.Name;
            existingOrder.Order.Description = updatedOrder.Order.Description;
            ordersMap[orderId] = existingOrder;
        } else {
            existingOrder = "Order : " + orderId + " cannot be found";
        }

        http:Response response;
        response.setJsonPayload(untaint existingOrder);

        _ = client->respond(response);
    }

    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/order/{orderId}"
    }
    cancelOrder (endpoint client, http:Request req, string orderId) {
        http:Response response;

        _ = ordersMap.remove(orderId);

        json payload = "Order : " + orderId + " removed.";
        response.setJsonPayload(untaint payload);

        _ = client->respond(response);
    }
}
