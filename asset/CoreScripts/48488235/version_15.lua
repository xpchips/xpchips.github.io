local RbxGui

local localTesting = true

local screen = script.Parent
local screenResizeCon = nil

local friendWord = "Friend"
local friendWordLowercase = "friend"

local testFriendingPlaces = {}
testFriendingPlaces[41324860] = true
local enableFriendingGlobally = false

local testPlayerListPlaces = {}
testPlayerListPlaces[41324860] = true
testPlayerListPlaces[10042455] = true
local enablePlayerListGlobally = true

local bigEasingStyle = Enum.EasingStyle.Back
local smallEasingStyle = Enum.EasingStyle.Quart
local lightBackground = true

local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

local function waitForProperty(instance, prop)
	while not instance[prop] do
		instance.Changed:wait()
	end
end

local function Color3I(r,g,b)
  return Color3.new(r/255,g/255,b/255)
end

function robloxLock(instance)
  instance.RobloxLocked = true
  children = instance:GetChildren()
  if children then
	 for i, child in ipairs(children) do
		robloxLock(child)
	 end
  end
end

function ArrayRemove(t, obj)
	for i, obj2 in ipairs(t) do
		if obj == obj2 then
			table.remove(t, i)
			return true
		end
	end
	return false
end

local function getPlayers()
	local result = {}
   local players = game:GetService("Players"):GetChildren()
	if players then
		for i, player in ipairs(players) do
			if player:IsA("Player") then 
				table.insert(result, player)
			end
		end
	end
	return result
end

local brickColorTable = {}
for i = 0, 63 do
   brickColorTable[BrickColor.palette(i).Name] = BrickColor.palette(i).Color
end

local function remapColor(i, j)
  brickColorTable[BrickColor.palette(i).Name] = BrickColor.palette(j).Color
end

remapColor(13, 12)
remapColor(14, 12)
remapColor(15, 12)
remapColor(61, 29)
remapColor(63, 62)
remapColor(56, 50)
remapColor(45, 53)
remapColor(51, 20)
remapColor(4, 20)
remapColor(59, 35)
remapColor(60, 29)

local function getColor(brickColor)
  if brickColorTable[brickColor.Name] then
	return brickColorTable[brickColor.Name] 
  else
    return brickColor.Color;
  end
end



local function getTeams()
	local result = {}
	local teams = game:GetService("Teams"):GetChildren()
	for i, team in ipairs(teams) do
		if team:IsA("Team") then 
			table.insert(result, team)
		end
	end
	return result	
end

local supportFriends = true
local currentBoardType = "PlayerList"
local currentStatCount = 0

local createBoardsFunction = nil


local playerTable = {}
local teamTable = {}
local teamColorTable	= {}

local removePlayerFunction = nil
local recreatePlayerFunction = nil
local addPlayerFunction = function(player)
	if recreatePlayerFunction then
		recreatePlayerFunction(player)
	end
end
local sortPlayerListsFunction = nil

local minimizedState = nil
local bigWindowImposter = nil
local smallWindowPosition = UDim2.new(0, -20, 0,5)
local smallWindowSize = UDim2.new(1,0,1,0)
local bigWindowSize = UDim2.new(0.6,0,0.6,0) 
local bigWindowPosition = UDim2.new(.2, 0, .2,0)

local smallWindowHeaderYSize = 32

local debounceTeamsChanged = false

local currentWindowState = "Small"
local previousWindowState = nil
local transitionWindowsFunction = nil

local container = nil
local topRightTrayContainer = nil

local playerContextMenu = nil
local contextMenuElements = {}

local function addContextMenuLabel(getText1, getText2, isVisible)
	local t = {}
	t.Type = "Label"
	t.GetText1 = getText1
	t.GetText2 = getText2
	t.IsVisible = isVisible
	table.insert(contextMenuElements, t)
end
local function addContextMenuButton(text, isVisible, isActive, doIt)
	local t = {}
	t.Text = text
	t.Type = "Button"
	t.IsVisible = isVisible
	t.IsActive = isActive
	t.DoIt = doIt
	table.insert(contextMenuElements, t)
end

local function getFriendStatus(player)
	if player == game.Players.LocalPlayer then
		return Enum.FriendStatus.NotFriend
	else
		local success, result = pcall(function() return game.Players.LocalPlayer:GetFriendStatus(player) end)
		if success then
			return result
		else
			return Enum.FriendStatus.NotFriend
		end
	end
end
--Populate the ContextMenus
addContextMenuLabel(
	--GetText1
	function(player) 
		return "Loading..."
	end,
	--GetText2
	nil,
	--IsVisible
	function(player) 
		return getFriendStatus(player) == Enum.FriendStatus.Unknown
	end)

addContextMenuButton("Send " .. friendWord .. " Request", 
	--IsVisible
	function(player) 
		return getFriendStatus(player) == Enum.FriendStatus.NotFriend
	end, 
	--IsActive
	function(player) 
		return true 
	end, 
	--DoIt
	function(player) 
		return game.Players.LocalPlayer:RequestFriendship(player)
	end
)
addContextMenuButton("Un" .. friendWordLowercase, 
	--IsVisible
	function(player) 
		return getFriendStatus(player) == Enum.FriendStatus.Friend
	end, 
	--IsActive
	function(player) 
		return true 
	end, 
	--DoIt
	function(player) 
		return game.Players.LocalPlayer:RevokeFriendship(player)
	end
)
addContextMenuButton("Accept " .. friendWord .. " Request", 
	--IsVisible
	function(player) 
		return getFriendStatus(player) == Enum.FriendStatus.FriendRequestReceived
	end, 
	--IsActive
	function(player) 
		return true 
	end, 
	--DoIt
	function(player)
		return game.Players.LocalPlayer:RequestFriendship(player)
	end
)

addContextMenuButton("Deny " .. friendWord .. " Request", 
	--IsVisible
	function(player) 
		return getFriendStatus(player) == Enum.FriendStatus.FriendRequestReceived
	end, 
	--IsActive
	function(player) 
		return true 
	end, 
	--DoIt
	function(player) 
		return game.Players.LocalPlayer:RevokeFriendship(player)
	end
)

addContextMenuButton("Cancel " .. friendWord .. " Request", 
	--IsVisible
	function(player) 
		return getFriendStatus(player) == Enum.FriendStatus.FriendRequestSent
	end, 
	--IsActive
	function(player) 
		return true 
	end, 
	--DoIt
	function(player) 
		return game.Players.LocalPlayer:RevokeFriendship(player)
	end
)


local function getStatColumns(players)
	for i, player in ipairs(players) do
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local stats = {} 
			local children = leaderstats:GetChildren()
			if children then
				for i, stat in ipairs(children) do
					if stat:IsA("IntValue") then
						table.insert(stats, stat.Name)
					else
						--TODO: This should check for IntValue only but current ScoreHud does not
						table.insert(stats, stat.Name)
					end
				end
			end
			return stats
		end		
	end
	return nil
end

local function determineBoardType()
	local players = getPlayers()
	
	local foundLeaderstats = false
	local numStats = 0
	local foundTeam = false

	local stats = getStatColumns(players)
	if stats then
		foundLeaderstats = true
		numStats = #stats
	end

	for i, player in ipairs(players) do
		if not foundTeam then
			if not player.Neutral then
				foundTeam = true
				break
			end
		end
	end
	
	if foundLeaderstats and foundTeam then
		return "TeamScore", numStats
	elseif foundLeaderstats then
		return "PlayerScore", numStats
	elseif foundTeam then
		return "TeamList", numStats
	else
		return "PlayerList", numStats
	end
end

local function toggleBigWindow()
	if container == nil then
		return
	end

	if currentWindowState == "Big" then
		--Hide it
		if previousWindowState == nil or previousWindowState == "Big" or previousWindowState == "None" then
			transitionWindowsFunction("None")
		else
			transitionWindowsFunction("Small")
		end
	else
		previousWindowState = currentWindowState
		transitionWindowsFunction("Big")
	end
end
local previousBigPlayerList = nil
local function rebuildBoard(owner, boardType, numStats)
	if topRightTrayContainer == nil then
		topRightTrayContainer = owner:FindFirstChild("PlayerListTopRightFrame")
		if topRightTrayContainer == nil then
			topRightTrayContainer = Instance.new("Frame")
			topRightTrayContainer.Name = "PlayerListTopRightFrame"
			topRightTrayContainer.BackgroundTransparency = 1
			topRightTrayContainer.Size = UDim2.new(0.2, 16, 0.42, 16)
			topRightTrayContainer.Position = UDim2.new(0.8, 0, 0, 0)
			topRightTrayContainer.Parent = container
		end
	end
	if minimizedState == nil then
		minimizedState = Instance.new("Frame")
		minimizedState.Name = "MinimizedPlayerlist"
		minimizedState.BackgroundTransparency = 1
		minimizedState.Position = UDim2.new(1, -166, 0,0)
		minimizedState.Size = UDim2.new(0, 151, 0, 30)
		
		playerListButton = Instance.new("ImageButton")
		playerListButton.Name = "GoSmallButton"
		playerListButton.Image = "rbxasset://textures/ui/playerlist_hidden_small.png"
		playerListButton.BackgroundTransparency = 1
		playerListButton.Size = UDim2.new(0.0, 35, 0, 30)
		playerListButton.Position = UDim2.new(1, -35, 0, 0)
		playerListButton.MouseButton1Click:connect(
			function()
				transitionWindowsFunction("Small")
			end)
		playerListButton.Parent = minimizedState

		minimizedState.Visible = false
		robloxLock(minimizedState)
		minimizedState.Parent = topRightTrayContainer
	end
	if bigWindowImposter == nil then
		bigWindowImposter = owner:FindFirstChild("BigPlayerListWindowImposter")
		if bigWindowImposter == nil then
			bigWindowImposter = Instance.new("Frame")
			bigWindowImposter.Name = "BigPlayerListWindowImposter"
			bigWindowImposter.Visible = false
			bigWindowImposter.BackgroundColor3 = Color3.new(0,0,0)
			bigWindowImposter.BackgroundTransparency = 0.7
			bigWindowImposter.BorderSizePixel = 0
			bigWindowImposter.Size = UDim2.new(0.4, 7, 0.4, 7)
			bigWindowImposter.Position = UDim2.new(0.3, 0, 0.3, 0)
			robloxLock(bigWindowImposter)
			bigWindowImposter.Parent = container
		end
	end
	if container == nil or container ~= owner then
		container = owner

		topRightTrayContainer.Parent = container
		bigWindowImposter.Parent = container
	end

	local smallVisible = true
	local bigVisible = false
	if container then
		if topRightTrayContainer then
			--Delete the old boards
			if topRightTrayContainer:FindFirstChild("SmallPlayerlist") then
				smallVisible = topRightTrayContainer.SmallPlayerlist.Visible
				topRightTrayContainer.SmallPlayerlist.Parent = nil
			end
		end
		if container:FindFirstChild("BigPlayerlist") then
			bigVisible = container.BigPlayerlist.Visible or (previousBigPlayerList ~= nil)
			container.BigPlayerlist.Parent = nil
			if previousBigPlayerList ~= nil then
				pcall(function() game.GuiService:RemoveCenterDialog(previousBigPlayerList) end)
				previousBigPlayerList = nil
			end
		end
	end

	local smallBoard, bigBoard = createBoardsFunction(boardType, numStats)
	if smallBoard then
		smallBoard.Visible = smallVisible
		smallBoard.Parent = topRightTrayContainer
		recalculateSmallPlayerListSize(smallBoard)
	end
	if bigBoard then
		if bigVisible then
			previousBigPlayerList = bigBoard
			local centerDialogSupported, msg = pcall(function() game.GuiService:AddCenterDialog(previousBigPlayerList, Enum.CenterDialogType.PlayerInitiatedDialog, 
				function()
					previousBigPlayerList.Visible = true
				end)
			end)
			bigBoard.Visible = bigVisible
		else
			bigBoard.Visible = false
		end
		bigBoard.Parent = container
	end
	return container
end

function recalculateSmallPlayerListSize(smallPlayerList)
	-- reset playerlist size so we get accurate resizing
	smallPlayerList.Size = UDim2.new(smallPlayerList.Size.X.Scale,smallPlayerList.Size.X.Offset,smallPlayerList.Size.Y.Scale,0)
	wait()
	
	waitForChild(smallPlayerList,"ScrollingArea")
	waitForChild(smallPlayerList.ScrollingArea, "ScrollingFrame")
	local scrollingFrame = smallPlayerList.ScrollingArea.ScrollingFrame
	local playerLines = scrollingFrame:GetChildren()

	local totalPlayerListSize = 0
	for i = 1, #playerLines do
		totalPlayerListSize = totalPlayerListSize + playerLines[i].AbsoluteSize.Y
	end

	local yOffset = math.max(0,smallPlayerList.AbsoluteSize.Y - totalPlayerListSize - smallWindowHeaderYSize)
	smallPlayerList.Size = UDim2.new(smallPlayerList.Size.X.Scale,smallPlayerList.Size.X.Offset,smallPlayerList.Size.Y.Scale,-yOffset)
end


local function showBigPlayerWindow()
	if container:FindFirstChild("BigPlayerlist") then
		if container.BigPlayerlist.Visible then
			return
		end
	end
	
	bigWindowImposter.Visible = true
	bigWindowImposter:TweenSizeAndPosition(bigWindowSize, bigWindowPosition, Enum.EasingDirection.Out, bigEasingStyle, 0.3, true,
		function(state)
			if state == Enum.TweenStatus.Completed then 
				bigWindowImposter.Visible = false 
				if container:FindFirstChild("BigPlayerlist") then
					container.BigPlayerlist.Visible = true
				end		
			end
		end)
end

local function hideBigPlayerWindow(completed)
	if playerContextMenu then
		playerContextMenu.Visible = false
	end
	
	if container:FindFirstChild("BigPlayerlist") then
		if container.BigPlayerlist.Visible == false and bigWindowImposter.Visible == false then
			if completed then
				completed()
			end
			--Already completely hidden
			return
		end
		container.BigPlayerlist.Visible = false
	end

	local completedFunction = completed
	bigWindowImposter.Visible = true
	bigWindowImposter:TweenSizeAndPosition(UDim2.new(0.4, 0, 0.4, 0), UDim2.new(0.3, 0, 0.3, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.15, true,
		function(state) 
			if state == Enum.TweenStatus.Completed then 
				bigWindowImposter.Visible = false 
				if completedFunction then
					completedFunction()
				end
			end
		end)
end
local function hideSmallPlayerWindow(completed)
	if playerContextMenu then
		playerContextMenu.Visible = false
	end
	if topRightTrayContainer:FindFirstChild("SmallPlayerlist") then
		local completedFunction = completed
		if topRightTrayContainer.SmallPlayerlist.Visible then
			topRightTrayContainer.SmallPlayerlist:TweenPosition(UDim2.new(1,0,smallWindowPosition.Y.Scale, smallWindowPosition.Y.Offset), Enum.EasingDirection.Out, smallEasingStyle, 0.3, true, 
				function(state) 
					if state == Enum.TweenStatus.Completed then 
						if topRightTrayContainer:FindFirstChild("SmallPlayerlist") then
							topRightTrayContainer.SmallPlayerlist.Visible = false
						end
						if completedFunction then
							completedFunction()
						end
					end
				end)
			return
		end
	end
	if completed then
		completed()
	end
end


transitionWindowsFunction = function(desiredState)
	if desiredState == "Big" then
		minimizedState.Visible = false
		hideSmallPlayerWindow()
	
		if previousBigPlayerList ~= nil then
			if previousBigPlayerList ~= container:FindFirstChild("BigPlayerlist") then
				pcall(function() game.GuiService:RemoveCenterDialog(previousBigPlayerList) end)
				previousBigPlayerList = nil
				previousBigPlayerList = container:FindFirstChild("BigPlayerlist")
			end
		else
			previousBigPlayerList = container:FindFirstChild("BigPlayerlist")
		end

		if previousBigPlayerList then
			local firstShow = false
			local centerDialogSupported, msg = pcall(function() game.GuiService:AddCenterDialog(previousBigPlayerList, Enum.CenterDialogType.PlayerInitiatedDialog, 
				function()
					if not firstShow then
						showBigPlayerWindow()
						firstShow = true
					else
						previousBigPlayerList.Visible = true
					end
				end)
			end)
			if centerDialogSupported == false then
				print("Exception", msg)
				showBigPlayerWindow()
			end
		else
			showBigPlayerWindow()
		end
		currentWindowState = "Big"
	elseif desiredState == "Small" then
		minimizedState.Visible = false
		if previousBigPlayerList ~= nil then
			pcall(function() game.GuiService:RemoveCenterDialog(previousBigPlayerList) end)
			previousBigPlayerList = nil
		end
		
		hideBigPlayerWindow()
		if topRightTrayContainer:FindFirstChild("SmallPlayerlist") then
			if not topRightTrayContainer.SmallPlayerlist.Visible or topRightTrayContainer.SmallPlayerlist.Position ~= smallWindowPosition then
				topRightTrayContainer.SmallPlayerlist.Visible = true
				topRightTrayContainer.SmallPlayerlist:TweenPosition(smallWindowPosition, Enum.EasingDirection.Out, smallEasingStyle, 0.3, true)
			end
		end
		currentWindowState = "Small"
	elseif desiredState == "None" then
		if previousBigPlayerList ~= nil then
			pcall(function() game.GuiService:RemoveCenterDialog(previousBigPlayerList) end)
			previousBigPlayerList = nil
		end
		
		local smallDone = false
		local bigDone = false
		hideSmallPlayerWindow(
			function() 
				smallDone = true 
				if bigDone and smallDone then
					minimizedState.Visible = true
				end
			end)
		hideBigPlayerWindow(			
			function() 
				bigDone = true 
				if bigDone and smallDone then
					minimizedState.Visible = true
				end
			end)		
		currentWindowState = "None"
	end
end

local function getStatValuesForPlayer(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local children = leaderstats:GetChildren()
		if children then
			local result = {}
			--Just go based on position
			for i, stat in ipairs(children) do
				if stat:IsA("IntValue") then
					table.insert(result, stat)
				else 
					table.insert(result, 0)
				end
			end

			return result, leaderstats
		end
	end
	return nil
end

--ChildAdded on Player (if it's name is "leaderstats")

if UserSettings and LoadLibrary then

	RbxGui,msg = LoadLibrary("RbxGui")

	local function createTeamName(name, color)
		local fontHeight = 20
		local frame = Instance.new("Frame")
		frame.Name = "Team-" .. name
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 0.5
		frame.BackgroundColor3 = Color3.new(1,1,1)
		frame.Size = UDim2.new(1, 0, 0, fontHeight)
		frame.Position = UDim2.new(0,0,0,0)

		local label = Instance.new("TextLabel")
		label.Name = "NameLabel"
		label.Text = " " .. name
		label.Font = Enum.Font.ArialBold
		label.FontSize = Enum.FontSize.Size18
		label.Position = UDim2.new(0,0,0,0)
		label.Size = UDim2.new(1,0,1,0)
		label.TextColor3 = Color3.new(1,1,1)
		label.BackgroundTransparency = 0.5
		label.BackgroundColor3 = getColor(color)
		label.BorderSizePixel = 0
		label.TextXAlignment = Enum.TextXAlignment.Left
		label = RbxGui.AutoTruncateTextObject(label)
		label.Parent = frame
		
		return frame
	end

	local function getFriendStatusIcon(friendStatus)
		if friendStatus == Enum.FriendStatus.Unknown or friendStatus == Enum.FriendStatus.NotFriend then
			return nil
		elseif friendStatus == Enum.FriendStatus.Friend then
			return "rbxasset://textures/ui/PlayerlistFriendIcon.png"
		elseif friendStatus == Enum.FriendStatus.FriendRequestSent then
			return "rbxasset://textures/ui/PlayerlistFriendRequestSentIcon.png"
		elseif friendStatus == Enum.FriendStatus.FriendRequestReceived then
			return "rbxasset://textures/ui/PlayerlistFriendRequestReceivedIcon.png"
		else
			error("Unknown FriendStatus: " .. friendStatus)
		end
	end

	local function getMembershipTypeIcon(membershipType)
		if membershipType == Enum.MembershipType.None then
			return ""
		elseif membershipType == Enum.MembershipType.BuildersClub then
			return "rbxasset://textures/ui/TinyBcIcon.png"
		elseif membershipType == Enum.MembershipType.TurboBuildersClub then
			return "rbxasset://textures/ui/TinyTbcIcon.png"
		elseif membershipType == Enum.MembershipType.OutrageousBuildersClub then
			return "rbxasset://textures/ui/TinyObcIcon.png"
		else
			error("Uknown membershipType" .. membershipType)
		end	
	end


	local function updatePlayerFriendStatus(nameObject, friendStatus)
		local fontHeight = 20

		local friendIconImage = getFriendStatusIcon(friendStatus)
		nameObject.MembershipTypeLabel.FriendStatusLabel.Visible = (friendIconImage ~= nil)

		if friendIconImage ~= nil then 
			--Show friend icon
			nameObject.MembershipTypeLabel.FriendStatusLabel.Image = friendIconImage
			nameObject.NameLabel.Position =UDim2.new(0,2*fontHeight,0,1)
			nameObject.NameLabel.Size = UDim2.new(1,-2*fontHeight,1,-2)
		else
			--Hide the friend icon
			nameObject.NameLabel.Position = UDim2.new(0,fontHeight+1,0,1)
			nameObject.NameLabel.Size = UDim2.new(1,-(fontHeight+1),1,-2)
		end
	end
	local function updatePlayerName(nameObject, membershipStatus, teamColor)
		local fontHeight = 20

		nameObject.Size = UDim2.new(1,0,0,fontHeight)
		nameObject.MembershipTypeLabel.Image = getMembershipTypeIcon(membershipStatus)
	end

	
	local function updatePlayerNameColor(player, teamColor)
		local function updatePlayerNameColorHelper(nameObject)
			if teamColor ~= nil then
				nameObject.NameLabel.TextColor3 = getColor(teamColor)
				nameObject.NameLabel.FullNameLabel.TextColor3 = getColor(teamColor)
			else
				nameObject.NameLabel.TextColor3 = Color3.new(1,1,1)
				nameObject.NameLabel.FullNameLabel.TextColor3 = Color3.new(1,1,1)
			end
		end
		
		updatePlayerNameColorHelper(playerTable[player].NameObjectSmall)
		updatePlayerNameColorHelper(playerTable[player].NameObjectBig)
	end


	local function createPlayerName(name, membershipStatus, teamColor, friendStatus)
		local frame = Instance.new("Frame")
		frame.Name = "Player_" .. name
		if lightBackground then
			frame.BackgroundColor3 = Color3.new(1,1,1)
		else
			frame.BackgroundColor3 = Color3.new(1,1,1)
		end
		frame.BackgroundTransparency = 0.5
		frame.BorderSizePixel = 0
		
		local membershipStatusLabel = Instance.new("ImageLabel")
		membershipStatusLabel.Name = "MembershipTypeLabel"
		membershipStatusLabel.BackgroundTransparency = 1
		membershipStatusLabel.Size = UDim2.new(1,0,1,0)
		membershipStatusLabel.Position = UDim2.new(0,0,0,0)
		membershipStatusLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
		membershipStatusLabel.Parent = frame

		local friendStatusLabel = Instance.new("ImageLabel")
		friendStatusLabel.Name = "FriendStatusLabel"
		friendStatusLabel.Visible = false
		friendStatusLabel.BackgroundTransparency = 1
		friendStatusLabel.Size = UDim2.new(1,0,1,0)
		friendStatusLabel.Position = UDim2.new(1,0,0,0)
		friendStatusLabel.Parent = membershipStatusLabel

		local changeNameFunction
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "NameLabel"
		nameLabel.Text = name
		nameLabel.Font = Enum.Font.ArialBold
		nameLabel.FontSize = Enum.FontSize.Size14
		nameLabel.TextColor3 = Color3.new(1,1,1)
		nameLabel.BackgroundTransparency = 1
		nameLabel.BackgroundColor3 = Color3.new(0,0,0)
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel, changeNameFunction = RbxGui.AutoTruncateTextObject(nameLabel)
		nameLabel.Parent = frame
		
		updatePlayerName(frame, membershipStatus, teamColor)
		if supportFriends then
			updatePlayerFriendStatus(frame, friendStatus)
		else
			updatePlayerFriendStatus(frame, Enum.FriendStatus.NotFriend)
		end
		return frame, changeNameFunction
	end

	local function createStatColumn(i, numColumns, isTeam, color3, isHeader)
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Stat" .. i
		textLabel.TextColor3 = Color3.new(1,1,1)
		textLabel.TextXAlignment = Enum.TextXAlignment.Right
		textLabel.TextYAlignment = Enum.TextYAlignment.Center
		textLabel.FontSize = Enum.FontSize.Size14
		if isHeader then
			textLabel.FontSize = Enum.FontSize.Size18
		else
			textLabel.FontSize = Enum.FontSize.Size14
		end
		if isHeader or isTeam then
			textLabel.Font = Enum.Font.ArialBold
		else 
			textLabel.Font = Enum.Font.Arial
		end

		if isTeam then
			textLabel.BackgroundColor3 = color3
			textLabel.Text = 0
		else
			textLabel.BackgroundColor3 = Color3.new(0,0,0)
			textLabel.Text = ""
		end
		textLabel.BackgroundTransparency = 1
		if i == numColumns then
			textLabel.Size = UDim2.new(1/numColumns, -6, 1, 0)
		else
			textLabel.Size = UDim2.new(1/numColumns, -4, 1, 0)
		end
		
		textLabel.Position = UDim2.new((i-1) * (1/numColumns), 0, 0, 0)
		return RbxGui.AutoTruncateTextObject(textLabel)
	end

	local function createStatHeaders(stats, numColumns, isBig)
		local frame = Instance.new("Frame")
		frame.Name = "Headers"
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = Color3.new(0,0,0)
		frame.BackgroundTransparency = 1
		
		local nameSize
		if isBig then
			nameSize = 0.5
		elseif numColumns == 1 then
			nameSize = 0.7
		elseif numColumns == 2 then
			nameSize = 0.6
		else
			nameSize = 0.45
		end
		frame.Size = UDim2.new(1-nameSize, 0, 1,0)
		if isBig then
			frame.Position = UDim2.new(nameSize,-25, 0,0)
		else
			frame.Position = UDim2.new(nameSize,0, 0,0)
		end

		local i = 1
		while i <= numColumns do
			local headerColumn, changeText = createStatColumn(i, numColumns, false, nil, true)
			changeText(stats[i])
			headerColumn.Parent = frame
			i = i + 1
		end		
		return frame, textChangers
	end

	local function createStatColumns(nameObject, numColumns, isTeam, isBig) 
		local frame = Instance.new("Frame")
		frame.Name = nameObject.Name .. "_WithStats"
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = nameObject.BackgroundColor3
		frame.BackgroundTransparency = nameObject.BackgroundTransparency
		frame.Size = nameObject.Size
		frame.Position = nameObject.Position

		nameObject.BackgroundTransparency = 1

		if numColumns == 0 then
			nameObject.Size = UDim2.new(1,0,1,0)
			nameObject.Position = UDim2.new(0,0,0,0)
			nameObject.Parent = frame
			return frame
		end

		local statFrame = Instance.new("Frame")
		statFrame.Name = "Stats"
		if isTeam then
			statFrame.BorderSizePixel = 0
			statFrame.BackgroundColor3 = nameObject.NameLabel.BackgroundColor3
			statFrame.BackgroundTransparency = nameObject.NameLabel.BackgroundTransparency
		else
			statFrame.BackgroundTransparency = 1
		end
		
		local nameSize
		if isBig then
			nameSize = 0.5
		elseif numColumns == 1 then
			nameSize = 0.7
		elseif numColumns == 2 then
			nameSize = 0.6
		else
			nameSize = 0.45
		end
		nameObject.Size = UDim2.new(nameSize, 0, 1, 0)
		nameObject.Position = UDim2.new(0, 0, 0, 0)
		statFrame.Size = UDim2.new(1-nameSize,0, 1,0)
		statFrame.Position = UDim2.new(nameSize,0, 0,0)

		nameObject.Parent = frame
		statFrame.Parent = frame
		
		local textChangers = {}
		local i = 1
		while i <= numColumns do
			local statColumn, changeText = createStatColumn(i, numColumns, isTeam, statFrame.BackgroundColor3)
			statColumn.Parent = statFrame
			table.insert(textChangers, changeText)

			i = i + 1
		end		
		
		return frame, statFrame, textChangers
	end

	local function createAlternatingRows(objects)
		for i, line in ipairs(objects) do
			if i % 2 == 0 then
				line.BackgroundTransparency = 1
			else
				line.BackgroundTransparency = 0.95
			end
		end
	end
	local removeFromTeam = nil

	local function clearTableEntry(obj, tableInfo)
		if tableInfo.MainObjectSmall then
			tableInfo.MainObjectSmall.Parent = nil
			tableInfo.MainObjectSmall = nil
		end
		if tableInfo.MainObjectBig then
			tableInfo.MainObjectBig.Parent = nil
			tableInfo.MainObjectBig = nil
		end
		if tableInfo.Connections then
			for i, connection in ipairs(tableInfo.Connections) do
				connection:disconnect()
			end
			tableInfo.Connections = nil
		end
		if tableInfo.LeaderStatConnections then
			for i, connection in ipairs(tableInfo.LeaderStatConnections) do
				connection:disconnect()
			end
			tableInfo.LeaderStatConnections = nil
		end
		if tableInfo.CurrentTeam then
			removeFromTeam(obj)
			tableInfo.CurrentTeam = nil
		end
		if tableInfo.Players then
			for i, player in ipairs(tableInfo.Players) do
				playerTable[player].CurrentTeam = nil
			end
			tableInfo.Players = {}
		end
		if tableInfo.StatValues then
			tableInfo.StatValues = nil
		end
	end
	
	local function resetPlayerTable()
		for player, info in pairs(playerTable) do
			clearTableEntry(player, info)
			playerTable[player] = nil
		end
		playerTable = {}
	end

	local function resetTeamTable()
		for team, info in pairs(teamTable) do
			clearTableEntry(team, info)
			teamTable[team] = nil
		end
		teamTable = {}
		teamColorTable = {}
	end

	local function getBoardTypeInfo()
		local isTeam  = (currentBoardType == "TeamScore" or currentBoardType == "TeamList")
		local isScore = (currentBoardType == "TeamScore" or currentBoardType == "PlayerScore")
		return isTeam, isScore
	end


	local function recomputeTeamScore(team, column)
		if not team or team == "Neutral" then
			return
		end
		
		local function recomputeScoreHelper(statChangers)
			if statChangers and column <= #statChangers then
				local sum = 0
				for i, p in ipairs(teamTable[team].Players) do
					if playerTable[p].StatValues and column <= #playerTable[p].StatValues then
						sum = sum + playerTable[p].StatValues[column].Value
					end
				end
				statChangers[column](sum)
			end
		end

		recomputeScoreHelper(teamTable[team].StatChangersSmall)
		recomputeScoreHelper(teamTable[team].StatChangersBig)
	end
	local function recomputeCompleteTeamScore(team)
		local col = 1
		while col <= currentStatCount do
			recomputeTeamScore(team, col)
			col = col + 1
		end
	end
	removeFromTeam = function(player)
		if playerTable[player].CurrentTeam ~= nil and teamTable[playerTable[player].CurrentTeam] ~= nil then
			ArrayRemove(teamTable[playerTable[player].CurrentTeam].Players, player)
			recomputeCompleteTeamScore(playerTable[player].CurrentTeam)
			playerTable[player].CurrentTeam = nil
		end
	end

	local function assignToTeam(player)
		local isTeam, isScore = getBoardTypeInfo()

		if isTeam then
			local newTeam = nil

			if player.Neutral or teamColorTable[player.TeamColor.Name] == nil then
				newTeam = "Neutral"
			else
				newTeam = teamColorTable[player.TeamColor.Name] 
			end			

			if playerTable[player].CurrentTeam == newTeam then
				return
			end

			removeFromTeam(player)

			playerTable[player].CurrentTeam = newTeam
			if teamTable[newTeam] then table.insert(teamTable[newTeam].Players, player) end
	
			if newTeam == "Neutral" then
				updatePlayerNameColor(player, nil)
			else
				updatePlayerNameColor(player, player.TeamColor)
			end
			
			recomputeCompleteTeamScore(newTeam)
			
			--Relayout
			if sortPlayerListsFunction then
				sortPlayerListsFunction()
			end
		end
	end
	
	local function buildTeamObject(team, numStatColumns, suffix)
		local isTeam, isScore = getBoardTypeInfo()
		local teamObject = createTeamName(team.Name, team.TeamColor)
		if not teamTable[team] then
			teamTable[team] = {} 
		end
		teamTable[team]["NameObject" .. suffix] = teamObject
		if isScore then
			local statObject
			local textChangers
			teamObject, statObject, textChangers = createStatColumns(teamObject, numStatColumns, true, suffix == "Big")
			teamTable[team]["StatObject" .. suffix] = statObject
			teamTable[team]["StatChangers" .. suffix] = textChangers
		end
		teamTable[team]["MainObject" .. suffix] = teamObject
		if not teamTable[team].Players then
			teamTable[team].Players = {}
		end
		return teamObject
	end
	
	local currentContextMenuPlayer = nil
	local function updatePlayerContextMenu(player)
		currentContextMenuPlayer = player
		local elementHeight = 20
		local function highlight(button)
			button.TextColor3 = Color3.new(0,0,0)
			button.BackgroundColor3 = Color3.new(0.8,0.8,0.8)
		end
		local function clearHighlight(button)
			button.TextColor3 = Color3.new(1,1,1)
			button.BackgroundColor3 = Color3.new(0,0,0)
		end
		if playerContextMenu == nil then
			playerContextMenu = Instance.new("Frame")
			playerContextMenu.Name = "PlayerListContextMenu"
			playerContextMenu.BackgroundTransparency = 1
			playerContextMenu.Visible = false
		
			local playerContextMenuButton = Instance.new("TextButton")
			playerContextMenuButton.Name = "PlayerListContextMenuButton"
			playerContextMenuButton.Text = ""
			playerContextMenuButton.Style = Enum.ButtonStyle.RobloxButtonDefault
			playerContextMenuButton.ZIndex = 4
			playerContextMenuButton.Size = UDim2.new(1, 0, 1, -20)
			playerContextMenuButton.Visible = true
			playerContextMenuButton.Parent = playerContextMenu

			for i, contextElement in ipairs(contextMenuElements) do
				local element = contextElement
				if element.Type == "Button" then
					local button = Instance.new("TextButton")	
					button.Name = "ContextButton" .. i
					button.BackgroundColor3 = Color3.new(0,0,0)
					button.BorderSizePixel = 0
					button.TextXAlignment = Enum.TextXAlignment.Left
					button.Text = " " .. contextElement.Text
					button.Font = Enum.Font.Arial
					button.FontSize = Enum.FontSize.Size14
					button.Size = UDim2.new(1, 8, 0, elementHeight)
					button.TextColor3 = Color3.new(1,1,1)
					button.ZIndex = 4
					button.Parent = playerContextMenuButton
					button.MouseButton1Click:connect(function()
						if button.Active then
							local success, result = pcall(function() element.DoIt(currentContextMenuPlayer) end)
							playerContextMenu.Visible = false
						end
					end)
					
					button.MouseEnter:connect(function()
						if button.Active then
							highlight(button)
						end
					end)
					button.MouseLeave:connect(function()
						if button.Active then
							clearHighlight(button)
						end
					end)
					
					contextElement.Button = button
					contextElement.Element = button
				elseif element.Type == "Label" then
					local frame = Instance.new("Frame")
					frame.Name = "ContextLabel" .. i
					frame.BackgroundTransparency = 1
					frame.Size = UDim2.new(1, 8, 0, elementHeight)
	
					local label = Instance.new("TextLabel")	
					label.Name = "Text1"
					label.BackgroundTransparency = 1
					label.BackgroundColor3 = Color3.new(1,1,1)
					label.BorderSizePixel = 0
					label.TextXAlignment = Enum.TextXAlignment.Left
					label.Font = Enum.Font.ArialBold
					label.FontSize = Enum.FontSize.Size14
					label.Position = UDim2.new(0.0, 0, 0, 0)
					label.Size = UDim2.new(0.5, 0, 1, 0)
					label.TextColor3 = Color3.new(1,1,1)
					label.ZIndex = 4
					label.Parent = frame
					element.Label1 = label
				
					if element.GetText2 then
						label = Instance.new("TextLabel")	
						label.Name = "Text2"
						label.BackgroundTransparency = 1
						label.BackgroundColor3 = Color3.new(1,1,1)
						label.BorderSizePixel = 0
						label.TextXAlignment = Enum.TextXAlignment.Right
						label.Font = Enum.Font.Arial
						label.FontSize = Enum.FontSize.Size14
						label.Position = UDim2.new(0.5, 0, 0, 0)
						label.Size = UDim2.new(0.5, 0, 1, 0)
						label.TextColor3 = Color3.new(1,1,1)
						label.ZIndex = 4
						label.Parent = frame
						element.Label2 = label
					end
					frame.Parent = playerContextMenuButton
					element.Label = frame
					element.Element =  frame
				end
			end

			playerContextMenu.ZIndex = 4
			playerContextMenu.MouseLeave:connect(function() playerContextMenu.Visible = false end)
			robloxLock(playerContextMenu)
			playerContextMenu.Parent = script.Parent
			
		end
		
		local elementPos = 0
		for i, contextElement in ipairs(contextMenuElements) do
			local isVisible = false

			if contextElement.IsVisible then
				local success, visible = pcall(function() return contextElement.IsVisible(currentContextMenuPlayer) end)
				if success then 
					isVisible = visible
				else
					print("Error in IsVisible call: " .. visible)
				end
			end

			if contextElement.Type == "Button" then
				contextElement.Button.Visible = isVisible
				if contextElement.Button.Visible then
					isVisible = true
					clearHighlight(contextElement.Button)
					if contextElement.IsActive then
						local success, active = pcall(function() return contextElement.IsActive(currentContextMenuPlayer) end)
						if success then 
							contextElement.Button.Active = active
						else
							print("Error in IsActive call: " .. active)
						end
					end
					if contextElement.Button.Active then
						contextElement.Button.TextColor3 = Color3.new(1,1,1)
					else
						contextElement.Button.TextColor3 = Color3.new(0.7,0.7,0.7)
					end
				end
			elseif contextElement.Type == "Label" then
				contextElement.Label.Visible = isVisible
				if contextElement.Label.Visible then
					local success, text = pcall(function() return contextElement.GetText1(currentContextMenuPlayer) end)
					if success then
						contextElement.Label1.Text = " " .. text
					else
						print("Error in GetText1 call: " .. text)
					end

					if contextElement.GetText2 then
						local success, text = pcall(function() return contextElement.GetText2(currentContextMenuPlayer) end)
						if success then
							contextElement.Label2.Text = " " .. text
						else
							print("Error in GetText2 call: " .. text)
						end
					end
				end
			end
			if isVisible then
				contextElement.Element.Position = UDim2.new(0,-4, 0, elementPos * elementHeight - 4)
				elementPos = elementPos + 1
			end
		end
		playerContextMenu.Size = UDim2.new(0, 150, 0, elementPos*elementHeight + 13 + 20)
	end
	local function showPlayerMenu(player, x, y)
		updatePlayerContextMenu(player)
		x = x - (playerContextMenu.AbsoluteSize.X/2)
		if x + playerContextMenu.AbsoluteSize.X >= script.Parent.AbsoluteSize.X then
			x = script.Parent.AbsoluteSize.X - playerContextMenu.AbsoluteSize.X
		end
		playerContextMenu.Visible = true
		playerContextMenu.Position = UDim2.new(0, x, 0, y-playerContextMenu.AbsoluteSize.Y)
	end

	local function buildPlayerObject(player, numStatColumns, suffix)
		if not player then return nil end
		
		local isTeam, isScore = getBoardTypeInfo()

		local playerObject = nil
		local changePlayerNameFunction = nil
		local currentColor = nil
		if isTeam and not player.Neutral then
			currentColor = player.TeamColor.Color
		else
			currentColor = Color3.new(1,1,1)
		end
			playerObject, changePlayerNameFunction = createPlayerName(player.Name, player.MembershipType, currentColor, getFriendStatus(player))
		
		if not playerTable[player] then
			playerTable[player] = {}
		end
		if not playerTable[player].Connections then
			playerTable[player].Connections = {}
		end
		if not playerTable[player].CurrentTeam then
			playerTable[player].CurrentTeam = nil
		end
		playerTable[player]["NameObject" .. suffix] = playerObject
		playerTable[player]["ChangeName" .. suffix] = changePlayerNameFunction

		if isScore then
			local statObject = nil
			local textChangers = nil
			playerObject, statObject, textChangers = createStatColumns(playerObject, numStatColumns, false, suffix == "Big")
			playerTable[player]["StatObject" .. suffix]= statObject
			playerTable[player]["StatChangers" .. suffix] = textChangers
			
			local statValues, leaderstats = getStatValuesForPlayer(player)
			if not statValues or #statValues < numStatColumns then
				if not playerTable[player].LeaderStatConnections then
					playerTable[player].LeaderStatConnections = {}
				end
				--Setup a listener to see when this data gets filled in
				if not leaderstats then
					--We don't even have a leaderstats child, wait for one
					table.insert(playerTable[player].LeaderStatConnections, 
						player.ChildAdded:connect(
							function(child)
								if child.Name == "leaderstats" then
									--Connections will be torn down
									recreatePlayerFunction(player)
								else
									table.insert(playerTable[player].LeaderStatConnections, 
										child.Changed:connect(
											function(prop)
												if prop == "Name" and child.Name == "leaderstats" then
													--Connections will be torn down
													recreatePlayerFunction(player)
												end
											end))
								end
							end))
				else
					--We have a leaderstats, but not enough children, recreate if we get them
					table.insert(playerTable[player].LeaderStatConnections, 
						leaderstats.ChildAdded:connect(
							function(child)
								--TODO only look for IntValue
								recreatePlayerFunction(player)
							end)
						)
					table.insert(playerTable[player].LeaderStatConnections, 
						leaderstats.AncestryChanged:connect(
							function(child)
								--We got deleted, try again
								recreatePlayerFunction(player)
							end)
						)
				end
			end
			if statValues then
				if not playerTable[player].StatValues then
					playerTable[player].StatValues = {}
				end
				local pos = 1
				while pos <= numStatColumns and pos <= #statValues do
					local currentColumn = pos
					local statValue = statValues[pos]
					local statChanger = textChangers[pos]

					local updateStat = function(val)
						statChanger(val)
						if playerTable[player] ~= nil then recomputeTeamScore(playerTable[player].CurrentTeam, currentColumn) end
					end
					if pos > #playerTable[player].StatValues then
						table.insert(playerTable[player].StatValues, statValue)
					end

					if type(statValue) ~= "number" and statValue["Changed"] then
						table.insert(playerTable[player].Connections,
							statValue.Changed:connect(updateStat)
						)
					end
					
					table.insert(playerTable[player].Connections,
						statValue.AncestryChanged:connect(
						function()
							recreatePlayerFunction(player)
						end)
					)
					updateStat(statValue.Value)
					pos = pos + 1
				end
			end
		end
		
		if supportFriends and player ~= game.Players.LocalPlayer and player.userId > 0 and  game.Players.LocalPlayer.userId > 0 then
			local button = Instance.new("TextButton")
			button.Name = playerObject.Name .. "Button"
			button.Text = ""
			button.Active = false
			button.Size = playerObject.Size
			button.Position = playerObject.Position
			button.BackgroundColor3 = playerObject.BackgroundColor3
			
			local secondButton = Instance.new("TextButton")
			secondButton.Name = playerObject.Name .. "RealButton"
			secondButton.Text = ""
			secondButton.BackgroundTransparency = 1
			secondButton.BackgroundColor3 = playerObject.BackgroundColor3
			local theNameLabel = playerObject:findFirstChild("NameLabel",true)
			if theNameLabel then
				theNameLabel.TextColor3 = Color3.new(0,0,0)
				secondButton.Parent = theNameLabel.FullNameLabel
			end
			secondButton.Parent.BackgroundTransparency = 1
			secondButton.Parent.Visible = true
			secondButton.ZIndex = 2
			secondButton.Size = UDim2.new(1,0,1,0)

			local previousTransparency = nil
			table.insert(playerTable[player].Connections,
				secondButton.MouseEnter:connect(
					function()
						if previousTransparency == nil then
							previousTransparency = secondButton.BackgroundTransparency
						end

						if lightBackground then
							secondButton.Parent.BackgroundTransparency = 0
						else
							secondButton.Parent.BackgroundTransparency = 1
						end
					end))
			table.insert(playerTable[player].Connections,
				secondButton.MouseLeave:connect(
					function()
						if previousTransparency ~= nil then					
							previousTransparency = nil
						end
						secondButton.Parent.BackgroundTransparency = 1
					end))
			
			local mouseDownX, mouseDownY
			table.insert(playerTable[player].Connections,
				secondButton.MouseButton1Down:connect(function(x,y) 
					mouseDownX = x
					mouseDownY = y
				end))
			table.insert(playerTable[player].Connections,
				secondButton.MouseButton1Click:connect(function() 
					showPlayerMenu(player, mouseDownX, secondButton.AbsolutePosition.Y + secondButton.AbsoluteSize.Y )
				end))
			playerObject.BackgroundTransparency = 1
			playerObject.Size = UDim2.new(1,0,1,0)
			playerObject.Position = UDim2.new(0,0,0,0)
			playerObject.Parent = button
			
			playerTable[player]["MainObject" .. suffix] = button
			
			playerObject = button
		else
			playerTable[player]["MainObject" .. suffix] = playerObject
			
			if player == game.Players.LocalPlayer and supportFriends then
				table.insert(playerTable[player].Connections,
					player.FriendStatusChanged:connect(
					function(otherPlayer, friendStatus)
						if playerTable[otherPlayer] then
							updatePlayerFriendStatus(playerTable[otherPlayer]["NameObject" .. suffix], friendStatus)
						end
					end)
				)
			end
		end
		table.insert(playerTable[player].Connections,
			player.Changed:connect(
				function(prop)
					if prop == "MembershipType" then
						updatePlayerName(playerTable[player]["NameObject" .. suffix], player.MembershipType, currentColor)
					elseif prop == "Name" then
						playerTable[player]["ChangeName" .. suffix](player.Name)
					elseif prop == "Neutral" or prop == "TeamColor" then
						assignToTeam(player)
					end
				end)
			)
		return playerObject
	end

	local function orderScrollList(scrollOrder, objectName, scrollFrame)
		local pos = 0
		local order = {}
		local isTeam, isScore = getBoardTypeInfo()
		for i, obj in ipairs(scrollOrder) do
			order[obj] = 0
		end

		if isTeam then
			local teams = getTeams()
			for i, team in ipairs(teams) do
				if teamTable[team][objectName] then order[teamTable[team][objectName]] = pos end
				pos = pos + 1
				for i, player in ipairs(teamTable[team].Players) do
					if playerTable[player] then
						if playerTable[player][objectName] ~= nil then order[playerTable[player][objectName]] = pos end
						pos = pos + 1
					end
				end
			end
			
			if #teamTable["Neutral"].Players > 0 then
				teamTable["Neutral"][objectName].Parent = scrollFrame
				order[teamTable["Neutral"][objectName]] = pos
				pos = pos + 1
				for i, player in ipairs(teamTable["Neutral"].Players) do
					if playerTable[player][objectName] ~= nil then order[playerTable[player][objectName]] = pos end
					pos = pos + 1
				end
			else
				teamTable["Neutral"][objectName].Parent = nil
			end
		else
			local players = getPlayers()
			for i, player in ipairs(players) do
				if playerTable[player] and playerTable[player][objectName] ~= nil then order[playerTable[player][objectName]] = pos end
				pos = pos + 1
			end	
		end

		table.sort(scrollOrder, 
			function(a,b) 
				return order[a] < order[b] 
			end)
	end
	
	local function createPlayerListBasics(frame, isBig)
		local headerFrame = Instance.new("Frame")
		headerFrame.Name = "Header"
		headerFrame.BackgroundTransparency = 1
		headerFrame.Size = UDim2.new(1,-13,0,26)
		headerFrame.Position = UDim2.new(0,0,0,0)
		headerFrame.Parent = frame

		local lowerPaneFrame = Instance.new("Frame")
		lowerPaneFrame.Name = "ScrollingArea"
		lowerPaneFrame.BackgroundTransparency = 1
		lowerPaneFrame.Size = UDim2.new(1,-3,1,-26)
		if not isBig then lowerPaneFrame.Size = UDim2.new(1,-3,1,-30) end
		lowerPaneFrame.Position = UDim2.new(0,0,0,26)
		lowerPaneFrame.Parent = frame

		local scrollOrder = {}
		local scrollFrame, scrollUp, scrollDown, recalculateScroll = RbxGui.CreateScrollingFrame(scrollOrder)

		local scrollBar = Instance.new("Frame")
		scrollBar.Name = "ScrollBar"
		scrollBar.BackgroundTransparency = 0.9
		scrollBar.BackgroundColor3 = Color3.new(1,1,1)
		scrollBar.BorderSizePixel = 0
		scrollBar.Size = UDim2.new(0, 17, 1, -36)
		if isBig then scrollBar.Size = UDim2.new(0, 17, 1, -61) end
		scrollBar.Parent = lowerPaneFrame

		scrollFrame.Parent = lowerPaneFrame
		scrollUp.Parent = lowerPaneFrame
		scrollDown.Parent = lowerPaneFrame

		if isBig then
			scrollFrame.Position = UDim2.new(0,0,0,0)
			scrollUp.Position = UDim2.new(1,-41,0,5)
			scrollDown.Position = UDim2.new(1,-41,1,-35)
			scrollBar.Position = UDim2.new(1, -41, 0, 24)

			scrollFrame.Size = UDim2.new(1,-48,1,-16)
			headerFrame.Size = UDim2.new(1,-20,0,32)
			
		else
			scrollBar.Position = UDim2.new(1, -15, 0, 14)
			scrollBar.Size = UDim2.new(0,17,1,-36)
			scrollFrame.Position = UDim2.new(0,1,0,0)
			scrollUp.Position = UDim2.new(1,-15,0,-5)
			scrollDown.Position = UDim2.new(1,-15,1,-20)
			
			lowerPaneFrame.Position = UDim2.new(0,0,0,30)

			local toggleScrollBar = function(visible)
				if visible then
					scrollFrame.Size = UDim2.new(1,-16,1,0)
					headerFrame.Size = UDim2.new(1,-16,0,smallWindowHeaderYSize)
				else
					scrollFrame.Size = UDim2.new(1,0,1,0)
					headerFrame.Size = UDim2.new(1,5,0,smallWindowHeaderYSize)
				end
				scrollUp.Visible = visible
				scrollDown.Visible = visible
				scrollBar.Visible = visible
			end
			scrollUp.Changed:connect(function(prop) 
				if prop == "Active" then
					toggleScrollBar(scrollUp.Active or scrollDown.Active)
				end
			end)

			scrollDown.Changed:connect(function(prop) 
				if prop == "Active" then
					toggleScrollBar(scrollUp.Active or scrollDown.Active)
				end
			end)

			toggleScrollBar(scrollUp.Active or scrollDown.Active)
		end
		return headerFrame, scrollFrame, recalculateScroll, scrollOrder
	end
			
	createBoardsFunction = function (boardType, numStatColumns)
		local smallFrame = Instance.new("Frame")
		smallFrame.Name = "SmallPlayerlist"
		smallFrame.Position = smallWindowPosition
		smallFrame.Active = false
		smallFrame.Size = smallWindowSize
		smallFrame.BackgroundColor3 = Color3.new(0,0,0)
		smallFrame.BackgroundTransparency = 0.7
		smallFrame.BorderSizePixel = 0

		local bigFrame = Instance.new("Frame")
		bigFrame.Name = "BigPlayerlist"
		bigFrame.Size = bigWindowSize
		bigFrame.Position = bigWindowPosition
		bigFrame.BackgroundColor3 = Color3.new(0,0,0)
		bigFrame.BackgroundTransparency = 0.7
		bigFrame.BorderSizePixel = 0
		bigFrame.Visible = false		
		
		local bigFrameWrapper = Instance.new("Frame")
		bigFrameWrapper.Name = "Expander"
		bigFrameWrapper.Size = UDim2.new(1,21,1,16)
		bigFrameWrapper.Position = UDim2.new(0, 0, 0,0)
		bigFrameWrapper.BackgroundTransparency = 1
		bigFrameWrapper.Parent = bigFrame

		local smallHeaderFrame, scrollFrameSmall, recalculateScrollSmall, scrollOrderSmall = createPlayerListBasics(smallFrame, false)
		local bigHeaderFrame, scrollFrameBig, recalculateScrollBig, scrollOrderBig = createPlayerListBasics(bigFrameWrapper, true)
		
		local playerListButton = Instance.new("ImageButton")
		playerListButton.Name = "GoBigButton"
		playerListButton.BackgroundTransparency = 1
		playerListButton.Image = "rbxasset://textures/ui/playerlist_small_maximize.png"
		playerListButton.Size = UDim2.new(0.0, 35, 0, 29)
		playerListButton.Position = UDim2.new(0, 0, 0, 0)
		playerListButton.MouseButton1Click:connect(
			function()
				toggleBigWindow()
			end)
		playerListButton.Parent = smallHeaderFrame

		playerListButton = Instance.new("ImageButton")
		playerListButton.Name = "CloseButton"
		playerListButton.BackgroundTransparency = 1
		playerListButton.Image = "rbxasset://textures/ui/playerlist_small_hide.png"
		playerListButton.Size = UDim2.new(0.0, 38, 0, 29)
		playerListButton.Position = UDim2.new(0, 35, 0, 0)
		playerListButton.MouseButton1Click:connect(
			function()
				transitionWindowsFunction("None")
			end)
		playerListButton.Parent = smallHeaderFrame

		playerListButton = Instance.new("ImageButton")
		playerListButton.Name = "CloseButton"
		playerListButton.Image = "rbxasset://textures/ui/playerlist_big_hide.png"
		playerListButton.BackgroundTransparency = 1
		playerListButton.Size = UDim2.new(0.0, 29, 0, 29)
		playerListButton.Position = UDim2.new(1, -30, 0.5, -15)
		playerListButton.MouseButton1Click:connect(
			function()
				toggleBigWindow()
			end)
		playerListButton.Parent = bigHeaderFrame

		local placeName = Instance.new("TextLabel")
		placeName.Name = "PlaceName"
		placeName.Text = " Player List"
		placeName.FontSize = Enum.FontSize.Size24
		placeName.TextXAlignment = Enum.TextXAlignment.Left
		placeName.Font = Enum.Font.ArialBold
		placeName.BackgroundTransparency = 1
		placeName.TextColor3 = Color3.new(1,1,1)
		placeName.Size = UDim2.new(0.5, 0, 1, 0)
		placeName.Position = UDim2.new(0, 0, 0.0, 0)
		placeName = RbxGui.AutoTruncateTextObject(placeName)
		placeName.Parent = bigHeaderFrame
		

		currentBoardType = boardType
		currentStatCount = numStatColumns
		local isTeam, isScore = getBoardTypeInfo()
		local players = getPlayers()
		
		if isScore then
			local statColumns = getStatColumns(players)
			numStatColumns = #statColumns
			if numStatColumns > 3 then
				numStatColumns = 3
			end
			createStatHeaders(statColumns, numStatColumns, false).Parent = smallHeaderFrame
			createStatHeaders(statColumns, currentStatCount, true).Parent = bigHeaderFrame
		end

		--Clean up all old stuff
		resetPlayerTable()

		for i, player in ipairs(players) do
			local playerObject = buildPlayerObject(player, numStatColumns, "Small")
			table.insert(scrollOrderSmall, playerObject)
			playerObject.Parent = scrollFrameSmall

			playerObject = buildPlayerObject(player, currentStatCount, "Big")
			table.insert(scrollOrderBig, playerObject)
			playerObject.Parent = scrollFrameBig
		end

		--Clean up old stuff
		resetTeamTable()

		local teamStatObjects = {}
		if isTeam then
			local teams = getTeams()
			local i = #teams
			while i >= 1 do
				--We go backwards so the "first" team color gets the team
				local team = teams[i]
				teamColorTable[team.TeamColor.Name] = team
				i = i - 1
			end 

			--Adding/Removing a Team causes a full invalidation of the board
			for i, team in ipairs(teams) do
				local teamObject = buildTeamObject(team, numStatColumns, "Small")
				table.insert(scrollOrderSmall, teamObject)
				teamObject.Parent = scrollFrameSmall

				teamObject = buildTeamObject(team, currentStatCount, "Big")
				table.insert(scrollOrderBig, teamObject)
				teamObject.Parent = scrollFrameBig
			end

			teamTable["Neutral"] = {}
			teamTable["Neutral"].Players = {}

			local neutralTeamObject = createTeamName("Neutral", BrickColor.palette(8))
			teamTable["Neutral"].NameObjectSmall = neutralTeamObject
			teamTable["Neutral"].StatObjectSmall = nil
			teamTable["Neutral"].MainObjectSmall = neutralTeamObject
			table.insert(scrollOrderSmall, neutralTeamObject)

			neutralTeamObject = createTeamName("Neutral", BrickColor.palette(8))
			teamTable["Neutral"].NameObjectBig = neutralTeamObject
			teamTable["Neutral"].StatObjectBig = nil
			teamTable["Neutral"].MainObjectBig = neutralTeamObject
			table.insert(scrollOrderBig, neutralTeamObject)

			local neutralPlayers = {}
			for i, player in ipairs(players) do
				assignToTeam(player)
			end
		end

		removePlayerFunction = function(player)
			if playerTable[player] then
				ArrayRemove(scrollOrderSmall, playerTable[player].MainObjectSmall)
				ArrayRemove(scrollOrderBig, playerTable[player].MainObjectBig)

				clearTableEntry(player, playerTable[player])
	
				playerTable[player] = nil
				recalculateSmallPlayerListSize(smallFrame)
			end
		end
		recreatePlayerFunction = function(player)
			removePlayerFunction(player)

			local playerObject = buildPlayerObject(player, numStatColumns, "Small")
			table.insert(scrollOrderSmall, playerObject)
			robloxLock(playerObject)
			playerObject.Parent = scrollFrameSmall

			playerObject = buildPlayerObject(player, currentStatCount, "Big")
			table.insert(scrollOrderBig, playerObject)
			robloxLock(playerObject)
			playerObject.Parent = scrollFrameBig
			
			local isTeam, isScore = getBoardTypeInfo()
			if isTeam then
				assignToTeam(player)
			end

			sortPlayerListsFunction()
			recalculateSmallPlayerListSize(smallFrame)
		end
		
		if screenResizeCon then screenResizeCon:disconnect() end
		screenResizeCon = screen.Changed:connect(
			function(prop)
				if prop == "AbsoluteSize" then
					recalculateSmallPlayerListSize(smallFrame)
				end
			end)

		sortPlayerListsFunction = function()
			orderScrollList(scrollOrderSmall, "MainObjectSmall", scrollFrameSmall)
			recalculateScrollSmall()
			createAlternatingRows(scrollOrderSmall)

			orderScrollList(scrollOrderBig, "MainObjectBig", scrollFrameBig)
			recalculateScrollBig()
			createAlternatingRows(scrollOrderBig)
		end

		sortPlayerListsFunction()

		robloxLock(smallFrame)
		robloxLock(bigFrame)
		return smallFrame, bigFrame
	end

	--Teams changing invalidates the whole board	
	local function teamsChanged()
		if debounceTeamsChanged then 
			return 
		end

		debounceTeamsChanged = true
		wait()
		rebuildBoard(script.Parent, determineBoardType())
		debounceTeamsChanged = false
	end

	
	local checkIfBoardChanged = function()
		local newBoardType, numStats = determineBoardType()
		if newBoardType ~= currentBoardType or numStats ~= currentStatCount then
			rebuildBoard(script.Parent, newBoardType, numStats)
		end
	end

	local function buildPlayerList()
		waitForChild(game, "Players")
		waitForProperty(game.Players, "LocalPlayer")

		local playerListEnabled = testPlayerListPlaces[game.PlaceId] or enablePlayerListGlobally
		if localTesting and (game.PlaceId == 0) or (game.PlaceId == -1) then
			playerListEnabled = true
		end
		if not playerListEnabled then
			--No playerlist
			return
		end
		
		supportFriends = testFriendingPlaces[game.PlaceId] or enableFriendingGlobally
		if localTesting and (game.PlaceId == 0) or (game.PlaceId == -1) then
			supportFriends = true
		end
		
		local teams = game:GetService("Teams")
		if teams then
			local teamConnections = {}

			teams.ChildAdded:connect(
				function(child)
					if child:IsA("Team") then
						teamsChanged()
						teamConnections[child] = child.Changed:connect(
							function(prop)
								if prop == "TeamColor" or prop == "Name" then
									--Rebuild when things change
									teamsChanged()
								end
							end)
					end
				end)
			teams.ChildRemoved:connect(
				function(child)
					if child:IsA("Team") then
						if teamConnections[child] then
							teamConnections[child]:disconnect()
							teamConnections[child] = nil
						end
						teamsChanged()
					end
				end)
		end

		game.Players.ChildAdded:connect(
			function(player)
				if player:IsA("Player") then
					addPlayerFunction(player)
				end
			end)

		game.Players.ChildRemoved:connect(
			function(player)
				if player:IsA("Player") then
					if removePlayerFunction then
						removePlayerFunction(player)
					end
				end
			end)

		rebuildBoard(script.Parent, determineBoardType())
		game.GuiService.ShowLegacyPlayerList = false

		game.GuiService:AddKey("\t")
		local lastTime = nil
		game.GuiService.KeyPressed:connect(
		function(key)
			if key == "\t" then
				local modalCheck, isModal = pcall(function() return game.GuiService.IsModalDialog end)
				if modalCheck == false or (modalCheck and isModal == false) then
					local currentTime = time()
					if lastTime == nil or currentTime - lastTime > 0.4 then
						lastTime = currentTime
						toggleBigWindow()
					end
				end
			end
		end)

		delay(0,
			function()
				while true  do
					wait(5)
					checkIfBoardChanged()
				end
			end)
	end
	
	if game.CoreGui.Version >= 2 then
		buildPlayerList()
	end
end 
