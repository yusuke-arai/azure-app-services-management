child_process = require "child_process"
process = require "process"
validator = require "validator"

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
  cli = "node_modules/azure-cli/bin/azure"

  # Check command line arguments.
  if process.argv.length != 4 or !validator.isAscii(process.argv[2]) or !validator.isAscii(process.argv[3])
    console.log "Usage: restart.coffee <resource_group> <service_name>"
    process.exit 1
  resourceGroup = process.argv[2]
  serviceName = process.argv[3]

  # Execute commands sequentially.
  execSync([
    "#{cli} config mode arm",
    "#{cli} webapp restart #{resourceGroup} #{serviceName}"
  ])

main()
