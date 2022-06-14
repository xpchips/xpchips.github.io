-- creates the in-game gui sub menus for property tools
-- written 9/27/2010 by Ben (jeditkacheff)

local gui = script.Parent
local currentlySelectedButton = nil

local selectedButton = Instance.new("ObjectValue")
selectedButton.Name = "SelectedButton"
selectedButton.Parent = gui.BuildTools

local closeButton = Instance.new("ImageButton")
closeButton.BackgroundTransparency = 1
closeButton.Image = "http://www.roblox.com/asset/?id=36874388"
closeButton.Size = UDim2.new(0.2,0,0.05,0)
closeButton.Position = UDim2.new(0.75,0,0.01,0)
closeButton.MouseEnter:connect(function()
	button.Image = "http://www.roblox.com/asset/?id=36874774"
end)
closeButton.MouseLeave:connect(function()
	button.Image = "http://www.roblox.com/asset/?id=36874388"
end)

function setUpCloseButtonState(button)

	button.MouseEnter:connect(function()
		button.Image = "http://www.roblox.com/asset/?id=36874774"
	end)
	button.MouseLeave:connect(function()
		button.Image = "http://www.roblox.com/asset/?id=36874388"
	end)		

end

-- nice selection animation
function fadeInButton(button)

	if currentlySelectedButton ~= nil then
		currentlySelectedButton.Selected = false
		currentlySelectedButton.Frame.BackgroundTransparency = 1
	end

	local speed = 0.1
	while button.Frame.BackgroundTransparency > 0 do
		button.Frame.BackgroundTransparency = button.Frame.BackgroundTransparency - speed
		wait()
	end
	button.Selected = true

	currentlySelectedButton = button
	selectedButton.Value = currentlySelectedButton
end

------------------------------- create the color selection sub menu -----------------------------------

local paintMenu = Instance.new("ImageLabel")
paintMenu.Name = "PaintMenu"
paintMenu.Parent = gui.BuildTools.Frame.PropertyTools.PaintTool
paintMenu.Position = UDim2.new(-2.7,0,0,0)
paintMenu.Size = UDim2.new(2.5,0,10,0)
paintMenu.BackgroundTransparency = 1
paintMenu.Image = "http://www.roblox.com/asset/?id=35885545"

local paintCloseButton = closeButton:clone()
setUpCloseButtonState(paintCloseButton)
paintCloseButton.Parent = paintMenu

local paintColorButton = Instance.new("ImageButton")
paintColorButton.BorderSizePixel = 0
paintColorButton.ZIndex = 2
paintColorButton.Size = UDim2.new(0.200000003, 0,0.0500000007, 0)

local selection = Instance.new("Frame")
selection.BorderSizePixel = 0
selection.BackgroundColor3 = Color3.new(1,1,1)
selection.BackgroundTransparency = 1
selection.Size = UDim2.new(1.1,0,1.1,0)
selection.Position = UDim2.new(-0.05,0,-0.05,0)
selection.Parent = paintColorButton

local header =  0.08
local spacing = 18

local count = 1

function findNextColor()
	colorName = tostring(BrickColor.new(count))
	while colorName == "Medium stone grey" do
		count = count + 1
		colorName = tostring(BrickColor.new(count))
	end
	return count
end

for i = 0,15 do
	for j = 1, 4 do
		newButton = paintColorButton:clone()
		newButton.BackgroundColor3 = BrickColor.new(findNextColor()).Color
		newButton.Name = tostring(BrickColor.new(count))
		count = count + 1
		if j == 1 then newButton.Position = UDim2.new(0.08,0,i/spacing + header,0)
		elseif j == 2 then newButton.Position = UDim2.new(0.29,0,i/spacing + header,0) 
		elseif j == 3 then newButton.Position = UDim2.new(0.5,0,i/spacing + header,0)
		elseif j == 4 then newButton.Position = UDim2.new(0.71,0,i/spacing + header,0) end
		newButton.Parent = paintMenu
	end
end

local paintButtons = paintMenu:GetChildren()
for i = 1, #paintButtons do
	paintButtons[i].MouseButton1Click:connect(function()
		fadeInButton(paintButtons[i])
	end)
end


------------------------------- create the material selection sub menu -----------------------------------

local materialMenu = Instance.new("ImageLabel")
materialMenu.Name = "MaterialMenu"
materialMenu.Position = UDim2.new(-4,0,0,0)
materialMenu.Size = UDim2.new(2.5,0,6.5,0)
materialMenu.BackgroundTransparency = 1
materialMenu.Image = "http://www.roblox.com/asset/?id=35895757"
materialMenu.Parent = gui.BuildTools.Frame.PropertyTools.MaterialSelector

local materialCloseButton = closeButton:clone()
materialCloseButton.Size = UDim2.new(0.25,0,0.05,0)
setUpCloseButtonState(materialCloseButton)
materialCloseButton.Parent = materialMenu

local textures = {"16169981","16169971","16169975","16169978","16169985","16169988","16169991","16169998","16170001"}
local names = {"Plastic", "Wood", "Slate", "Corroded Metal", "Ice", "Grass", "Foil", "Diamond Plate", "Concrete"}

local materialButtons = {}

local materialButton = Instance.new("ImageButton")
materialButton.BackgroundTransparency = 1
materialButton.Size = UDim2.new(0.400000003, 0,0.16, 0)
materialButton.ZIndex = 2

selection.Parent = materialButton

local current = 1
function getTextureAndName(button)

	if current > #names then
		button:remove()
		return false
	end
	button.Image = "http://www.roblox.com/asset/?id=" .. textures[current]
	button.Name = names[current]
	current = current + 1
	return true

end

local ySpacing = 0.10
local xSpacing  = 0.07
for i = 1,5 do
	for j = 1,2 do
		local button = materialButton:clone()
		button.Position = UDim2.new((j -1)/2.2 + xSpacing,0,ySpacing + (i - 1)/5.5,0)
		if getTextureAndName(button) then button.Parent = materialMenu else button:remove() end
		table.insert(materialButtons,button)
	end
end


for i = 1, #materialButtons do
	materialButtons[i].MouseButton1Click:connect(function()
		fadeInButton(materialButtons[i])
	end)
end


------------------------------- create the surface selection sub menu -----------------------------------

local surfaceMenu = Instance.new("ImageLabel")
surfaceMenu.Name = "SurfaceMenu"
surfaceMenu.Position = UDim2.new(-2.6,0,0,0)
surfaceMenu.Size = UDim2.new(2.5,0,5,0)
surfaceMenu.BackgroundTransparency = 1
surfaceMenu.Image = "http://www.roblox.com/asset/?id=35913241"
surfaceMenu.Parent = gui.BuildTools.Frame.PropertyTools.InputSelector

textures = {"16171076","16171077","16171066","16171136","16171062","16171080","16171065","16171070"}
names = {"Smooth", "Studs", "Inlets", "Universal", "Glue", "Weld", "Hinge", "Motor"}
current = 1

local surfaceButtons = {}

local surfaceButton = Instance.new("ImageButton")
surfaceButton.BackgroundTransparency = 1
surfaceButton.Size = UDim2.new(0.400000003, 0,0.2, 0)
surfaceButton.ZIndex = 2

selection.Parent = surfaceButton

local ySpacing = 0.12
local xSpacing  = 0.07
for i = 1,4 do
	for j = 1,2 do
		local button = surfaceButton:clone()
		button.Position = UDim2.new((j -1)/2.2 + xSpacing,0,ySpacing + (i - 1)/4.6,0)
		getTextureAndName(button)
		button.Parent = surfaceMenu
		table.insert(surfaceButtons,button)
	end
end

for i = 1, #surfaceButtons do
	surfaceButtons[i].MouseButton1Click:connect(function()
		fadeInButton(surfaceButtons[i])
	end)
end