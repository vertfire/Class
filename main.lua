
BaseClass = {}
BaseClass.__type = "BaseClass"
BaseClass.__index = BaseClass;
setmetatable(BaseClass,{__index=BaseClass})
function BaseClass.new ()
    local obj = {}
    setmetatable(obj,BaseClass);
    return obj
end



