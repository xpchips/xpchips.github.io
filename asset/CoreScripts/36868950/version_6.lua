local topLeftControl = script.Parent:FindFirstChild("TopLeftControl")
local bottomLeftControl = script.Parent:FindFirstChild("BottomLeftControl")
local bottomRightControl = script.Parent:FindFirstChild("BottomRightControl")

local frame = Instance.new("TextLabel")
frame.Name = "ToolTip"
frame.Text = "Hi! I'm a ToolTip!"
frame.ZIndex = 10
frame.Size = UDim2.new(2,0,1,0)
frame.Position = UDim2.new(1,0,0,0)
frame.BackgroundColor3 = Color3.new(1,1,153/255)
frame.BackgroundTransparency = 1
frame.TextTransparency = 1
frame.TextWrap = true

local inside = Instance.new("BoolValue")
inside.Name = "inside"
inside.Value = false
inside.Parent = frame

function setUpListeners(frame)
	local fadeSpeed = 0.1
	frame.Parent.MouseEnter:connect(function()
		frame.inside.Value = true
		wait(1.2)
		if frame.inside.Value then
			while frame.inside.Value and frame.BackgroundTransparency > 0 do
				frame.BackgroundTransparency = frame.BackgroundTransparency - fadeSpeed
				frame.TextTransparency = frame.TextTransparency - fadeSpeed
				wait()
			end
		end
	end)
	frame.Parent.MouseLeave:connect(function()
		frame.inside.Value = false
		frame.BackgroundTransparency = 1
		frame.TextTransparency = 1
	end)
	frame.Parent.MouseButton1Click:connect(function()
		frame.inside.Value = false
		frame.BackgroundTransparency = 1
		frame.TextTransparency = 1
	end)
end

----------------- set up Top Left Tool Tips --------------------------

local topLeftChildren = topLeftControl:GetChildren()

for i = 1, #topLeftChildren do

	if topLeftChildren[i].Name == "Help" then
	    local helpTip = frame:clone()
	    helpTip.Text = "Click here to get Help"
	    helpTip.Parent = topLeftChildren[i]
		setUpListeners(helpTip)
	end

end

---------------- set up Bottom Left Tool Tips -------------------------

local bottomLeftChildren = bottomLeftControl:GetChildren()

for i = 1, #bottomLeftChildren do

	if bottomLeftChildren[i].Name == "Exit" then
	    local exitTip = frame:clone()
	    exitTip.Text = "Click here to leave place"
	    exitTip.Position = UDim2.new(0,0,-1,0)
	    exitTip.Size = UDim2.new(1,0,1,0)
	    exitTip.Parent = bottomLeftChildren[i]
	    setUpListeners(exitTip)
	elseif bottomLeftChildren[i].Name == "TogglePlayMode" then
	    local playTip = frame:clone()
     	playTip.Text = "Shows/Hides Roblox Studio"
	    playTip.Position = UDim2.new(0,0,-1,0)
	    playTip.Parent = bottomLeftChildren[i]
	    setUpListeners(playTip)
	elseif bottomLeftChildren[i].Name == "ToolButton" then
	    local toolTip = frame:clone()
	    toolTip.Text = "Shows Build Tools"
	    toolTip.Position = UDim2.new(0,0,-1,0)
	    toolTip.Parent = bottomLeftChildren[i]
	    setUpListeners(toolTip)
	end
end

---------------- set up Bottom Right Tool Tips -------------------------

local bottomRightChildren = bottomRightControl:GetChildren()

for i = 1, #bottomRightChildren do

	if bottomRightChildren[i].Name == "ToggleFullScreen" then
	    local fullScreen = frame:clone()
	    fullScreen.Text = "Fullscreen on/off"
	    fullScreen.Position = UDim2.new(-1,0,-1,0)
	    fullScreen.Parent = bottomRightChildren[i]
	    setUpListeners(fullScreen)
	elseif bottomRightChildren[i].Name == "ReportAbuse" then
	    local abuseTip = frame:clone()
		abuseTip.Text = "Report Abuse"
	    abuseTip.Position = UDim2.new(0,0,-1,0)
	    abuseTip.Parent = bottomRightChildren[i]
	    setUpListeners(abuseTip)
	elseif bottomRightChildren[i].Name == "Screenshot" then
	    local shotTip = frame:clone()
	    shotTip.Text = "Takes a Screenshot"
	    shotTip.Position = UDim2.new(-1,0,-1,0)
	    shotTip.Size = UDim2.new(3,0,2,0)
		shotTip.Parent = bottomRighChildren[i]
		setUpListeners(shotTip)
	end
end

