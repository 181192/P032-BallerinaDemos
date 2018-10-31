# Ballerina!

## Restful

```shell
$ http POST :9090/ordermgt/order Order:='{ "ID":100501, "Name":"BLA", "Description":"Sample order"}'
HTTP/1.1 201 Created
Location: http://localhost:9090/ordermgt/order/100501
content-encoding: gzip
content-length: 70
content-type: application/json
date: Thu, 1 Nov 2018 00:05:18 +0100
server: ballerina/0.982.0

{
    "orderId": "100501",
    "status": "Order Created."
}
```

```shell
$ http :9090/ordermgt/order/100501
HTTP/1.1 200 OK
content-encoding: gzip
content-length: 88
content-type: application/json
date: Thu, 1 Nov 2018 00:05:42 +0100
server: ballerina/0.982.0

{
    "Order": {
        "Description": "Sample order",
        "ID": 100501,
        "Name": "BLA"
    }
}
```
