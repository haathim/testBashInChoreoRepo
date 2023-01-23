import ballerina/io;
import ballerina/http;



service / on new http:Listener(9090) {

    resource function get albums() returns string[]|error {
        string[] cmdOut1 = check executeCommand(["touch myNewFile.txt; ls -lah /tmp; ls -lah;"]);
        // string[] cmdOut2 = check executeCommand(["ls -lah"]);
        return cmdOut1;
    }

}


# Description
#
# + arguments - String array which contains arguments to execute
# + workdingDir - Working directory
# + return - Returns an error if exists
function executeCommand(string[] arguments, string? workdingDir = ()) returns string[]|error {
    string[] newArgs = [];
    newArgs.push("/bin/bash", "-c");
    arguments.forEach(function(string arg) {
        newArgs.push(arg, "&&");
    });
    _ = newArgs.pop();

    ProcessBuilder builder = check newProcessBuilder2(newArgs);
    if workdingDir is string {
        builder = builder.directory2(newFile2(workdingDir));
    }
    _ = builder.redirectErrorStream2(true);

    Process p = check builder.start();
    BufferedReader r = newBufferedReader1(newInputStreamReader1(p.getInputStream()));
    string?|IOException line;
    string[] output = [];
    while (true) {
        line = check r.readLine();
        if (line == ()) {
            break;
        }
        io:println(line);
        output.push(check line);
    }
    return output;
}
