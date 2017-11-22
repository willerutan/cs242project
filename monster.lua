local Entity = require "entity"
local Point = require 'point'

local Monster = class.class(
  Entity, {
    methods = {
      Char = function(self)
        return "%"
      end,

      Color = function(self)
        return termfx.color.RED
      end,

      Collide = function(self, e)
        self.game:Log("A monster hits you for 2 damage.")
        e:SetHealth(e:Health() - 2)
      end,

      Die = function(self, e)
        self.game:Log("The monster dies.")
      end,

      Think = function(self)
		if self:CanSee(self.game.hero) then
			--self.game:Log('can see hero!!')
			pathList = self:PathTo(self.game.hero)
			dst = pathList[#pathList - 1]
			self.game:TryMove(self, Point.new(dst:X() - self.pos:X(), dst:Y() - self.pos:Y()))
		end	
      end
    }
})

return Monster
