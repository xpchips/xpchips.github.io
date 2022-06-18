-- Load up our images so we don't have blinking

local contentProvider = game:GetService("ContentProvider")

local localAssetBase = "rbxasset://textures/ui/"

local bottomLeftControls = script.Parent.BottomLeftControl
local buildTools = script.Parent.BuildTools
local buildToolsVisible = false
--[[if buildTools.Frame.Size.X.Scale > 0.1 then
	buildToolsVisible = true
end]]

bottomLeftControls.ToolButton.Image = localAssetBase .. "ToolButton.png"

local prevObject = nil

local players = game.Players:GetChildren()

local player = players[1].Character--script.Parent.Parent.Parent.Character
local backpack = players[1].Backpack--script.Parent.Parent.Parent.Backpack

local equippedTool = nil

local selectedButton = nil
while buildTools:FindFirstChild("SelectedButton") == nil do
	wait()
end

local value = nil

buildTools.SelectedButton.Changed:connect(function(property)

	if value == buildTools.SelectedButton.Value then return end
	value = buildTools.SelectedButton.Value

	selectedButton = buildTools.SelectedButton.Value

	if equippedTool then
		equippedTool.SelectedButton.Value = selectedButton
	end
end)

local buttons = {}

local frames = buildTools.Frame:GetChildren()
 for i = 1, #frames do
	if frames[i]:IsA("Frame") and frames[i].Name ~= "Divs" then
		local buttonSubSet = frames[i]:GetChildren()
		for j = 1, #buttonSubSet do
			table.insert(buttons,buttonSubSet[j])
		end
	end
end

function unEquipAnyItems()

	playerItems = player:GetChildren()
	for i = 1, #playerItems do
		if playerItems[i]:isA("Tool") or playerItems[i]:isA("HopperBin") then
			playerItems[i].Parent = backpack
			return
		end
	end

end

function setUpText(toolTip)

	local name = toolTip.Parent.Name
	if name == "CloneObject" then toolTip.Text = "Copy Part"
	elseif name == "DeleteObject" then toolTip.Text = "Delete Part"
	elseif name == "InsertObject" then toolTip.Text = "Insert Part"
	elseif name == "PropertyTool" then toolTip.Text = "Edit Part"
	elseif name == "GroupMove" then toolTip.Text = "Move Models and Parts"
	elseif name == "PartMove" then toolTip.Text = "Move Parts"
	elseif name == "ScaleObject" then toolTip.Text = "Resize a part"
	elseif name == "InputSelector" then toolTip.Text = "Change Surface"
	elseif name == "MaterialSelector" then toolTip.Text = "Change Material"
	elseif name == "PaintTool" then toolTip.Text = "Change Color" end

end

local fadeSpeed = 0.1
function buildToolsTips()
	
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
	
	for i = 1, #buttons do
		local tip = frame:Clone()
		tip.Parent = buttons[i]
		setUpText(tip)
		local inside = Instance.new("BoolValue")
		inside.Value = false
		tip.Parent.MouseEnter:connect(function()
			inside.Value = true
			wait(1.2)
			if inside.Value then
				while inside.Value and tip.BackgroundTransparency > 0 do
					tip.BackgroundTransparency = tip.BackgroundTransparency - fadeSpeed
					tip.TextTransparency = tip.TextTransparency - fadeSpeed
					wait()
				end
			end
		end)
		tip.Parent.MouseLeave:connect(function()
			inside.Value = false
			tip.BackgroundTransparency = 1
			tip.TextTransparency = 1
		end)
		tip.Parent.MouseButton1Click:connect(function()
			inside.Value = false
			tip.BackgroundTransparency = 1
			tip.TextTransparency = 1
		end)
	end
end

-- resets all button states
function reset(subset)

	local buttons = subset:GetChildren()
	if subset.Name == "AddDeleteTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "CloneObject" then buttons[i].Image = localAssetBase .. "CloneButton.png"
			elseif buttons[i].Name == "DeleteObject" then buttons[i].Image = localAssetBase .. "DeleteButton.png"
			elseif buttons[i].Name == "InsertObject" then buttons[i].Image = localAssetBase .. "InsertButton.png" end
		end


	elseif subset.Name == "MiscTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "PropertyTool" then buttons[i].Image = localAssetBase .. "PropertyButton.png" end
		end


	elseif subset.Name == "PhysicalTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "GroupMove" then buttons[i].Image = localAssetBase .. "GroupMoveButton.png"
			elseif buttons[i].Name == "PartMove" then buttons[i].Image = localAssetBase .."PartMoveButton.png"
			elseif buttons[i].Name == "ScaleObject" then buttons[i].Image = localAssetBase .. "ScaleButton.png" end
		end


	elseif subset.Name == "PropertyTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "InputSelector" then buttons[i].Image = localAssetBase .. "SurfaceButton.png"
			elseif buttons[i].Name == "MaterialSelector" then buttons[i].Image = localAssetBase .. "MaterialButton.png"
			elseif buttons[i].Name == "PaintTool" then buttons[i].Image = localAssetBase .. "PaintButton.png" end
		end
	end

end

function resetAllButtons()

	local categories = buildTools.Frame:GetChildren()
	for i = 1, #categories do
		reset(categories[i])
	end

end

-- sets button to active image
function setButtonStateActive(Object, Name)

	if Name == "BuildInsert" then Object.Image = localAssetBase .. "InsertButton_dn.png" Object.Selected = true
	elseif Name == "BuildDelete" then Object.Image = localAssetBase .. "DeleteButton_dn.png" Object.Selected = true
	elseif Name == "BuildCloneTest" then Object.Image = localAssetBase .. "CloneButton_dn.png" Object.Selected = true
	elseif Name == "BuildConfiguration" then Object.Image = localAssetBase .. "PropertyButton_dn.png" Object.Selected = true
	elseif Name == "BuildDragger" then Object.Image = localAssetBase .. "PartMoveButton_dn.png" Object.Selected = true
	elseif Name == "BuildGroupDragger" then Object.Image = localAssetBase .. "GroupMoveButton_dn.png" Object.Selected = true
	elseif Name == "BuildResize" then Object.Image = localAssetBase .. "ScaleButton_dn.png" Object.Selected = true
	elseif Name == "BuildSurfaceTest" then Object.Image = localAssetBase .. "SurfaceButton_dn.png" Object.Selected = true
	elseif Name == "BuildMaterialTest" then Object.Image = localAssetBase .. "MaterialButton_dn.png" Object.Selected = true
	elseif Name == "BuildColorTester" then Object.Image = localAssetBase .. "PaintButton_dn.png" Object.Selected = true
	end

end


function removeTool(tool, Object)

	playerItems = player:GetChildren()
	for i = 1, #playerItems do
		if playerItems[i].Name == tool and playerItems[i]:isA("Tool") or playerItems[i]:isA("HopperBin") then
			playerItems[i].Parent = backpack
			playerItems[i]:remove()
			return
		end
	end

	backpackStuff = backpack:GetChildren()
	for i = 1, #backpackStuff do
		if backpackStuff[i].Name == tool and backpackStuff[i]:isA("Tool") or playerItems[i]:isA("HopperBin") then
			backpackStuff[i].Parent = nil
			backpackStuff[i]:remove()
			return
		end
	end

end



function getTool(tool)
	playerItems = player:GetChildren()
	for i = 1, #playerItems do
		if playerItems[i].Name == tool then
			if playerItems[i]:isA("Tool") then return playerItems[i], true end
		end
	end

	backpackStuff = backpack:GetChildren()
	for i = 1, #backpackStuff do
		if backpackStuff[i].Name == tool then
			if backpackStuff[i]:isA("Tool") then return backpackStuff[i], false end
			if backpackStuff[i]:isA("HopperBin") then return backpackStuff[i], true end
		end
	end
end

function toolDeselection(Name,Object,id)

	local hasTool, equipped = getTool(Name)
	if equipped then
		resetAllButtons()
		unEquipAnyItems()
		hasTool.Parent = nil
		hasTool:remove()
		
		if equippedTool then
			equippedTool.Parent = nil
			equippedTool:remove()
			equippedTool = nil
		end
	end
		
	
end

-- general function to get tool when button is clicked
function toolSelection(Name,Object,id)
	local tool = nil
	local hasTool, equipped = getTool(Name)
	if equipped then
		resetAllButtons()
		if hasTool:IsA("HopperBin") then hasTool.Active = false end
		unEquipAnyItems()
		hasTool.Parent = nil
		hasTool:remove()

		if equippedTool then
			equippedTool.Parent = nil
			equippedTool:remove()
			equippedTool = nil
		end

	elseif hasTool then
		unEquipAnyItems()
		Object.Selected = true
		hasTool.Parent = player
		equippedTool = hasTool
		setButtonStateActive(Object, Name)
		if hasTool:IsA("Tool") then
			hasTool.Unequipped:connect(function() resetAllButtons() end)
		else
			hasTool.Deselected:connect(function() resetAllButtons() end)
		end
	else
		--This call will cause a "wait" until the data comes back
		tool = game:GetService("InsertService"):LoadAsset(id)
		local instances = tool:GetChildren()
		if #instances == 0 then
			tool:Remove()
			return nil
		end
		
		tool = tool:FindFirstChild(Name)
		if tool then

			local selected = Instance.new("ObjectValue")
			selected.Name = "SelectedButton"
			selected.Parent = tool

			if Name == "BuildConfiguration" then
				selected.Value = buildTools.Frame.MiscTools.PropertyTool
			elseif Name == "BuildInsert" then
				selected.Value = buildTools.Frame
			end

			unEquipAnyItems()
			if equippedTool ~= nil then
				if prevObject then resetAllButtons() end
				equippedTool:remove()
			end
			tool.Parent = player
			if tool:IsA("HopperBin") then
				tool.Parent = game.Players:GetPlayerFromCharacter(player).Backpack
				tool.Active = true
			end
			equippedTool = tool
			Object.Selected = true
			setButtonStateActive(Object, Name)
			if equippedTool and equippedTool:IsA("Tool") then
				equippedTool.Unequipped:connect(function() resetAllButtons() end)
			elseif equippedTool then
				equippedTool.Deselected:connect(function() resetAllButtons() end)
			end
		end
	end
	prevObject = Object
end

local scrollSpeed = 0.01
function openCloseTools()
	buildToolsVisible = not buildToolsVisible
	if buildToolsVisible then
		bottomLeftControls.ToolButton.Image = localAssetBase .. "ToolButton_dn.png"
		buildTools.Frame.CloseButton.Image = localAssetBase .. "CloseButton.png"
		buildTools.Frame.Size = UDim2.new(0.15,0,0.57,0)
		buildTools.Frame.Position = UDim2.new(-0.1, 0,buildTools.Frame.Position.Y.Scale,0)
		while buildTools.Frame.Position.X.Scale < -0.01 and buildToolsVisible do
			buildTools.Frame.Position = UDim2.new(buildTools.Frame.Position.X.Scale + scrollSpeed, 0,buildTools.Frame.Position.Y.Scale,0)
			wait()
		end
		buildTools.Frame.Position = UDim2.new(0, 0,buildTools.Frame.Position.Y.Scale,0)
	else
		bottomLeftControls.ToolButton.Image = localAssetBase .. "ToolButton.png"
		while buildTools.Frame.AbsolutePosition.X + buildTools.Frame.AbsoluteSize.X  > 0 and not buildToolsVisible do
			buildTools.Frame.Position = UDim2.new(buildTools.Frame.Position.X.Scale - scrollSpeed, 0,buildTools.Frame.Position.Y.Scale,0)
			wait()
		end
		buildTools.Frame.Size = UDim2.new(0,buildTools.Frame.AbsoluteSize.X,buildTools.Frame.Size.Y.Scale,buildTools.Frame.Size.Y.Offset)
		buildTools.Frame.Position = UDim2.new(0,-buildTools.Frame.AbsoluteSize.X,buildTools.Frame.Position.Y.Scale,buildTools.Frame.Position.Y.Offset)
	end
end

-- stuff for tool building
bottomLeftControls.ToolButton.MouseButton1Click:connect(openCloseTools)
bottomLeftControls.ToolButton.MouseEnter:connect(function() if not buildToolsVisible then bottomLeftControls.ToolButton.Image = localAssetBase .. "ToolButton_dn.png" end end)
bottomLeftControls.ToolButton.MouseLeave:connect(function() if not buildToolsVisible then bottomLeftControls.ToolButton.Image = localAssetBase .. "ToolButton.png" end end)

-- close button on build tools
buildTools.Frame.CloseButton.MouseButton1Click:connect(openCloseTools)
buildTools.Frame.CloseButton.MouseEnter:connect(function() buildTools.Frame.CloseButton.Image = localAssetBase .. "CloseButton_dn.png" end)
buildTools.Frame.CloseButton.MouseLeave:connect(function() buildTools.Frame.CloseButton.Image = localAssetBase .. "CloseButton.png" end)


-- set up tool buttons

buildToolsTips()

-- Add/Delete Tools
buildTools.Frame.AddDeleteTools.InsertObject.MouseButton1Click:connect(function() 
toolSelection("BuildInsert",buildTools.Frame.AddDeleteTools.InsertObject,36431591) end)
buildTools.Frame.AddDeleteTools.DeleteObject.MouseButton1Click:connect(function()
toolSelection("BuildDelete", buildTools.Frame.AddDeleteTools.DeleteObject,36738185) end)
buildTools.Frame.AddDeleteTools.CloneObject.MouseButton1Click:connect(function()
toolSelection("BuildCloneTest",buildTools.Frame.AddDeleteTools.CloneObject,36017373) end)

-- Physical Tools
buildTools.Frame.PhysicalTools.ScaleObject.MouseButton1Click:connect(function()
toolSelection("BuildResize",buildTools.Frame.PhysicalTools.ScaleObject,36738142) end)
buildTools.Frame.PhysicalTools.PartMove.MouseButton1Click:connect(function()
toolSelection("BuildDragger",buildTools.Frame.PhysicalTools.PartMove,36068233) end)
buildTools.Frame.PhysicalTools.GroupMove.MouseButton1Click:connect(function()
toolSelection("BuildGroupDragger",buildTools.Frame.PhysicalTools.GroupMove,36334760) end)

-- Property Tools
buildTools.Frame.PropertyTools.MaterialSelector.MouseButton1Click:connect(function()
toolSelection("BuildMaterialTest",buildTools.Frame.PropertyTools.MaterialSelector,35223828) end)
buildTools.Frame.PropertyTools.MaterialSelector.MaterialMenu.CloseButton.ClosedState.Changed:connect(function(value)
	if value == true then
		toolSelection("BuildMaterialTest",buildTools.Frame.PropertyTools.MaterialSelector,35223828)
		buildTools.Frame.PropertyTools.MaterialSelector.MaterialMenu.CloseButton.ClosedState.Value = false
	end
end)
buildTools.Frame.PropertyTools.PaintTool.MouseButton1Click:connect(function()
toolSelection("BuildColorTester",buildTools.Frame.PropertyTools.PaintTool, 35205409) end)
buildTools.Frame.PropertyTools.PaintTool.PaintMenu.CloseButton.ClosedState.Changed:connect(function(value)
	if value == true then
		toolSelection("BuildColorTester",buildTools.Frame.PropertyTools.PaintTool,35205409)
		buildTools.Frame.PropertyTools.PaintTool.PaintMenu.CloseButton.ClosedState.Value = false
	end
end)
buildTools.Frame.PropertyTools.InputSelector.MouseButton1Click:connect(function()
toolSelection("BuildSurfaceTest",buildTools.Frame.PropertyTools.InputSelector,35226945) end)
buildTools.Frame.PropertyTools.InputSelector.SurfaceMenu.CloseButton.ClosedState.Changed:connect(function(value)
	if value == true then
		toolSelection("BuildSurfaceTest",buildTools.Frame.PropertyTools.InputSelector,35226945)
		buildTools.Frame.PropertyTools.InputSelector.SurfaceMenu.CloseButton.ClosedState.Value = false
	end
end)

-- Misc Tools
buildTools.Frame.MiscTools.PropertyTool.MouseButton1Click:connect(function()
toolSelection("BuildConfiguration",buildTools.Frame.MiscTools.PropertyTool,36270159) end)
