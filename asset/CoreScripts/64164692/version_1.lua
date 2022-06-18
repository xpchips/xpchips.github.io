-- first, lets see if buildTools have already been created
-- create the object in lighting (TODO: move to some sort of "container" object when we have one)
local toolsArray = game.Lighting:FindFirstChild("BuildToolsModel")
local hasBuildTools = false

if not toolsArray then -- no one has made build tools yet, we get to!
	local buildToolIds = {}
	local baseUrl = string.lower(game:GetService("ContentProvider").BaseUrl)
	if string.find(baseUrl,"gametest") then
		table.insert(buildToolIds,36738185)
		table.insert(buildToolIds,87198196)
		table.insert(buildToolIds,87240571)
		table.insert(buildToolIds,87335365)
		table.insert(buildToolIds,87350937)
		table.insert(buildToolIds,87342174)
	elseif string.find(baseUrl,"sitetest") then
		table.insert(buildToolIds,36738185)
		table.insert(buildToolIds,55028088)
		table.insert(buildToolIds,55027987)
		table.insert(buildToolIds,58880579)
		table.insert(buildToolIds,60791062)
		table.insert(buildToolIds,58921588)
	else -- we are on prod
		table.insert(buildToolIds,36738185)
		table.insert(buildToolIds,55028088)
		table.insert(buildToolIds,55027987)
		table.insert(buildToolIds,58880579)
		table.insert(buildToolIds,60791062)
		table.insert(buildToolIds,58921588)
	end

	-- next, create array of our tools
	local buildTools = {}

	for i = 1, #buildToolIds do
		local model = game:GetService("InsertService"):LoadAsset(buildToolIds[i])
		if model then
			local children = model:GetChildren()
			for i = 1, #children do
				if children[i]:IsA("Tool") then
					table.insert(buildTools,children[i])
				end
			end
		end
	end
	
	local buildToolsModel = Instance.new("Model")
	buildToolsModel.Archivable = false
	buildToolsModel.Name = "BuildToolsModel"
	
	for i = 1, #buildTools do
		buildTools[i].Parent = buildToolsModel
	end
	
	if not game.Lighting:FindFirstChild("BuildToolsModel") then -- no one beat us to it, we get to insert
		buildToolsModel.Parent = game.Lighting
	end
	
	toolsArray = game.Lighting:FindFirstChild("BuildToolsModel")
end

local localBuildTools = {}

function giveBuildTools()
	if not hasBuildTools then
		hasBuildTools = true
		local theTools = toolsArray:GetChildren()
		for i = 1, #theTools do
			local toolClone = theTools[i]:clone()
			if toolClone then
				toolClone.Parent = game.Players.LocalPlayer.Backpack
				table.insert(localBuildTools,toolClone)
			else
				print("Tool failed to clone from",theTools[i])
			end
		end
	end
end

function removeBuildTools()
	if hasBuildTools then
		hasBuildTools = false
		for i = 1, #localBuildTools do
			localBuildTools[i].Parent = nil
		end
		localBuildTools = {}
	end
end

if game.Players.LocalPlayer.HasBuildTools then
	giveBuildTools()
end

local debounce = false
game.Players.LocalPlayer.Changed:connect(function(prop)
	if prop == "HasBuildTools" then
		while debounce do
			wait(0.5)
		end
		
		debounce = true
		
		if game.Players.LocalPlayer.HasBuildTools then
			giveBuildTools()
		else
			removeBuildTools()
		end
		
		debounce = false
	end
end)

game.Players.LocalPlayer.CharacterAdded:connect(function()
	hasBuildTools = false
	if game.Players.LocalPlayer.HasBuildTools then
		giveBuildTools()
	end 
end)