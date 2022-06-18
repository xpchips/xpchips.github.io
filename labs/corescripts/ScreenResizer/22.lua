-- this script is responsible for keeping the gui proportions under control

local screen = script.Parent

local BottomLeftControl = script.Parent:FindFirstChild("BottomLeftControl")
local BottomRightControl = script.Parent:FindFirstChild("BottomRightControl")
local TopLeftControl = script.Parent:FindFirstChild("TopLeftControl")

function makeYRelative()

	BottomLeftControl.SizeConstraint = 2
	BottomRightControl.SizeConstraint = 2
	screen.BuildTools.Frame.SizeConstraint = 2
	TopLeftControl.SizeConstraint = 2
	
	BottomLeftControl.Position = UDim2.new(0,0,1,-BottomLeftControl.AbsoluteSize.Y)
	BottomRightControl.Position = UDim2.new(1,-BottomRightControl.AbsoluteSize.X,1,-BottomRightControl.AbsoluteSize.Y)
end



function makeXRelative()

	BottomLeftControl.SizeConstraint = 1
	BottomRightControl.SizeConstraint = 1
	TopLeftControl.SizeConstraint = 1
	screen.BuildTools.Frame.SizeConstraint = 1

	BottomLeftControl.Position = UDim2.new(0,0,1,-BottomLeftControl.AbsoluteSize.Y)
	BottomRightControl.Position = UDim2.new(1,-BottomRightControl.AbsoluteSize.X,1,-BottomRightControl.AbsoluteSize.Y)

end

local function resize()
	if screen.AbsoluteSize.x > screen.AbsoluteSize.y then
		makeYRelative()
	else
		makeXRelative()
	end
	if screen:FindFirstChild("PlayerListBottomRightFrame") then
		screen.PlayerListBottomRightFrame.Size = UDim2.new(screen.PlayerListBottomRightFrame.Size.X.Scale, screen.PlayerListBottomRightFrame.Size.X.Offset, 0.5, -BottomRightControl.AbsoluteSize.Y - 5)
	end
end
screen.Changed:connect(function(property)

	if property == "AbsoluteSize" then
		wait()
		resize()
	end

end)

resize()

