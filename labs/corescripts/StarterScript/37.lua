-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Created by Ben T. 10/29/10
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user
local scriptContext = game:GetService("ScriptContext")

-- library registration
scriptContext:AddCoreScript(60595695, scriptContext,"/Libraries/LibraryRegistration/LibraryRegistration")

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

-- Responsible for tracking logging items
local scriptContext = game:GetService("ScriptContext")
scriptContext:AddCoreScript(59002209, scriptContext, "CoreScripts/Sections")

waitForChild(game:GetService("CoreGui"),"RobloxGui")
local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")

-- ToolTipper  (creates tool tips for gui)
scriptContext:AddCoreScript(36868950,screenGui,"CoreScripts/ToolTip")

-- SettingsScript 
scriptContext:AddCoreScript(46295863,screenGui,"CoreScripts/Settings")

-- MainBotChatScript
scriptContext:AddCoreScript(39250920,screenGui,"CoreScripts/MainBotChatScript")

if game.CoreGui.Version >= 2 then
	-- New Player List
	scriptContext:AddCoreScript(48488235,screenGui,"CoreScripts/PlayerListScript")
	-- Popup Script
	scriptContext:AddCoreScript(48488451,screenGui,"CoreScripts/PopupScript")
	-- Friend Notification Script (probably can use this script to expand out to other notifications)
	scriptContext:AddCoreScript(48488398,screenGui,"CoreScripts/NotificationScript")
end

-- For Deepak Testing
pcall(function()
	waitForProperty(game,"PlaceId")
	if game.PlaceId == deepakTestingPlace then
		scriptContext:AddCoreScript(52177626,screenGui,"CoreScripts/RBXStatusBuffsGUIScript")
		scriptContext:AddCoreScript(52177590,screenGui,"CoreScripts/HealthScript v4.0")
	end
end)

if game.CoreGui.Version >= 3 then	
	-- Backpack Builder
	scriptContext:AddCoreScript(53878047,screenGui,"CoreScripts/BackpackScripts/BackpackBuilder")
	-- todo: gross, waitforchilds should be in backpackscript
	waitForChild(screenGui,"CurrentLoadout")
	waitForChild(screenGui.CurrentLoadout,"TempSlot")
	waitForChild(screenGui.CurrentLoadout.TempSlot,"SlotNumber")
	-- Backpack Script
	scriptContext:AddCoreScript(53878057,screenGui.CurrentLoadout,"CoreScripts/BackpackScripts/LoadoutScript")
end