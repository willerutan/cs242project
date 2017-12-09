local class = require("class")

function test_classes()
  local Mixin = {}
  function Mixin:foo() return 'foo' end
  function Mixin:bar() return 'bar' end
  local ParentClass = class.class(
    class.Object, {
      constructor = function(self)
        self.should_change = 2
      end,

      methods = {
        call = function(self, f) f() end,
        check_private_var = function(self) assert(self.should_change == 2) end,
        assign_undeclared = function(self) self.undeclared = 0 end
      },

      data = {
        should_change = 1,
      },

    metamethods = {__add = function() return 3 end}
  })

  local ChildClass = class.class(
    ParentClass, {
      constructor = function(self, ...)
        ParentClass.constructor(self, ...)
      end,

      methods = {
        call_parent_method = function(self)
          self:call(function() assert(self.should_change == 2) end)
        end,
      }
  })

  local GrandchildClass = class.class(ChildClass, {})

  function private_field_from_outside()
    local c = ParentClass.new()
  print('result:', c.should_change)
    assert(c.should_change == nil)
  end

  function private_field_from_callback()
    local c = ParentClass.new()
    c:call(function() assert(c.should_change == nil) end)
  end

  function private_field_from_method()
    local c = ParentClass.new()
    c:check_private_var()
  end

  function isinstance()
    local c = ChildClass.new()
    assert(c:isinstance(class.Object))
    assert(c:isinstance(ChildClass))
    assert(c:isinstance(ParentClass))
    assert(not c:isinstance(GrandchildClass))
  end

  function one_long_inheritance()
    local c = ChildClass.new()
    c:call_parent_method()
  end

  function two_long_inheritance()
    local c = GrandchildClass.new()
    c:call_parent_method()
  end

  function assign_undeclared_member()
    local c = ParentClass.new()
    c:assign_undeclared()
    assert(c.undeclared == nil)
  end

  function mixin()
    ParentClass:include(Mixin)
    local c = ParentClass.new()
    local d = ChildClass.new()
    print("mixin")
    assert(c.foo() == "foo")
    assert(c.bar() == "bar")
    assert(d.foo() == "foo")
    assert(d.bar() == "bar")
  end

  private_field_from_outside()
  --private_field_from_callback()
  private_field_from_method()
  isinstance()
  one_long_inheritance()
  two_long_inheritance()
  assign_undeclared_member()
  mixin()

  print("All tests succeeded!")
end

test_classes()
