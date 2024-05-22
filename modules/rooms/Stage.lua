Stage = class("Stage")

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()

    self.main_canvas = love.graphics.newCanvas(gw, gh)

    input:bind("f4", function()
        if self.player then
            -- self.player.dead = true
            slow(0.15, 1)
            
            self.player:die()
            self.player = nil
        end
    end)

    input:bind("f3", function() camera:shake(4, 60, 1) end)
    input:bind("f5", function()
        if not self.player then
            self.player = self.area:addGameObject("Player", gw / 2, gh / 2)
        end
    end)
end

function Stage:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw / 2, gh / 2)

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    do
        love.graphics.clear()

        camera:attach(0, 0, gw, gh)

        self.area:draw()

        camera:detach()
    end
    love.graphics.setCanvas()

    -- Draw canvas
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode("alpha")
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
end
