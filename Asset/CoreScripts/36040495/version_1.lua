local button = script.Parent
local activated = false
local menu = script.Parent:FindFirstChild("MaterialMenu")
while menu == nil do
	menu = script.Parent:FindFirstChild("MaterialMenu")
	wait()
end

local moving = false
local speed = 0.35
button.Changed:connect(function(property)

	if property ~= "Selected" then return end
	if moving then return end

	moving = true
	activated = button.Selected
	if activated then
		while menu.Position.X.Scale < 1.4 do
			menu.Position = UDim2.new(menu.Position.X.Scale + speed,menu.Position.X.Offset,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	else
		while menu.Position.X.Scale > -4 do
			menu.Position = UDim2.new(menu.Position.X.Scale - speed,menu.Position.X.Offset,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	end

	moving = false
end)