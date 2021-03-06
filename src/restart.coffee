child_process = require "child_process"
process = require "process"
path = require "path"
fs = require "fs"

# Azure CLI executable
cli = path.normalize __dirname + "/../node_modules/azure-cli/bin/azure"

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
  # Automatically set HOME if not given.
  if !process.env.HOME
    console.log "Environment variable HOME is not given. Set to '/root'"
    process.env.HOME = "/root"

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
