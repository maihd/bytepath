require "libraries.luafun.fun" ()

Object = require "libraries.rxi.classic"

require "libraries.input.Input"
require "libraries.timer.Timer"

function love.load()

end

function love.update()

end

function love.draw()
    love.graphics.print("fps: " .. love.timer.getFPS(), 0, 0);
end