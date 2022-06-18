local button = script.Parent
local activated = false
local menu = script.Parent:FindFirstChild("PaintMenu")

while menu == nil do
	menu = script.Parent:FindFirstChild("PaintMenu")
	wait()
end

local moving = false
local speed = 0.35
--[[local closeButton = menu:FindFirstChild("CloseButton")

closeButton.MouseButton1Click:connect(function()

	moving = true
	activated = false
	button.Selected = false
	if activated then
		while menu.Position.X.Scale < 2.6 do
			menu.Position = UDim2.new(menu.Position.X.Scale + speed,menu.Position.X.Offset,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	else
		while menu.Position.X.Scale > -2.7 do
			menu.Position = UDim2.new(menu.Position.X.Scale - speed,menu.Position.X.Offset,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	end
	moving = false
end)                 ]]

button.Changed:connect(function(property)

	if property ~= "Selected" then return end
	if moving then return end
	moving = true activated = button.Selected
	if activated then
		while menu.Position.X.Scale < 2.6 do
			menu.Position = UDim2.new(menu.Position.X.Scale + speed,menu.Position.X.Offset,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	else
		while menu.Position.X.Scale > -2.7 do
			menu.Position = UDim2.new(menu.Position.X.Scale - speed,menu.Position.X.Offset,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	end
	moving = false
end)