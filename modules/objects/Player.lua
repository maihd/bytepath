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
    self.a = 100

    self.base_max_v = 100
    self.max_v = self.base_max_v

    -- Shooting
    self.attack_speed = 1
    self.timer:every(5, function ()
        self.attack_speed = random(1, 2)
    end)

    self:prepareShoot()

    -- Ticking
    self.timer:every(5, function() self:tick() end)

    -- Trail effect
    self.trail_color = skill_point_color 
    self.timer:every(0.01, function()
        if self.ship == 'Fighter' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 

            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
        end
    end)

    -- Ship type
    self.ship = 'Fighter'
    self.polygons = {}

    if self.ship == 'Fighter' then
        self.polygons[1] = {
            self.w, 0, -- 1
            self.w/2, -self.w/2, -- 2
            -self.w/2, -self.w/2, -- 3
            -self.w, 0, -- 4
            -self.w/2, self.w/2, -- 5
            self.w/2, self.w/2, -- 6
        }
        
        self.polygons[2] = {
            self.w/2, -self.w/2, -- 7
            0, -self.w, -- 8
            -self.w - self.w/2, -self.w, -- 9
            -3*self.w/4, -self.w/4, -- 10
            -self.w/2, -self.w/2, -- 11
        }
        
        self.polygons[3] = {
            self.w/2, self.w/2, -- 12
            -self.w/2, self.w/2, -- 13
            -3*self.w/4, self.w/4, -- 14
            -self.w - self.w/2, self.w, -- 15
            0, self.w, -- 16
        }
    end
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

    -- Boosting
    
    self.max_v = self.base_max_v
    self.boosting = false
    if input:down('up') then
        self.boosting = true 
        self.max_v = 1.5 * self.base_max_v 
    end

    if input:down('down') then 
        self.boosting = true
        self.max_v = 0.5 * self.base_max_v 
    end
    
    self.trail_color = skill_point_color 
    if self.boosting then self.trail_color = boost_color end
end


function Player:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setColor(self.color or default_color)
    -- love.graphics.circle("line", self.x, self.y, self.w)
    -- love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))

    for _, polygon in ipairs(self.polygons) do
        local points = Func.map(polygon, function(v, k) 
        	if k % 2 == 1 then 
          		return self.x + v + random(-1, 1) 
        	else 
          		return self.y + v + random(-1, 1) 
        	end 
      	end)
        love.graphics.polygon("line", points)
    end

    love.graphics.pop()
end


function Player:tick()
    self.area:addGameObject("TickEffect", self.x, self.y, {parent = self})
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