var express = require('express');
var app = express();
var exec = require("child_process").exec;
app.get('/api/docker/run/:port', function (req, res) {
    var command = "docker run -t -d -p " + req.params.port + ":443 --name NGINX-" + req.params.port + " --hostname NGINX-" + req.params.port + " nginx_forward_proxy";
    runCommand(command);
    command = "docker exec -it NGINX-" + req.params.port + " /usr/local/nginx/sbin/nginx";
    runCommand(command);
    res.send("SUCCESS");
});
app.get('/api/docker/rm/:port', function (req, res) {
    var command = "docker rm -f NGINX-" + req.params.port;
    runCommand(command);
    res.send("SUCCESS");
});
app.get('/api/docker/:port/:response', function (req, res) {
    var command = "docker exec -it NGINX-" + req.params.port + " /usr/local/nginx/sbin/nginx_ " + req.params.response + ".sh";
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
                    console.log("" + stderr);
                }
                resolve(stdout);
            });
        });
    }
}
app.listen(8880, function () { return console.log('listening on port 8880...'); });
