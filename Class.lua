local luatype = type; 
function type (x)
    if luatype(x) == "table" and getmetatable(x) then 
        return getmetatable(x).__type or "table"
    else 
        return luatype(x)
    end
end

function class(type2)

    local indexTable = {}
    local c = {
        __indexTable = indexTable,
        __type = type2,
        __index = function (self,i)
            local packedFunction = {} 
            for _, cls  in pairs(indexTable) do
                local a = getmetatable(cls[i])
                if cls[i] then 


                    if type(cls[i]) == "FuncTable" then 
                        packedFunction[#packedFunction+1] = cls[i] 
                        else 
                        return cls[i] 
                    end
                end  
            end

            if #packedFunction > 0 then 
                setmetatable(packedFunction,{
                    __call = function(self2,...)
                        local paraCount = #({...})
                        for _, fT in pairs(self2) do 
                            local funcTable = getmetatable(fT).funcTable
                            if funcTable[paraCount] then 
                                local retTable = {...}
                                retTable[1] = self

                                return funcTable[paraCount](unpack(retTable)); 
                            end
                        end
                        error("There is no overload of the function with the given amount of parameters")
                    end
                })
                return packedFunction
            end 
            error("Index not in class or any of its parents")
        end 
    }

    indexTable[1] = c; 
    local callFuncsTable = {}
    local mt = {
        __index = function(self,i)
            if rawget(self,i) then return rawget(self,i) end 
            local a = (getmetatable(callFuncsTable[i]))
            if callFuncsTable[i] then return callFuncsTable[i] end 
            return nil; 
        end,
        __newindex = function(self,i,v)
            if type(v) == "function" then 
                -- we must resolve the double referencing 
                if type(callFuncsTable[i]) ~= "table"then
                    local callTable = {}
                    local funcTable = {}
                    setmetatable(funcTable, {
                        __type = "FunctionOrder"
                    })
                    local cMt = {
                        __type = "FuncTable", 
                        funcTable = funcTable,
                        __call = function(self, ...)
                            if not funcTable[#{...}] then error("There is no overload of the function with the given amount of parameters") end
                            return funcTable[#{...}](...)
                        end
                    }
                    setmetatable(callTable,cMt)
                    callFuncsTable[i] = callTable
                end
                local mt = getmetatable(callFuncsTable[i])
                mt.funcTable[debug.getinfo(v).nparams] = v;

            else 
                rawset(self,i,v)
            end 
        end
    }


    setmetatable(c,mt)
    return c; 
end


function inherit(base,sub)
    sub.__indexTable[#(sub.__indexTable)+1]= base
end