
require("Class")

BaseClass = class("BaseClass")

function BaseClass.new (number, otherNumber)
    local obj = {
        a = number,
        b = otherNumber; 
    }
    setmetatable(obj,BaseClass);
    return obj
end

function BaseClass:add ()
    return self.a + self.b
end



local b = BaseClass.new(1,3)
print(b:add()); 


SubClass = class()

function SubClass.new (a,b)
    local obj = {
        a = a,
        b = b; 
    }
    setmetatable(obj,SubClass);
    return obj
end

function SubClass:subtract ()
    return self.a - self.b; 
end


local c = SubClass.new(1,3)
print(c:subtract()); 