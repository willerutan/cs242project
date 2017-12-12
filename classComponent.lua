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
  Class.components = {}
  function Class.addComponent(self, name, component, ...)
    if type(component) == "table" then
      component.constructor(component.data, ...)
      self.components[name] = component
      for k, v in pairs(component.methods) do
        if type(v) == "function" and k ~= "new" then
          if Class[k] == nil then
            Class[k] = function(...)
              return component.methods[k](component.data, ...)
            end
          else
            Class[k] = -1
          end
        end
      end
      -- print_table(Class)
      return component
    end
    -- print_table(Class.components)
  end

  function Class.new(...)
    -- print("------------ class components ------------")
    -- print_table(Class.components)
    local inst = {}
    for name, component in pairs(Class.components) do
      local componentFunc = function(t, k)        
        if Class.components[name].methods[k] == nil then
          return nil
        else
          -- print(t, k)
          local f = function(t, ...)
            return Class.components[name].methods[k](Class.components[name].data, ...)
          end
          return f
        end
      end
      local componentInst = {}
      setmetatable(componentInst, {__index = componentFunc})
      inst[name] = componentInst
    end
    local mixinFunc = function(t, k)
      if Class[k] == nil then
        return nil
      elseif Class[k] == -1 then
        return function( ... )
          return "duplicate method names: use components to call method"
        end
      else
        local f = function(t, ...)
          return Class[k](...)
        end
        return f
      end
    end
    setmetatable(inst, {__index = mixinFunc})
    return inst
  end
  return Class

end
return {class = class}