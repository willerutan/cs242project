local Object
Object = {
  isinstance = function(cls) return cls == Object end,
  constructor = function() end,
  methods = {},
  data = {},
  metamethods = {}
}


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


-- This is a utility function you will find useful during the metamethods section.
function table.merge(src, dst)
  for k,v in pairs(src) do
    if not dst[k] then dst[k] = v end
  end
end

local function class(parent, child)

  -- The "child.methods or {}" syntax can be read as:
  -- "if child.methods is nil then this expression is {}, otherwise it is child.methods"
  -- Generally, "a or b" reduces to b if a is nil or false, evaluating to a otherwise.
  local methods = child.methods or {}
  local data = child.data or {}
  local constructor = child.constructor or parent.constructor
  local metamethods = child.metamethods or {}
	local parent_metamethods = parent.metamethods or {}


  local Class = {}

	Class.methods = methods
	Class.data = data
	Class.constructor = constructor
	Class.metamethods = metamethods
	table.merge(parent_metamethods, Class.metamethods)
	--Class.immortal = {}
	Class.currentState = nil
	Class.states = {}

	setmetatable(Class.methods, {__index = parent.methods})
	setmetatable(Class.data, {__index = parent.data})

	
	function Class.isinstance(self, cls)
		if cls == Class then
			return true
		elseif parent == Object then
			return Object.isinstance(cls)
		else
			return parent.isinstance(self, cls)
		end
	end
		

  	function Class.new(...)

		local public_inst = {}
		local private_inst = {}

		local privateIdxFunc = function(t, k)
			return Class.data[k] or public_inst[k]
		end

		local private_meta_combined = {}
		table.merge(Class.metamethods, private_meta_combined)
		table.merge({__index = privateIdxFunc}, private_meta_combined)
		setmetatable(private_inst, private_meta_combined)
	

		local publicIdxFunc = function(t, k)
			local state = Class.currentState
			if state ~= nil and Class.states[state] ~= nil then
				if Class.states[state][k] ~= nil then
					local f = function(t, ...)
						return Class.states[state][k](private_inst, ...)
					end
					return f
				end
			end

			if Class.methods[k] == nil then
				return nil
			else
				local f = function(t, ...)
					return Class.methods[k](private_inst, ...)
				end
				return f
			end
		end

	   
		local public_meta_combined = {}
		table.merge({__index = publicIdxFunc}, public_meta_combined)
		table.merge(Class.metamethods, public_meta_combined)
		setmetatable(public_inst, public_meta_combined)

		Class.constructor(private_inst, ...)

		function public_inst:isinstance(cls)
			return Class.isinstance(self, cls)
		end

		function public_inst:gotoState(state)
			Class.currentState = state
		end

		function public_inst:getState()
			return Class.currentState
		end

  		return public_inst

	end


	function Class:addState(state)
		Class.states[state] = {}
		return Class.states[state]
	end

  return Class

end

return {class = class, Object = Object}
