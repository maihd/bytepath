Player = class("Player", GameObject)


function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)

    self.r = -math.pi * 0.5
    self.rv = 1.66 * math.pi
    self.v = 0
    self.max_v = 100
    self.a = 100

    -- Shooting
    self.attack_speed = 1
    self.timer:every(5, function ()
        self.attack_speed = random(1, 2)
    end)

    self:prepareShoot()
end


function Player:prepareShoot()
    self.timer:after(0.24 / self.attack_speed, function ()
        self:shoot()
        self:prepareShoot()
    end)
end


function Player:update(dt)
    Player.super.update(self, dt)

    if input:down("left") then
        self.r = self.r - self.rv * dt
    end

    if input:down("right") then
        self.r = self.r + self.rv * dt
    end

    self.v = math.min(self.v + self.a * dt, self.max_v)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end
end


function Player:draw()
    love.graphics.setColor(self.color or default_color)
    love.graphics.circle("line", self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end


function Player:shoot()
    local d = 1.2 * self.w

    self.area:addGameObject("ShootEffect", 
        self.x + d * math.cos(self.r),
        self.y + d * math.sin(self.r),
        {
            player = self,
            d = d
        }
    ) 
    
    self.area:addGameObject("Projectile", 
        self.x + 1.5 * d * math.cos(self.r), 
        self.y + 1.5 * d * math.sin(self.r), 
        {
            r = self.r
        }
    )
    
    -- Ex87
    -- self.area:addGameObject("Projectile", 
    --     self.x + 1.5 * d * math.cos(self.r + math.pi * 0.1), 
    --     self.y + 1.5 * d * math.sin(self.r + math.pi * 0.1), 
    --     {
    --         r = self.r + math.pi * 0.1
    --     }
    -- )
    
    -- self.area:addGameObject("Projectile", 
    --     self.x + 1.5 * d * math.cos(self.r - math.pi * 0.1), 
    --     self.y + 1.5 * d * math.sin(self.r - math.pi * 0.1), 
    --     {
    --         r = self.r - math.pi * 0.1
    --     }
    -- )
    
    -- Ex88
    -- self.area:addGameObject("Projectile", 
    --     self.x + 1.5 * d * math.cos(self.r + math.pi * 0.1), 
    --     self.y + 1.5 * d * math.sin(self.r + math.pi * 0.1), 
    --     {
    --         r = self.r
    --     }
    -- )
    
    -- self.area:addGameObject("Projectile", 
    --     self.x + 1.5 * d * math.cos(self.r - math.pi * 0.1), 
    --     self.y + 1.5 * d * math.sin(self.r - math.pi * 0.1), 
    --     {
    --         r = self.r
    --     }
    -- )
end


function Player:die()
    self.dead = true 
    for i = 1, love.math.random(8, 12) do 
    	self.area:addGameObject("ExplodeParticle", self.x, self.y) 
  	end
end