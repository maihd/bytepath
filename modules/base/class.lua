function class(name, ...)
    local supers = { ... }

    local class = {}

    -- Copy fields of supers to this class, this is also support mixins
    for _, super in ipairs(supers) do
        for key, value in pairs(super) do
            class[key] = value
        end
    end

    -- Meta table of this class
    setmetatable(class, {
        __call = function (_, ...)
            local object = setmetatable({}, class)
            object:new(...)
            return object
        end,

        __tostring = function ()
            return "#Class " .. name
        end
    })

    -- Class basic fields
    class.__name = name
    class.__index = class
    class.__supers = supers

    -- Compat fields of rxi/classic
    class.super = supers[1]

    -- Create new class with super is this class, this function help compat with rxi/classic
    function class.extend(...)
        return _G.class("ChildOf<" .. name .. ">", class, ...)
    end

    -- Constructor, this function help compat with rxi/classic
    function class.new(...)
    end

    -- Custom stringify for tostring
    function class.__tostring()
        return name
    end

    return class
end
