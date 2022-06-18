local button = script.Parent
local activated = false
local menu = script.Parent:FindFirstChild("MaterialMenu")
local frame= script.Parent.Parent.Parent
while menu == nil do
	menu = script.Parent:FindFirstChild("MaterialMenu")
	wait()
end


function keepInWindow()

	if activated and menu.AbsolutePosition.X < 0 then
		local pos = math.abs(menu.AbsolutePosition.x - frame.AbsolutePosition.X)/math.abs(menu.AbsolutePosition.x)
		menu.Position = UDim2.new(pos,0,menu.Position.Y.Scale,menu.Position.Y.Offset)
	end

end



local moving = false
local speed = 0.35
button.Changed:connect(function(property)

	if property == "AbsolutePosition" then keepInWindow() end

	if property ~= "Selected" then return end
	if moving then return end

	moving = true
	activated = button.Selected
	if activated then
		while menu.Position.X.Scale < 1.4 do
			menu.Position = UDim2.new(menu.Position.X.Scale + speed,0,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	else
		while menu.Position.X.Scale > -4 do
			menu.Position = UDim2.new(menu.Position.X.Scale - speed,0,menu.Position.Y.Scale,menu.Position.Y.Offset)
			wait()
		end
	end

	moving = false
end)
