-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Created by Ben T. 10/29/10
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user

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

-- (controls the movement and selection of sub panels)
-- PaintMenuMover
scriptContext:AddCoreScript(36040464,screenGui.BuildTools.Frame.PropertyTools.PaintTool,"PaintMenuMover")
-- MaterialMenuMover
scriptContext:AddCoreScript(36040495,screenGui.BuildTools.Frame.PropertyTools.MaterialSelector,"MaterialMenuMover")
-- InputMenuMover
scriptContext:AddCoreScript(36040483,screenGui.BuildTools.Frame.PropertyTools.InputSelector,"InputMenuMover")

-- Dialog Script
scriptContext:AddCoreScript(39250920,screenGui,"DialogScript")
