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
  constructor = function(self, itemType)
    -- print("game", game, pos)
    self.itemType = itemType
  end,

  data = {
    itemType = "bomb"
  }, 

  methods = {
      ItemType = function(self)
        return self.itemType
      end,

      Char = function(self)
			  return "B"
      end,

      Color = function(self)
    		return termfx.color.MAGENTA
      end,

      ComputeLighting = function(self, a, intensity)
        -- not sure why I need a _ variable
        -- print_table(a)
        local _, r, g, b = termfx.colorinfo(a:Color())
        return termfx.rgb2color(
          math.ceil(r * intensity / 256.0 * 5.0),
          math.ceil(g * intensity / 256.0 * 5.0),
          math.ceil(b * intensity / 256.0 * 5.0))
      end
  }
}


return basicItem

      
