-- Creates all neccessary scripts for the gui on initial load
-- Created by Ben T. 10/29/10

local screenGui = game:GetService("CoreGui"):FindFirstChild("ScreenGui")
local scriptContext = game:GetService("ScriptContext")

-- Resizer (dynamically resizes gui)
scriptContext:AddCoreScript(35914620,screenGui)

-- SubMenuBuilder (builds out the material,surface and color panels)
scriptContext:AddCoreScript(35914081,screenGui)

-- ToolTipper  (creates tool tips for gui)
scriptContext:AddCoreScript(36868950,screenGui)

-- (controls the movement and selection of sub panels)
-- PaintMenuMover
scriptContext:AddCoreScript(36040464,screenGui.BuildTools.Frame.PropertyTools.PaintTool)
-- MaterialMenuMover
scriptContext:AddCoreScript(36040495,screenGui.BuildTools.Frame.PropertyTools.MaterialSelector)
-- InputMenuMover
scriptContext:AddCoreScript(36040483,screenGui.BuildTools.Frame.PropertyTools.InputSelector)

game.Players.PlayerAdded:connect(function(player)

	if player == game.Players.LocalPlayer then

		local playerName = Instance.new("StringValue")
		playerName.Name = "PlayerName"
		playerName.Value = player.Name
		playerName.Parent = screenGui
		
		scriptContext:AddCoreScript(36051740,screenGui)
		
	end

end)	