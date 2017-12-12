local class = require "classComponent"

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

function test_class_components()
	local partOne = {
		constructor = function (self, name)
			self.name = name
		end,

		data = {
			name = 'o',
			one = 1
		}, 

		methods = {
			changeOne = function(self, var)
				self.one = var
				return self.one
			end,
			getName = function(self)
				return self.name
			end
		}
	}
	local partTwo = {
		constructor = function (self, name)
			self.name = "asdf"
		end,

		data = {
			name = 'a',
			two = 2
		}, 

		methods = {
			getTwo = function(self)
				return self.two
			end, 
			changeOne = function(self)
				self.two = 1
				return self.two
			end
		}
	}

	local Entity = class.class()
	-- append constructor values as parameters
	local entity1 = Entity.new()
	entity1:addComponent("partOne", partOne, "aa")
	entity1:addComponent("partTwo", partTwo)
	
	print("------ component test ------")
	assert(entity1.partOne.getName() == "aa")
	assert(entity1.partOne.changeOne(self, 3) == 3)
	assert(entity1.partTwo.getTwo() == 2)
	assert(entity1.partTwo.changeOne() == 1)
	assert(entity1.partTwo.getTwo() == 1)
	print("------ mixin test ------")
	assert(entity1.getTwo(self) == 1)
	assert(entity1.changeOne(self) == "duplicate method names: use components to call method")

end

test_class_components()