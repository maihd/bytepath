-- Base data structure and runtime

require "modules.base.class"

-- Deps

Func = require "libraries.luafun.fun"

-- Object = require "libraries.rxi.classic"
Object = class("Object")

Input = require "libraries.input.Input"
Timer = require "libraries.timer.Timer"

Camera = require "libraries.camera.camera"
require "libraries.camera.Shake"

Physics = require "libraries.windfield"

-- Deps initialization

Func()

-- utils

require "modules.utils"

-- Game modules

require "modules.rooms.Stage"
require "modules.Area"
require "modules.GameObject"

require "modules.objects.Player"

-- Program

function love.load()
    -- Settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    -- Fields
    rooms = {}
    current_room = nil
    current_room_name = nil

    input = Input()
    camera = Camera()

    -- Input bindings

    input:bind("a", "left")
    input:bind("d", "right")
    input:bind("left", "left")
    input:bind("right", "right")

    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)

    -- Startup

    resize(3)
    gotoRoom('Stage', 'Stage')
end

function love.update(dt)
    if current_room then
        current_room:update(dt)
    end

    input:update(dt)
    camera:update(dt)
end

function love.draw()
    if current_room then
        current_room:draw()
    end

    -- Update stats
    love.graphics.print("fps: " .. love.timer.getFPS(), 5, 5)
    love.graphics.print("room: " .. (current_room_name or "nil"), 5, 25)
end

function addRoom(room_type, room_name, ...)
    local room = _G[room_type](...)
    rooms[room_name] = room
    return room
end

function gotoRoom(room_type, room_name, ...)
    if current_room and current_room.destroy then
        current_room:destroy()
    end

    current_room = _G[room_type](...)
end

function resize(s)
    love.window.setMode(s * gw, s * gh)
    sx, sy = s, s
end

function random(min, max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end

function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
            f(t)
        seen[t] = true
        for k,v in pairs(t) do
            if type(v) == "table" then
            count_table(v)
            elseif type(v) == "userdata" then
            f(v)
            end
        end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function (o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
        for k,v in pairs(_G) do
            global_type_table[v] = k
        end
        global_type_table[0] = "table"
    end

    return global_type_table[getmetatable(o) or 0] or "Unknown"
end
