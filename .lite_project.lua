local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local console = require "plugins.console"

command.add(nil, {
    ["project:run-project"] = function ()
        core.log "Running..."
        console.run {
          command = "love .",
          file_pattern = "(.*):(%d+):(%d+): (.*)$",
          on_complete = function() core.log "Run end!" end,
        }
    end
})

keymap.add { ["ctrl+shift+r"] = "project:run-project" }
