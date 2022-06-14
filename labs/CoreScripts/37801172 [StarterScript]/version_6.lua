-- Creates all neccessary scripts for the gui
-- Created by Ben T. 10/29/10

local screenGui = game:GetService("CoreGui"):GetChildren()[1]
print("starter script screen gui = " .. tostring(screenGui))
local scriptContext = game:GetService("ScriptContext")

-- Resizer
scriptContext:AddCoreScript(35914620,screenGui)

-- SubMenuBuilder
scriptContext:AddCoreScript(35914081,screenGui)

-- ToolTipper
scriptContext:AddCoreScript(36868950,screenGui)

-- PaintMenuMover
scriptContext:AddCoreScript(36040464,screenGui.BuildTools.Frame.PropertyTools.PaintTool)
-- MaterialMenuMover
scriptContext:AddCoreScript(36040495,screenGui.BuildTools.Frame.PropertyTools.MaterialSelector)
-- InputMenuMover
scriptContext:AddCoreScript(36040483,screenGui.BuildTools.Frame.PropertyTools.InputSelector)
												


script:remove()
