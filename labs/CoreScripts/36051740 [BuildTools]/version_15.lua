wait(3)

print("Build tools script loaded")

local bottomLeftControls = script.Parent.BottomLeftControl
local buildTools = script.Parent.BuildTools
local buildToolsVisible = false

local prevObject = nil

local players = game.Players:GetChildren()
for i = 1, #players do
	print(players[i])
end

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

function unEquipAnyItems()

	playerItems = player:GetChildren()
	for i = 1, #playerItems do
		if playerItems[i]:isA("Tool") or playerItems[i]:isA("HopperBin") then
			playerItems[i].Parent = backpack
			return
		end
	end

end


-- resets all button states
function reset(subset)

	local buttons = subset:GetChildren()
	if subset.Name == "AddDeleteTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "CloneObject" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763469"
			elseif buttons[i].Name == "DeleteObject" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763507"
			elseif buttons[i].Name == "InsertObject" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763542" end
		end


	elseif subset.Name == "MiscTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "PropertyTool" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763628" end
		end


	elseif subset.Name == "PhysicalTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "GroupMove" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763745"
			elseif buttons[i].Name == "PartMove" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763762"
			elseif buttons[i].Name == "ScaleObject" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763793" end
		end


	elseif subset.Name == "PropertyTools" then
		for i = 1, #buttons do
			buttons[i].Selected = false
			if buttons[i].Name == "InputSelector" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763945"
			elseif buttons[i].Name == "MaterialSelector" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763907"
			elseif buttons[i].Name == "PaintTool" then buttons[i].Image = "http://www.roblox.com/asset/?id=34763886" end
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

	if Name == "BuildInsert" then Object.Image = "http://www.roblox.com/asset/?id=34849257"
	elseif Name == "BuildDelete" then Object.Image = "http://www.roblox.com/asset/?id=34849301"
	elseif Name == "BuildCloneTest" then Object.Image = "http://www.roblox.com/asset/?id=34849314"
	elseif Name == "BuildConfiguration" then Object.Image = "http://www.roblox.com/asset/?id=34859934"
	elseif Name == "GroupMove" then Object.Image = "http://www.roblox.com/asset/?id=34859955"
	elseif Name == "BuildDragger" then Object.Image = "http://www.roblox.com/asset/?id=34859980"
	elseif Name == "BuildResize" then Object.Image = "http://www.roblox.com/asset/?id=34860007"
	elseif Name == "BuildSurfaceTest" then Object.Image = "http://www.roblox.com/asset/?id=34860057"
	elseif Name == "BuildMaterialTest" then Object.Image = "http://www.roblox.com/asset/?id=34860076"
	elseif Name == "BuildColorTester" then Object.Image = "http://www.roblox.com/asset/?id=34860098"
	end

end

function setButtonStateDeactive(Object, Name)

	if Name == "BuildInsert" then Object.Image = "http://www.roblox.com/asset/?id=34849257" Object.Selected = false
	elseif Name == "BuildDelete" then Object.Image = "http://www.roblox.com/asset/?id=34763507" Object.Selected = false
	elseif Name == "BuildCloneTest" then Object.Image = "http://www.roblox.com/asset/?id=34763469" Object.Selected = false
	elseif Name == "BuildConfiguration" then Object.Image = "http://www.roblox.com/asset/?id=34763628" Object.Selected = false
	elseif Name == "GroupMove" then Object.Image = "http://www.roblox.com/asset/?id=34763745" Object.Selected = false
	elseif Name == "Part Dragger" then Object.Image = "http://www.roblox.com/asset/?id=34763762" Object.Selected = false
	elseif Name == "BuildResize" then Object.Image = "http://www.roblox.com/asset/?id=34763793" Object.Selected = false
	elseif Name == "BuildSurfaceTest" then Object.Image = "http://www.roblox.com/asset/?id=34763945" Object.Selected = false
	elseif Name == "BuildMaterialTest" then Object.Image = "http://www.roblox.com/asset/?id=34763907" Object.Selected = false
	elseif Name == "BuildColorTester" then Object.Image = "http://www.roblox.com/asset/?id=34763886" Object.Selected = false
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
			playerItems[i].Parent = nil
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
			if playerItems[i]:isA("HopperBin") then return playerItems[i], true end
		end
	end
end

-- general function to get tool when button is clicked
function toolSelection(Name,Object,id)
	local tool = nil
	local hasTool, equipped = getTool(Name)
	if equipped then
		Object.Selected = false
		removeTool(hasTool.Name, Object)
		equippedTool:remove()
		equippedTool = nil
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
			end

			unEquipAnyItems()
			if equippedTool then
				if prevObject then setButtonStateDeactive(prevObject,equippedTool.Name) end
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
			if equippedTool:IsA("Tool") then
				equippedTool.Unequipped:connect(function() resetAllButtons() end)
			else
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
		bottomLeftControls.ToolButton.Image = "http://www.roblox.com/asset/?id=34763189"
		buildTools.Frame.CloseButton.Image = "http://www.roblox.com/asset/?id=35162715"
		buildTools.Frame.Size = UDim2.new(0.15,0,0.57,0)
		buildTools.Frame.Position = UDim2.new(-0.1, 0,buildTools.Frame.Position.Y.Scale,0)
		while buildTools.Frame.Position.X.Scale < -0.01 and buildToolsVisible do
			buildTools.Frame.Position = UDim2.new(buildTools.Frame.Position.X.Scale + scrollSpeed, 0,buildTools.Frame.Position.Y.Scale,0)
			wait()
		end
		buildTools.Frame.Position = UDim2.new(0, 0,buildTools.Frame.Position.Y.Scale,0)
	else
		bottomLeftControls.ToolButton.Image = "http://www.roblox.com/asset/?id=34762981"
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
bottomLeftControls.ToolButton.MouseEnter:connect(function() if not buildToolsVisible then bottomLeftControls.ToolButton.Image = "http://www.roblox.com/asset/?id=34763189" end end)
bottomLeftControls.ToolButton.MouseLeave:connect(function() if not buildToolsVisible then bottomLeftControls.ToolButton.Image = "http://www.roblox.com/asset/?id=34762981" end end)

-- close button on build tools
buildTools.Frame.CloseButton.MouseButton1Click:connect(openCloseTools)
buildTools.Frame.CloseButton.MouseEnter:connect(function() buildTools.Frame.CloseButton.Image = "http://www.roblox.com/asset/?id=35163155" end)
buildTools.Frame.CloseButton.MouseLeave:connect(function() buildTools.Frame.CloseButton.Image = "http://www.roblox.com/asset/?id=35162715" end)


-- set up tool buttons

-- Add/Delete Tools
buildTools.Frame.AddDeleteTools.InsertObject.MouseButton1Click:connect(function() 
toolSelection("BuildInsertTester",buildTools.Frame.AddDeleteTools.InsertObject,35268363) end)
buildTools.Frame.AddDeleteTools.DeleteObject.MouseButton1Click:connect(function()
toolSelection("BuildDelete", buildTools.Frame.AddDeleteTools.DeleteObject,16201628) end)
buildTools.Frame.AddDeleteTools.CloneObject.MouseButton1Click:connect(function()
toolSelection("BuildCloneTest",buildTools.Frame.AddDeleteTools.CloneObject,36017373) end)

-- Physical Tools
buildTools.Frame.PhysicalTools.ScaleObject.MouseButton1Click:connect(function()
toolSelection("BuildResize",buildTools.Frame.PhysicalTools.ScaleObject,16969792) end)
buildTools.Frame.PhysicalTools.PartMove.MouseButton1Click:connect(function()
toolSelection("BuildDragger",buildTools.Frame.PhysicalTools.PartMove,36068233) end)

-- Property Tools
buildTools.Frame.PropertyTools.MaterialSelector.MouseButton1Click:connect(function()
toolSelection("BuildMaterialTest",buildTools.Frame.PropertyTools.MaterialSelector,35223828) end)
buildTools.Frame.PropertyTools.PaintTool.MouseButton1Click:connect(function()
toolSelection("BuildColorTester",buildTools.Frame.PropertyTools.PaintTool, 35205409) end)
buildTools.Frame.PropertyTools.InputSelector.MouseButton1Click:connect(function()
toolSelection("BuildSurfaceTest",buildTools.Frame.PropertyTools.InputSelector,35226945) end)

-- Misc Tools
buildTools.Frame.MiscTools.PropertyTool.MouseButton1Click:connect(function()
toolSelection("BuildConfiguration",buildTools.Frame.MiscTools.PropertyTool,36270159) end)
