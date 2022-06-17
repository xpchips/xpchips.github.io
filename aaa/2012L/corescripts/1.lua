%1%
-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Created by Ben T. 10/29/10
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user
local scriptContext = game:GetService("ScriptContext")
local touchEnabled = false
pcall(function() touchEnabled = game:GetService("UserInputService").TouchEnabled end)

-- library registration
scriptContext:AddCoreScript(2, scriptContext,"/Libraries/LibraryRegistration/LibraryRegistration")

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
scriptContext:AddCoreScript(7, scriptContext, "CoreScripts/Sections")

waitForChild(game:GetService("CoreGui"),"RobloxGui")
local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")

if not touchEnabled then
	-- ToolTipper  (creates tool tips for gui)
	scriptContext:AddCoreScript(8,screenGui,"CoreScripts/ToolTip")
	-- SettingsScript 
	scriptContext:AddCoreScript(9,screenGui,"CoreScripts/Settings")
end

-- MainBotChatScript
scriptContext:AddCoreScript(10,screenGui,"CoreScripts/MainBotChatScript")
-- New Player List
scriptContext:AddCoreScript(11,screenGui,"CoreScripts/PlayerListScript")
-- Popup Script
scriptContext:AddCoreScript(12,screenGui,"CoreScripts/PopupScript")
-- Friend Notification Script (probably can use this script to expand out to other notifications)
scriptContext:AddCoreScript(13,screenGui,"CoreScripts/NotificationScript")
-- Chat script
scriptContext:AddCoreScript(14, screenGui, "CoreScripts/ChatScript")


if game.CoreGui.Version >= 3 then
	-- Backpack Builder, creates most of the backpack gui
	scriptContext:AddCoreScript(15,screenGui,"CoreScripts/BackpackScripts/BackpackBuilder")

	waitForChild(screenGui,"CurrentLoadout")
	waitForChild(screenGui,"Backpack")
	local Backpack = screenGui.Backpack
	
	-- Manager handles all big backpack state changes, other scripts subscribe to this and do things accordingly
	if game.CoreGui.Version >= 7 then
		scriptContext:AddCoreScript(16,Backpack,"CoreScripts/BackpackScripts/BackpackManager")
	end
	
	-- Backpack Gear (handles all backpack gear tab stuff)
	game:GetService("ScriptContext"):AddCoreScript(17,Backpack,"CoreScripts/BackpackScripts/BackpackGear")
	-- Loadout Script, used for gear hotkeys
	scriptContext:AddCoreScript(18,screenGui.CurrentLoadout,"CoreScripts/BackpackScripts/LoadoutScript")
	if game.CoreGui.Version >= 8 then
		-- Wardrobe script handles all character dressing operations
		scriptContext:AddCoreScript(-1,Backpack,"CoreScripts/BackpackScripts/BackpackWardrobe")
	end
end

if touchEnabled then -- touch devices don't use same control frame
	waitForChild(screenGui, 'ControlFrame')
	waitForChild(screenGui.ControlFrame, 'BottomLeftControl')
	screenGui.ControlFrame.BottomLeftControl.Visible = false 
end 