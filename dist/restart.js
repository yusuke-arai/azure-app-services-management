// Generated by CoffeeScript 1.10.0
(function() {
  var child_process, exec, execSync, main, process, validator;

  child_process = require("child_process");

  process = require("process");

  validator = require("validator");

  exec = function(command, success) {
    return child_process.exec(command + " --json", function(error) {
      if (error !== null) {
        console.log(error.message);
        process.exit(1);
      }
      console.log("Done: " + command);
      return success();
    });
  };

  execSync = function(commands) {
    return (commands.reduceRight(function(prev, current) {
      return function() {
        return exec("" + current, prev);
      };
    }, function() {}))();
  };

  main = function() {
    var cli, resourceGroup, serviceName;
    cli = "node_modules/azure-cli/bin/azure";
    if (process.argv.length !== 4 || !validator.isAscii(process.argv[2]) || !validator.isAscii(process.argv[3])) {
      console.log("Usage: restart.coffee <resource_group> <service_name>");
      process.exit(1);
    }
    resourceGroup = process.argv[2];
    serviceName = process.argv[3];
    return execSync([cli + " config mode arm", cli + " webapp restart " + resourceGroup + " " + serviceName]);
  };

  main();

}).call(this);

//# sourceMappingURL=restart.js.map
