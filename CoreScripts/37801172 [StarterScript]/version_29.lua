-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Created by Ben T. 10/29/10
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user

local deepakTestingPlace = 3569749

pcall(function()
  local sc = game:GetService("ScriptContext")
  sc:RegisterLibrary("RbxGui", "45284430")
  sc:RegisterLibrary("RbxGear", "45374389")
  if game.PlaceId == deepakTestingPlace then
	sc:RegisterLibrary("RbxStatus", "52177566")
  end
  sc:LibraryRegistrationComplete()
end)

local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end
local function waitForProperty(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end

print("starter script")

-- Responsible for tracking logging items
local scriptContext = game:GetService("ScriptContext")
scriptContext:AddCoreScript(59002209, scriptContext, "Sections")

local backpackTestPlaces = {41324860,87241143,1818,65033,25415,14403,33913,21783593,17467963,3271,16184658}

waitForChild(game:GetService("CoreGui"),"RobloxGui")
local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")

-- Resizer (dynamically resizes gui)
scriptContext:AddCoreScript(35914620,screenGui,"Resizer")

-- SubMenuBuilder (builds out the material,surface and color panels)
scriptContext:AddCoreScript(35914081,screenGui,"SubMenuBuilder")

-- ToolTipper  (creates tool tips for gui)
scriptContext:AddCoreScript(36868950,screenGui,"ToolTipper")

if game.CoreGui.Version < 2 then
	-- (controls the movement and selection of sub panels)
	-- PaintMenuMover
	scriptContext:AddCoreScript(36040464,screenGui.BuildTools.Frame.PropertyTools.PaintTool,"PaintMenuMover")
	-- MaterialMenuMover
	scriptContext:AddCoreScript(36040495,screenGui.BuildTools.Frame.PropertyTools.MaterialSelector,"MaterialMenuMover")
	-- InputMenuMover
	scriptContext:AddCoreScript(36040483,screenGui.BuildTools.Frame.PropertyTools.InputSelector,"InputMenuMover")
end

-- SettingsScript 
scriptContext:AddCoreScript(46295863,screenGui,"SettingsScript")

-- MainBotChatScript
scriptContext:AddCoreScript(39250920,screenGui,"MainBotChatScript")

if game.CoreGui.Version >= 2 then
	-- New Player List
	scriptContext:AddCoreScript(48488235,screenGui,"PlayerListScript")
	-- Popup Script
	scriptContext:AddCoreScript(48488451,screenGui,"PopupScript")
	-- Friend Notification Script (probably can use this script to expand out to other notifications)
	scriptContext:AddCoreScript(48488398,screenGui,"NotificationScript")
end

-- For Deepak Testing
pcall(function()
	waitForProperty(game,"PlaceId")
	if game.PlaceId == deepakTestingPlace then
		scriptContext:AddCoreScript(52177626,screenGui,"RBXStatusBuffsGUIScript")
		scriptContext:AddCoreScript(52177590,screenGui,"HealthScript v4.0")
	end
end)

if game.CoreGui.Version >= 3 then
	waitForProperty(game,"PlaceId")
	local inRightPlace = false
	for i,v in ipairs(backpackTestPlaces) do
		if v == game.PlaceId then
			inRightPlace = true
			break
		end
	end
	
	waitForChild(game,"Players")
	waitForProperty(game.Players,"LocalPlayer")
	if game.Players.LocalPlayer.userId == 7210880 or game.Players.LocalPlayer.userId == 0 then inRightPlace = true end
	
	--if not inRightPlace then return end -- restricting availability of backpack
	
	-- Backpack Builder
	scriptContext:AddCoreScript(53878047,screenGui,"BackpackBuilder")
	waitForChild(screenGui,"CurrentLoadout")
	waitForChild(screenGui.CurrentLoadout,"TempSlot")
	waitForChild(screenGui.CurrentLoadout.TempSlot,"SlotNumber")
	-- Backpack Script
	scriptContext:AddCoreScript(53878057,screenGui.CurrentLoadout,"BackpackScript")
end