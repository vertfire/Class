function class()
    local c = {}
    local callFuncsTable = {}
    local mt = {
        __index = function(self,i)
            if rawget(self,i) then return rawget(self,i) end 
            if callFuncsTable[i] then return callFuncsTable[i] end 
            error("Index is not in the table")
        end,


        __newindex = function(self,i,v)
            if type(v) == "function" and callFuncsTable[i] then 
                -- we must resolve the double referencing 
                if type(callFuncsTable[i]) == "table"then
                    funcTable = getmetatable(callFuncsTable[i]).funcTable; 
                    funcTable[debug.getinfo(v).nparams] = v; 
                else 
                    local callTable = {}
                    local funcTable = {
                        [debug.getinfo(callFuncsTable[i]).nparams] = callFuncsTable[i],
                        [debug.getinfo(v).nparams] = v,
                    }
                    local cMt = {
                        funcTable = funcTable,
                        __call = function(self, ...)
                            if not funcTable[#{...}] then error("There is no overload of the function with the given amount of parameters") end
                            return funcTable[#{...}](...)
                        end
                    }
                    setmetatable(callTable,cMt)
                    callFuncsTable[i] = callTable

                end 
            elseif type(v) == "function" then  
                rawset(callFuncsTable,i,v)
            else 

            end 
        end
    }


    setmetatable(c,mt)
    return c; 
end