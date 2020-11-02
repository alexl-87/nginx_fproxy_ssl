var express = require('express');
var app = express();
var exec = require("child_process").exec;
app.get('/api/docker/run/:port', function (req, res) {
    var command = "docker run -t -d -p " + req.params.port + ":443 --name NGINX-" + req.params.port + " --hostname NGINX-" + req.params.port + " nginx_forward_proxy";
    console.log("Run command: " + command);
    runCommand(command);
    res.send("SUCCESS");
});
app.get('/api/docker/listen/:port', function (req, res) {
    var command = "docker exec -itd NGINX-" + req.params.port + " /usr/local/nginx/sbin/nginx";
    console.log("Run command: " + command);
    runCommand(command);
    res.send("SUCCESS");
});
app.get('/api/docker/cp/:port/:file/:directory', function (req, res) {
    var command = "docker cp /home/nginx/nginx/" + req.params.file + " NGINX-" + req.params.port + ":/usr/local/nginx/" + req.params.directory;
    console.log("Run command: " + command);
    runCommand(command);
    res.send("SUCCESS");
});
app.get('/api/docker/rm/:port', function (req, res) {
    var command = "docker rm -f NGINX-" + req.params.port;
    console.log("Run command: " + command);
    runCommand(command);
    res.send("SUCCESS");
});
app.get('/api/docker/response/:port/:response', function (req, res) {
    var command = "docker exec -itd NGINX-" + req.params.port + " /usr/local/nginx/sbin/nginx_" + req.params.response + ".sh";
    console.log("Run command: " + command);
    runCommand(command);
    res.send("SUCCESS");
});
function runCommand(cmd, callback) {
    if (callback == undefined) {
        return new Promise(function (resolve, reject) {
            exec(cmd, function (error, stdout, stderr) {
                if (error != undefined) {
                    reject(error);
                }
                if (stderr) {
                    console.error("" + stderr);
                }
                resolve(stdout);
            });
        });
    }
}
app.listen(8880, function () { return console.log('listening on port 8880...'); });
