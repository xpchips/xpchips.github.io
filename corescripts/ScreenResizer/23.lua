-- this script is responsible for keeping the gui proportions under control

local screen = script.Parent

local BottomLeftControl
local BottomRightControl
local TopLeftControl
local BuildTools
local PlayerListBottomRightFrame

local controlFrame = script.Parent:FindFirstChild("ControlFrame")

-- if using new system, find our stuff
if controlFrame then
	BottomLeftControl = controlFrame:FindFirstChild("BottomLeftControl")
	BottomRightControl = controlFrame:FindFirstChild("BottomRightControl")
	TopLeftControl = controlFrame:FindFirstChild("TopLeftControl")
	BuildTools = controlFrame:FindFirstChild("BuildTools")
else
	BottomLeftControl = script.Parent:FindFirstChild("BottomLeftControl")
	BottomRightControl = script.Parent:FindFirstChild("BottomRightControl")
	TopLeftControl = script.Parent:FindFirstChild("TopLeftControl")
	BuildTools = script.Parent:FindFirstChild("BuildTools")
	PlayerListBottomRightFrame = script.Parent:FindFirstChild("PlayerListBottomRightFrame")
end


function makeYRelative()

	BottomLeftControl.SizeConstraint = 2
	BottomRightControl.SizeConstraint = 2
	BuildTools.Frame.SizeConstraint = 2
	TopLeftControl.SizeConstraint = 2
	
	BottomLeftControl.Position = UDim2.new(0,0,1,-BottomLeftControl.AbsoluteSize.Y)
	BottomRightControl.Position = UDim2.new(1,-BottomRightControl.AbsoluteSize.X,1,-BottomRightControl.AbsoluteSize.Y)
end



function makeXRelative()

	BottomLeftControl.SizeConstraint = 1
	BottomRightControl.SizeConstraint = 1
	TopLeftControl.SizeConstraint = 1
	BuildTools.Frame.SizeConstraint = 1

	BottomLeftControl.Position = UDim2.new(0,0,1,-BottomLeftControl.AbsoluteSize.Y)
	BottomRightControl.Position = UDim2.new(1,-BottomRightControl.AbsoluteSize.X,1,-BottomRightControl.AbsoluteSize.Y)

end

local function resize()
	if screen.AbsoluteSize.x > screen.AbsoluteSize.y then
		makeYRelative()
	else
		makeXRelative()
	end
	if PlayerListBottomRightFrame then
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

