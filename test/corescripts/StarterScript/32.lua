-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Created by Ben T. 10/29/10
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user

local scriptContext = game:GetService("ScriptContext")

-- library registration
scriptContext:AddStarterScript(91376482)
  
function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

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

-- DialogBoxScripts 
scriptContext:AddCoreScript(91269759,screenGui,"SettingsScript")

-- MainChatScript
scriptContext:AddCoreScript(39250920,screenGui,"MainChatScript")

if game.CoreGui.Version >= 2 then
	scriptContext:AddCoreScript(91275300,screenGui,"PlayerListScript")
	
	-- Popup Script
	scriptContext:AddCoreScript(91275301,screenGui,"PopupScript")

	-- Friend Notification Script (probably can use this script to expand out to other notifications)
	scriptContext:AddCoreScript(91275302,screenGui,"NotificationScript")
end


-- Backpack Builder
scriptContext:AddCoreScript(91376487,screenGui,"BackpackBuilder")
waitForChild(screenGui,"CurrentLoadout")
waitForChild(screenGui.CurrentLoadout,"TempSlot")
waitForChild(screenGui.CurrentLoadout.TempSlot,"SlotNumber")
-- Backpack Script
scriptContext:AddCoreScript(91376488,screenGui.CurrentLoadout,"BackpackScript")