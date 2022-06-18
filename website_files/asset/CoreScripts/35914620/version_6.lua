local screen = script.Parent:FindFirstChild("BuildTools")

local BottomLeftControl = script.Parent:FindFirstChild("BottomLeftControl")
local BottomRightControl = script.Parent:FindFirstChild("BottomRightControl")
local TopLeftControl = script.Parent:FindFirstChild("TopLeftControl")

if screen.AbsoluteSize.x > screen.AbsoluteSize.y then
	makeYRelative()
	else
		makeXRelative()
end

screen.Changed:connect(function(property)

	if property == "AbsoluteSize" then
		if screen.AbsoluteSize.x > screen.AbsoluteSize.y then
			makeYRelative()
		else
			makeXRelative()
		end
	end

end)



function makeYRelative()

	BottomLeftControl.SizeConstraint = 2
	BottomRightControl.SizeConstraint = 2
	screen.Frame.SizeConstraint = 2
	TopLeftControl.SizeConstraint = 2
	BottomLeftControl.Position = UDim2.new(0,0,1,-BottomRightControl.AbsoluteSize.Y)
	BottomRightControl.Position = UDim2.new(1,-BottomRightControl.AbsoluteSize.X,1,-BottomRightControl.AbsoluteSize.Y)

end



function makeXRelative()
	
	BottomLeftControl.SizeConstraint = 1
	BottomRightControl.SizeConstraint = 1
	TopLeftControl.SizeConstraint = 1
	screen.Frame.SizeConstraint = 1
	BottomLeftControl.Position = UDim2.new(0,0,1,-math.floor(BottomLeftControl.AbsoluteSize.Y))
	BottomRightControl.Position = UDim2.new(1,-BottomRightControl.AbsoluteSize.X,1,-BottomRightControl.AbsoluteSize.Y)

end
