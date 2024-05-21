-- Create new class
-- Features:
--  + Support multi-inherit
--  + Mixins (https://github.com/a327ex/blog/issues/2)
--  + Compat with rxi/classic.lua
--  + Simple implementation in one class (but not better than other implementations, use with care)
function class(name, ...)
    assert(type(name) == "string", "A name (string) is needed for the new class")

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
    function class.extend(self, className, ...)
        className = className or ("ChildOf<" .. name .. ">")
        return _G.class(className, class, ...)
    end

    -- Constructor, this function help compat with rxi/classic
    function class.new(...)
    end

    -- Custom stringify for tostring
    function class.__tostring()
        return name
    end

    -- Check object is-a instance of class
    function class.is(self, class)
        local mt = getmetatable(self)
        if mt == class then
            return true
        end

        for _, super in ipairs(supers) do
            if super == class then
                return true
            end
        end

        return false
    end

    return class
end

return class
