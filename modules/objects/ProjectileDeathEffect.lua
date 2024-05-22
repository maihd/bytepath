ProjectileDeathEffect = class("ProjectileDeathEffect", GameObject)


function ProjectileDeathEffect:new(area, x, y, opts)
    ProjectileDeathEffect.super.new(self, area, x, y, opts)

    self.first = true
    self.second = false

    self.timer:after(0.1, function()
        self.first = false
        self.second = true
        self.timer:after(0.15, function()
            self.second = false
            self.dead = true
        end)
    end)
end


function ProjectileDeathEffect:draw()
    if self.first then 
        love.graphics.setColor(default_color)
    elseif self.second then 
        love.graphics.setColor(self.color)
    else
        love.graphics.setColor(self.color)
    end

    love.graphics.rectangle("fill", self.x - self.w * 0.5, self.y - self.w * 0.5, self.w, self.w)
end


return ProjectileDeathEffect