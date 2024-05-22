TickEffect = class("TickEffect", GameObject)


function TickEffect:new(area, x, y, opts)
    TickEffect.super.new(self, area, x, y, opts)

    self.w, self.h = 48, 32
    self.timer:tween(0.13, self, {h = 0}, 'in-out-cubic', function() self.dead = true end)
end


function TickEffect:update(dt)
    TickEffect.super.update(self, dt)

    if self.parent then self.x, self.y = self.parent.x, self.parent.y end
end


function TickEffect:draw()
    love.graphics.setColor(default_color)
    love.graphics.rectangle("fill", self.x - self.w * 0.5, self.y - self.h * 0.5, self.w, self.h)
end


return TickEffect