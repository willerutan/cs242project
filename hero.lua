local Entity = require "entity"


function print_table(t)
  function pr(t, i)
    local spacing = " "
    spacing = spacing:rep(i*2)
    for k, v in pairs(t) do
      if type(v) == "table" then
        print(spacing .. tostring(k) .. " = {")
        pr(v, i + 1)
        print(spacing .. "}")
      else
        print(spacing .. tostring(k) .. " = " .. tostring(v))
      end
    end
  end
  pr(t, 0)
end


local Hero = class.class(
  Entity, {
    methods = {
      Collide = function(self, e)
        if e:Id() < 1000 then
          self.game:Log("You hit a monster for 10 damage.")
          e:SetHealth(e:Health() - 10)
		else
			if e.ItemType() == 'immortal' then
				self.game:DeleteEntity(e)
				self.game:GoImmortal()
			end
			if e.ItemType() == 'bomb' then
				self.game:DeleteEntity(self)
			end
        end
      end,

      SetHealth = function(self, h)
        self.game:Log(string.format('Your health is now %d', h))

        Entity.methods.SetHealth(self, h)
      end,

	  Think = function(self)
		--self.game:Log('Hero is thinking in normal mode!!')
	  end
    }
})


local immortal = Hero:addState('immortal')


function immortal:SetHealth(h)
  	self.game:Log('I am UNBREAKABLE!!')
end

function immortal:Think()
	--print('Hero is thinking in immortal mode!!')
	--self.game:Log('Hero is thinking in immortal mode!!')
end

function immortal:Color(self)
	return termfx.color.MAGENTA
end

function immortal:Char(self)
	return '@'
end

local weak = Hero:addState('weak')

function weak:Think()
	--self.game:Log('Hero is weak ..... orz')
end

function weak:Char(self)
	return 'w'
end

function weak:Color(self)
	return termfx.color.WHITE
end

function weak:SetHealth(h)
    self.game:Log(string.format('You are weak! Your health is now %d', h-2))
    Entity.methods.SetHealth(self, h-2)
end


return Hero
