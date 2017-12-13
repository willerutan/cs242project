local function class()

  local Class = {}

  function print_table(t)
    function pr(t, i)
      local spacing = " "
      spacing = spacing:rep(i*2)
      for k, v in pairs(t) do
        if type(v) == "table" then
          print(spacing .. k .. " = {")
          pr(v, i + 1)
          print(spacing .. "}")
        else
          print(spacing .. k .. " = " .. tostring(v))
        end
      end
    end
    pr(t, 0)
  end

  --components
  
  function Class.new( )
    local inst = {}
    inst.components = {}
    inst.isinstance = function( ... )
      return false
    end
    function inst.addComponent(self, name, component, ...)
      if type(component) == "table" then
        local dataInst = {}
        local getData = function(t, k)
          return component.data[k] or component.methods[k]
        end
        setmetatable(dataInst, {__index = getData})
        
        component.constructor(dataInst, ...)
        self.components[name] = component
        for k, v in pairs(component.methods) do
          if type(v) == "function" and k ~= "new" and k ~= "isinstance" then
            -- print(k, v)
            if self[k] == nil then
              self[k] = function(...)
                return component.methods[k](dataInst, ...)
              end
            elseif type(self[k]) == "function" then
              self[k] = function(...)
                return "duplicate method names: use components to call method"
              end
            end
          end
        end
        local componentFunc = function(t, k)        
          if component.methods[k] == nil then
            return nil
          else
            local f = function(t, ...)
              return component.methods[k](dataInst, ...)
            end
            return f
          end
        end
        local componentInst = {}
        setmetatable(componentInst, {__index = componentFunc})
        self[name] = componentInst
      end
    end
    return inst
  end
  return Class

end
return {class = class}