child_process = require "child_process"
process = require "process"
path = require "path"
fs = require "fs"

exec = (command, success) ->
  child_process.exec "#{command} --json", (error) ->
    if error != null
      console.log error.message
      process.exit 1
    console.log "Done: #{command}"
    success()

execSync = (commands) ->
  (
    commands.reduceRight (prev, current) ->
      () -> exec "#{current}", prev
    , () ->
  )()

main = ->
  cli = path.normalize __dirname + "/../node_modules/azure-cli/bin/azure"
  # Check Azure CLI executable file exists.
  fs.access cli, fs.constants.X_OK, (error) ->
    if error != null
      console.log error.message
      process.exit 1
    checkCommandLineArguments()

checkCommandLineArguments = ->
  if process.argv.length != 4
    console.log "Usage: restart.coffee <resource_group> <service_name>"
    process.exit 1
  resourceGroup = process.argv[2]
  serviceName = process.argv[3]
  executeCommands resourceGroup, serviceName

executeCommands = (resourceGroup, serviceName) ->
  execSync([
    "#{cli} config mode arm",
    "#{cli} webapp restart #{resourceGroup} #{serviceName}"
  ])

main()
