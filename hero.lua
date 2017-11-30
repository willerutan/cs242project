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
        self.game:Log("You hit a monster for 10 damage.")
        e:SetHealth(e:Health() - 10)
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


--local Immortal = Hero:addState('Immortal')
--print('content of Hero.states:')
--print_table(Hero.states)

function Hero.immortal:SetHealth(h)
  	self.game:Log('I am UNBREAKABLE!!')
end

function Hero.immortal:Think()
	--print('Hero is thinking in immortal mode!!')
	--self.game:Log('Hero is thinking in immortal mode!!')
end

function Hero.immortal:Color(self)
	return termfx.color.MAGENTA
end

function Hero.immortal:Char(self)
	return '@'
end

print('content of Hero.states:')
print_table(Hero)
--[[print('content of immortal:')
print_table(Immortal)
print('content of Hero.states:')
print_table(Hero.states)

local mortal = Hero:addState('mortal')
print('content of Hero.states:')
print_table(Hero.states)]]

return Hero
