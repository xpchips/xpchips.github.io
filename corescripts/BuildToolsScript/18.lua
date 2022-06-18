-- Script Globals

local buildDeleteID = 36738185
local buildStamperID = 55028088
local buildConfigID = 55027987
local buildRotateID = 58880579
local buildWiringID = 60791062
-- Deprecated Tools
local classicToolID = 58921588

local buildTools = {}
local currentTools = {}

local newDeleteID = 73089190
local newPartSelectionID = 73089166
local newCloneID = 73089204
local newRecentPartID = 73089229
local newRotateID = 73089214
local newConfigID = 73089239
local newWiringID = 73089259

local useNewTools = true -- for separated stamper

local player = nil
local backpack = nil


-- Functions
local function waitForProperty(instance, name)
	while not instance[name] do
		instance.Changed:wait()
	end
end

local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

local tryCount = 0
waitForProperty(game.Players,"LocalPlayer")
local playerNamePos = string.find(game.Players.LocalPlayer.Name,"Player",1)
while tryCount < 3 and playerNamePos == 1 do
	wait(0.3)
	playerNamePos = string.find(game.Players.LocalPlayer.Name,"Player",1)
	tryCount = tryCount + 1
end

if playerNamePos == 1 then
	return
end

-- Start Script=
function getLatestPlayer()
	waitForProperty(game.Players,"LocalPlayer")
	player = game.Players.LocalPlayer
	waitForChild(player,"Backpack")
	backpack = player.Backpack
end

function waitForCharacterLoad()

	local startTick = tick()
	
	local playerLoaded = false
	
	local success = pcall(function() playerLoaded = player.AppearanceDidLoad end) --TODO: remove pcall once this in client on prod
	if not success then return false end
	
	while not playerLoaded do
		player.Changed:wait()
		playerLoaded = player.AppearanceDidLoad
	end
	
	return true
end

function showBuildToolsTutorial()
	local tutorialKey = "BuildToolsTutorial"
	if UserSettings().GameSettings:GetTutorialState(tutorialKey) == true then return end --already have shown tutorial
	
	local RbxGui = LoadLibrary("RbxGui")

	local frame, showTutorial, dismissTutorial, gotoPage = RbxGui.CreateTutorial("Build", tutorialKey, false)
	local firstPage = RbxGui.CreateImageTutorialPage(" ", "http://www.roblox.com/asset/?id=59162193", 359, 296, function() dismissTutorial() end, true)

	RbxGui.AddTutorialPage(frame, firstPage)
	frame.Parent = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
	
	game:GetService("GuiService"):AddCenterDialog(frame, Enum.CenterDialogType.UnsolicitedDialog,
		--showFunction
		function()
			frame.Visible = true
			showTutorial()
		end,
		--hideFunction
		function()
			frame.Visible = false
		end
	) 
	
	wait(1)
	showTutorial()
end

function clearLoadout()
	currentTools = {}

	local backpackChildren = game.Players.LocalPlayer.Backpack:GetChildren()
	for i = 1, #backpackChildren do
		if backpackChildren[i]:IsA("Tool") or backpackChildren[i]:IsA("HopperBin") then
			table.insert(currentTools,backpackChildren[i])
		end
	end
	
	if game.Players.LocalPlayer["Character"] then
		local characterChildren = game.Players.LocalPlayer.Character:GetChildren()
		for i = 1, #characterChildren do
			if characterChildren[i]:IsA("Tool") or characterChildren[i]:IsA("HopperBin") then
				table.insert(currentTools,characterChildren[i])
			end
		end
	end
	
	for i = 1, #currentTools do
		currentTools[i].Parent = nil
	end
end

function giveToolsBack()
	for i = 1, #currentTools do
		currentTools[i].Parent = game.Players.LocalPlayer.Backpack
	end
end

function backpackHasTool(tool)
	local backpackChildren = backpack:GetChildren()
	for i = 1, #backpackChildren do
		if backpackChildren[i] == tool then
			return true
		end
	end
	return false
end

function getToolAssetID(assetID)
	local newTool = game:GetService("InsertService"):LoadAsset(assetID)
	local toolChildren = newTool:GetChildren()
	for i = 1, #toolChildren do
		if toolChildren[i]:IsA("Tool") then
			return toolChildren[i]
		end
	end
	return nil
end

function removeBuildToolTag(tool)
	if tool:FindFirstChild("RobloxBuildTool") then
		local tag = tool.RobloxBuildTool
		tag.Parent = nil
	end
end

function giveAssetId(assetID,toolName)
	local theTool = getToolAssetID(assetID,toolName)
	if theTool and not backpackHasTool(theTool) then
		removeBuildToolTag(theTool)
		theTool.Parent = backpack
		table.insert(buildTools,theTool)
	end
end

function givePlayerBuildTools()
	getLatestPlayer()

	clearLoadout()
	
	if useNewTools then
		giveAssetId(newPartSelectionID)
		giveAssetId(newDeleteID)
		giveAssetId(newCloneID)
		giveAssetId(newRotateID)
		giveAssetId(newRecentPartID)
		giveAssetId(newWiringID)
		giveAssetId(newConfigID)
	else
		giveAssetId(buildStamperID)
		giveAssetId(buildDeleteID)
		giveAssetId(buildRotateID)
		giveAssetId(buildWiringID)
		giveAssetId(buildConfigID)
	end
	
	-- deprecated tools
	giveAssetId(classicToolID)
	
	giveToolsBack()
end

function takePlayerBuildTools()
	for k,v in ipairs(buildTools) do
		v.Parent = nil
	end
	buildTools = {}
end

getLatestPlayer()
waitForCharacterLoad()
givePlayerBuildTools()

-- If player dies, we make sure to give them build tools again
player.CharacterAdded:connect(function()
	takePlayerBuildTools()
	givePlayerBuildTools()
end)

showBuildToolsTutorial()

