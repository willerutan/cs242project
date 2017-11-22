function table.merge(src, dst)
  for k,v in pairs(src) do
    if not dst[k] then dst[k] = v end
  end
end



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



a = {}
b = {f = function(x) print(x) end}

b.f(2)
--print('a:', a)
setmetatable(a, {__index = function(t,k) return b[k] end})
--f2 = a.f
--f2(5)
a.f(6)


c = {x = 1}
d = {y = 3}
print_table(c)
print_table(d)
table.merge(c, d)
print_table(d)
