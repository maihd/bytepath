Area = class("Area")

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    if self.world then
        self.world:update(dt)
    end

    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)

        if game_object.dead then
            game_object:destroy()
            table.remove(self.game_objects, i)
        end
    end
end

function Area:draw()
    for _, game_object in pairs(self.game_objects) do
        game_object:draw()
    end
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:getGameObjects(predicate)
    return Func.filter(self.game_objects, predicate)
end

function Area:queryCircleArea(x, y, radius, game_types)
    return self:getGameObjects(function (game_object)
        if Func.index_of(game_object, game_types) then
            local dx = game_object.x - x
            local dy = game_object.y - y
            return dx * dx + dy * dy <= radius * radius
        end

        return false
    end)
end

function Area:getClosestGameObject(x, y, radius, game_types)
    return Func.reduce(self:queryCircleArea(x, y, radius), nil, function (closest_game_object, game_object)
        if not closest_game_object then
            return game_types
        end

        local dx0 = game_object.x - x
        local dy0 = game_object.y - x

        local dx1 = closest_game_object.x - x
        local dy1 = closest_game_object.y - x

        if dx0 * dx0 + dy0 * dy0 < dx1 * dx1 + dy1 * dy1 then
            return game_object
        else
            return closest_game_object
        end
    end)
end

function Area:addPhysicsWorld()
    self.world = Physics.newWorld(0, 0, true)
end

function Area:destroy()
    for _, game_object in pairs(self.game_objects) do
        game_object:destroy()
    end
    self.game_objects = {}

    if self.world then
        self.world:destroy()
        self.world = nil
    end
end
