ShootEffect = class("ShootEffect", GameObject)


function ShootEffect:new(...)
    ShootEffect.super.new(self, ...)

    self.w = 8
    self.timer:tween(0.1, self, { w = 0 }, "in-out-cubic", function ()
        self.dead = true
        self.player = nil
    end)
end


function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)

    if self.player then
        self.x = self.player.x + self.d * math.cos(self.player.r)
        self.y = self.player.y + self.d * math.sin(self.player.r)
    end
end


function ShootEffect:draw()
    -- Ex82
    -- pushRotate(self.player.x, self.player.y, math.pi)

    -- Ex85
    -- pushRotate(self.player.x, self.player.y, math.pi * 0.5)

    pushRotate(self.x, self.y, self.player.r + math.pi * 0.25)

    love.graphics.setColor(default_color)
    love.graphics.rectangle("fill", self.x - self.w * 0.5, self.y - self.w * 0.5, self.w, self.w)
    love.graphics.pop()

    -- For Ex
    -- love.graphics.pop()
end