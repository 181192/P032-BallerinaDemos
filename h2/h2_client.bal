import ballerina/h2;
import ballerina/io;

endpoint h2:Client testDB {
    path: "./h2-client",
    name: "testdb",
    username: "SA",
    password: "",
    poolOptions: {
        maximumPoolSize: 5
    }
};

public function main(string... args) {
    io:println("The update operation - Creating a table");
    var ret = testDB->update("CREATE TABLE STUDENT(ID INTEGER, AGE INTEGER, NAME VARCHAR(255), PRIMARY KEY(ID))");
    handleUpdate(ret, "Create student table");

    io:println("\nThe update operation - inserting data to a table");
    ret = testDB->update("INSERT INTO student(id, age, name) values (1, 23, 'john')");
    handleUpdate(ret, "Insert to student table with no parameters");

    io:println("\nThe select operation - Select data from a table");
    var selectRet = testDB->select("SELECT * FROM student", ());
    table dt;
    match selectRet {
        table tableReturned => dt = tableReturned;
        error e => io:println("Select data from student table failed: " + e.message);
    }

    io:println("\nConvert the table into json");
    var jsonconversionRet = <json>dt;
    match jsonconversionRet {
        json jsonRes => {
            io:print("JSON: ");
            io:println(io:sprintf("%s", jsonRes));
        }
        error e => io:println("Error in table to json conversion");
    }

    io:println("\nThe update operation - Drop student table");
    ret = testDB->update("DROP TABLE student");
    handleUpdate(ret, "Drop table student");

    testDB.stop();
}

function handleUpdate(int|error returned, string message) {
    match returned {
        int retInt => io:println(message + " status: " + retInt);
        error e => io:println(message + " failed: " + e.message);
    }
}