-- Deps

Function = require "libraries.luafun.fun"

Object = require "libraries.rxi.classic"

Input = require "libraries.input.Input"
Timer = require "libraries.timer.Timer"

-- Deps initialization

Function()

-- utils

require "modules.utils"

-- Game modules

require "modules.rooms.Stage"
require "modules.Area"
require "modules.GameObject"

-- Program

function love.load()
    rooms = {}
    current_room = nil
    current_room_name = nil

    gotoRoom('Stage', 'Stage')
end

function love.update(dt)
    if current_room then
        current_room:update(dt)
    end
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
    if current_room_name == room_name then
        return current_room
    end

    if current_room and current_room.deactivate then 
        current_room:deactivate()
    end

    if rooms[room_name] then
        current_room = rooms[room_name]
        current_room_name = room_name
    else
        current_room = addRoom(room_type, room_name, ...)
        current_room_name = room_name
    end

    if current_room.activate then current_room:activate() end
end