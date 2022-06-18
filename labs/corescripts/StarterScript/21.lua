-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Created by Ben T. 10/29/10
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user

pcall(function()
  local sc = game:GetService("ScriptContext")
  sc:RegisterLibrary("RbxGui", "45284430")
  sc:RegisterLibrary("RbxGear", "45374389")
  sc:LibraryRegistrationComplete()
end)

function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

waitForChild(game:GetService("CoreGui"),"RobloxGui")
local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")

local scriptContext = game:GetService("ScriptContext")

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
