-- Script Globals

local buildDeleteID = 0
local buildStamperID = 0
local buildConfigID = 0
local buildRotateID = 0
local buildWiringID = 0
-- Deprecated Tools
local classicToolID = 0

local isGametest = false
local url = game:GetService("ContentProvider").BaseUrl
url = string.lower(url)
isGametest = string.find(url,"gametest")

if not isGametest then
	buildDeleteID = 36738185
	buildStamperID = 55028088
	buildConfigID = 55027987
	buildRotateID = 58880579
	buildWiringID = 60791062
	classicToolID = 58921588
else
	buildDeleteID = 36738185
	buildStamperID = 87198196
	buildConfigID = 87240571
	buildRotateID = 87335365
	buildWiringID = 87350937
	classicToolID = 87342174
end


local buildTools = {}
local currentTools = {}

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
while tryCount < 20 and game.Players.LocalPlayer.Name == "Player" and game.Players.LocalPlayer.userId == 0 do
	wait(0.3)
	tryCount = tryCount + 1
end

if game.Players.LocalPlayer.Name == "Player" and game.Players.LocalPlayer.userId == 0 then
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
	
	print("elapsed time is",tick() - startTick)
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
	
	giveAssetId(buildStamperID)
	giveAssetId(buildDeleteID)
	giveAssetId(buildRotateID)
	giveAssetId(buildWiringID)
	giveAssetId(buildConfigID)
	
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
local worked = waitForCharacterLoad() --TODO: remove worked once this in client on prod
if not worked then
	print("old school")
	wait(5)
else
	print("new school")
end
givePlayerBuildTools()

-- If player dies, we make sure to give them build tools again
player.CharacterAdded:connect(function()
	takePlayerBuildTools()
	givePlayerBuildTools()
end)

showBuildToolsTutorial()
