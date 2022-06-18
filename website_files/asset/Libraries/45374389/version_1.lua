local t = {}
t.foo = function() print("foo") end
t.bar = function() print("bar") end
t.Help = function(string) if string == "foo" then return "foo: prints foo" end if string == "bar" then return "bar: prints bar" end end
return t