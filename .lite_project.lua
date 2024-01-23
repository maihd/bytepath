local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local console = require "plugins.console"

command.add(nil, {
    ["project:run-project"] = function()
        core.log "Running..."

        local prefix = (PLATFORM == "Windows" and "" or "./")
        local ext = (PLATFORM == "Windows" and ".bat" or ".sh")
        console.clear()
        console.run {
            command = prefix .. "start_dev" .. ext,
            file_pattern = "(.*):(%d+):(%d+): (.*)$",
            on_complete = function ()
                core.log "Run complete"
            end,
        }
    end
})

keymap.add { ["ctrl+shift+r"] = "project:run-project" }
