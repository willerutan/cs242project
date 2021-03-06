local Point = require "point"

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

local id = 1000

local basicItem = {
  constructor = function(self, game, pos)
    -- print("game", game, pos)
    self.game = game
    self.pos = pos
    self.id = id
    id = id + 1
  end,

  data = {
    id = 1000,
    pos = Point.new(0, 0),
    value = 0
  }, 

  methods = {

      Id = function(self)
        return self.id
      end,

      Pos = function(self)
        return self.pos
      end,

      SetPos = function(self, pos)
        self.pos = pos
      end,

      Value = function(self)
        return self.value
      end,

      SetVal = function(self, val)
        self.value = val
      end,

      Health = function( ... )
        return 0
      end,

      SetHealth = function(self, h)
        
      end,

      Think = function(self) end
  }
}


return basicItem

      
