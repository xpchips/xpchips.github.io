-- Creates the generic "ROBLOX" loading screen on startup
-- Written by Ben Tkacheff & ArceusInator, 2014
--
-- Constants
local PLACEID = Game.PlaceId

local MPS = Game:GetService 'MarketplaceService'
local CP = Game:GetService 'ContentProvider'
local RENDERSTEPPED = Game:GetService 'RunService' .RenderStepped

local COLORS = {
	BLACK = Color3.new(0, 0, 0),
	DARK = Color3.new(35/255, 35/255, 38/255),
	DARKMED = Color3.new(61/255, 61/255, 67/255),
	DARKMED2 = Color3.new(75/255, 76/255, 85/255),
	MED = Color3.new(118/255, 118/255, 129/255),
	LIGHTMED = Color3.new(190/255, 192/255, 212/255),
	LIGHT = Color3.new(217/255, 218/255, 231/255)
}

local IMAGES = {
	BACKGROUND_THUMBNAIL_VIGNETTE = 'rbxasset://textures/loading/loadingvignette.png',
	ROBLOX_LOGO_256 = 'rbxasset://textures/loading/robloxlogo.png',
	GAME_THUMBNAIL = 'http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=420&height=230&assetId='..PLACEID,
	GAME_BACKGROUND = 'rbxasset://textures/loading/loadingTexture.png'
}

local VALID_TEXT_SIZES = {
	12,
	14,
	18,
	24,
	36,
	48
}

--
-- Variables
local GameAssetInfo -- loaded by InfoProvider:LoadAssets()
local currScreenGui = nil

--
-- Utility functions
local create = function(className, defaultParent)
	return function(propertyList)
		local object = Instance.new(className)
		
		for index, value in next, propertyList do
			if type(index) == 'string' then
				object[index] = value
			else
				if type(value) == 'function' then
					value(object)
				elseif type(value) == 'userdata' then
					value.Parent = object
				end
			end
		end
		
		if object.Parent == nil then
			object.Parent = defaultParent
		end
		
		return object
	end
end

local renderwait = function()
	RENDERSTEPPED:wait()
end

--
-- Create objects
local MainGui = {}
local InfoProvider = {}

--
-- Declare member functions
function MainGui:GenerateMain()
	local screenGui = create 'ScreenGui' {
		Name = 'RobloxLoadingGui'
	}
	
	--
	-- create descendant frames
	
	local mainBackgroundContainer = create 'Frame' {
		Name = 'MainBackgroundContainer',
		BackgroundColor3 = COLORS.DARK,
		Size = UDim2.new(1, 0, 1, 0),
		
		create 'Frame' {
			Name = 'TopBar',
			BackgroundColor3 = COLORS.DARKMED,
			BorderColor3 = COLORS.MED,
			BorderSizePixel = 3,
			Position = UDim2.new(0, -220, 0, -205),
			Rotation = -10,
			Size = UDim2.new(0, 1000, 0, 220),
			ZIndex = 5,
		
			create 'ImageLabel' {
				Name = 'RobloxLogo',
				BackgroundTransparency = 1,
				Image = IMAGES.ROBLOX_LOGO_256,
				Position = UDim2.new(0, 214, 1, -80),
				Rotation = 2,
				Size = UDim2.new(0, 128, 0, 128),
				ZIndex = 6,
				
				create 'TextLabel' {
					Name = 'PoweredBy',
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, -60, 0, 78),
					Size = UDim2.new(0, 80, 0, 18),
					Font = Enum.Font.SourceSans,
					FontSize = Enum.FontSize.Size18,
					TextColor3 = Color3.new(1,1,1),
					Text = "Powered By",
					ZIndex = 6
				}
			},
		},
		
		create 'Frame' {
			Name = 'BottomBar',
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, -150),
			Size = UDim2.new(1, 0, 0, 300),
			ZIndex = 5,
			
			create 'Frame' {
				Name = 'BottomBarActual',
				BackgroundColor3 = COLORS.DARKMED,
				BorderColor3 = COLORS.MED,
				BorderSizePixel = 3,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 5,
			
				create 'Frame' {
					Name = 'TextContainer',
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -5, 0, 5),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 8,
					
					create 'TextLabel' {
						Name = 'CreatorName',
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0, 70),
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 9,
						Font = Enum.Font.SourceSansBold,
						FontSize = Enum.FontSize.Size48,
						Text = InfoProvider:GetCreatorName(),
						TextColor3 = COLORS.LIGHT,
						TextStrokeColor3 = COLORS.DARKMED2,
						TextStrokeTransparency = 0,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Top
					},
					
					create 'TextLabel' {
						Name = 'GameName',
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 0, 0, 30),
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 9,
						Font = Enum.Font.SourceSansBold,
						FontSize = Enum.FontSize.Size48,
						Text = InfoProvider:GetGameName(),
						TextColor3 = COLORS.LIGHT,
						TextStrokeColor3 = COLORS.DARKMED2,
						TextStrokeTransparency = 0,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Top
					},
					
					create 'TextLabel' {
						Name = 'CreatorNamePrefix',
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 9,
						Font = Enum.Font.SourceSans,
						FontSize = Enum.FontSize.Size48,
						Text = 'By',
						TextColor3 = COLORS.LIGHTMED,
						TextStrokeColor3 = COLORS.DARKMED2,
						TextStrokeTransparency = 0,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Top
					},
					
					create 'TextLabel' {
						Name = 'OnYourWay',
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 9,
						Font = Enum.Font.SourceSans,
						FontSize = Enum.FontSize.Size36,
						Text = 'You\'re on your way to',
						TextColor3 = COLORS.LIGHTMED,
						TextStrokeColor3 = COLORS.DARKMED2,
						TextStrokeTransparency = 0,
						TextXAlignment = Enum.TextXAlignment.Right,
						TextYAlignment = Enum.TextYAlignment.Top
					}
				}
			}
		},
		
		create 'ImageLabel' {
			Name = 'BackgroundThumbnailVignette',
			BackgroundTransparency = 1,
			Image = IMAGES.BACKGROUND_THUMBNAIL_VIGNETTE,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 3
		},
		
		create 'ImageLabel' {
			Name = 'BackgroundThumbnail',
			BackgroundTransparency = 1,
			Image = IMAGES.GAME_BACKGROUND,
			Size = UDim2.new(1.5, 0, 1.5, 0),
			Position = UDim2.new(-0.5,0,0,0),
			ZIndex = 2
		},
		
		Parent = screenGui
	}
	
	local thumbnailContainer = create 'Frame' {
		Name = 'ThumbnailContainer',
		BackgroundColor3 = COLORS.BLACK,
		BorderColor3 = COLORS.MED,
		BorderSizePixel = 4,
		Position = UDim2.new(0.5, -210, 0.5, -115),
		Size = UDim2.new(0, 420, 0, 230),
		ZIndex = 8,
		
		create 'ImageLabel' {
			Name = 'Thumbnail',
			BorderColor3 = COLORS.DARKMED2,
			BorderSizePixel = 3,
			Image = IMAGES.GAME_THUMBNAIL,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 8
		},
		
		Parent = screenGui
	}
	
	--
	-- recalculate everything
	screenGui.Parent = Game.CoreGui.RobloxGui
	MainGui:RecalculateSizes(screenGui)
	
	--
	-- return generated gui
	return screenGui
end

function InfoProvider:GetGameName()
	if GameAssetInfo ~= nil then
		return GameAssetInfo.Name
	else
		return ''
	end
end

function InfoProvider:GetCreatorName()
	if GameAssetInfo ~= nil then
		return GameAssetInfo.Creator.Name
	else
		return ''
	end
end

function InfoProvider:LoadAssets()
	-- load images
	for imageName, imageContent in next, IMAGES do
		CP:Preload(imageContent)
	end
	
	-- load game asset info
	coroutine.resume(coroutine.create(function() GameAssetInfo = MPS:GetProductInfo(PLACEID) end))
end

function MainGui:RecalculateSizes(screenGui)
	local screenSize = screenGui.AbsoluteSize
	
	-- update names
	screenGui.MainBackgroundContainer.BottomBar.BottomBarActual.TextContainer.CreatorName.Text = InfoProvider:GetCreatorName()
	screenGui.MainBackgroundContainer.BottomBar.BottomBarActual.TextContainer.GameName.Text = InfoProvider:GetGameName()
	
	-- recalculate thumbnail size
	local thumbnailSizeScale = math.min(math.max(screenSize.y/630, 50/230), 1)
	local thumbnailSize = UDim2.new(0, thumbnailSizeScale*420, 0, thumbnailSizeScale*230)
	local thumbnailPosition = UDim2.new(0.5, -thumbnailSizeScale*420/2, 0.5, -20 - thumbnailSizeScale*230/2 )
	screenGui.ThumbnailContainer.Size = thumbnailSize
	screenGui.ThumbnailContainer.Position = thumbnailPosition
	
	-- recalculate text size
	local textSizeScale = math.min(screenSize.y/800, 1)
	local closestValidSizePrevIndex = math.floor(textSizeScale*#VALID_TEXT_SIZES)-1
	local closestValidSizePrevIndex2 = closestValidSizePrevIndex-1
	local closestValidTextSize
	local closestValidTextSizePrev
	-- next can't take a 0 because it's a total wuss
	if closestValidSizePrevIndex > 0 then
		_, closestValidTextSize = next(VALID_TEXT_SIZES, closestValidSizePrevIndex)
		if closestValidSizePrevIndex2 > 0 then
			_, closestValidTextSizePrev = next(VALID_TEXT_SIZES, closestValidSizePrevIndex2)
		else
			_, closestValidTextSizePrev = next(VALID_TEXT_SIZES) -- not doing t[1] because this looks cleaner
		end
	else
		_, closestValidTextSize = next(VALID_TEXT_SIZES)
		_, closestValidTextSizePrev = next(VALID_TEXT_SIZES)
	end
	local textSizeEnum = Enum.FontSize['Size'..closestValidTextSize]
	local textSizePrevEnum = Enum.FontSize['Size'..closestValidTextSizePrev]
	local TextContainer = screenGui.MainBackgroundContainer.BottomBar.BottomBarActual.TextContainer
	local currentYBumpDistance = 0
	TextContainer.OnYourWay.FontSize = textSizePrevEnum
	currentYBumpDistance = currentYBumpDistance + closestValidTextSizePrev*(40/48)
	TextContainer.GameName.Position = UDim2.new(0, 0, 0, currentYBumpDistance)
	TextContainer.GameName.FontSize = textSizeEnum
	currentYBumpDistance = currentYBumpDistance + closestValidTextSize*(40/48)
	TextContainer.CreatorName.Position = UDim2.new(0, 0, 0, currentYBumpDistance)
	TextContainer.CreatorName.FontSize = textSizeEnum
	local currentXBumpDistance = -(TextContainer.CreatorName.TextBounds.X+5)
	TextContainer.CreatorNamePrefix.Position = UDim2.new(0, currentXBumpDistance, 0, currentYBumpDistance)
	TextContainer.CreatorNamePrefix.FontSize = textSizeEnum

	-- recalculate bottom bar size
	local sizeScale = closestValidTextSize/48
	screenGui.MainBackgroundContainer.BottomBar.Size = UDim2.new(1, 0, 0, 300 * sizeScale)
	screenGui.MainBackgroundContainer.BottomBar.Position = UDim2.new(0, 0, 1, -150 * sizeScale)
	screenGui.MainBackgroundContainer.BottomBar.BottomBarActual.Position = UDim2.new(0, -130 * sizeScale,0,0)
end

function MainGui:Show()
	currScreenGui = MainGui:GenerateMain()
	currScreenGui.MainBackgroundContainer.Visible = true
	currScreenGui.ThumbnailContainer.Visible = true
	
	currScreenGui.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			MainGui:RecalculateSizes(currScreenGui)
		end
	end)
end



---------------------------------------------------------
-- Main Script (show something now + setup connections)

InfoProvider:LoadAssets()
MainGui:Show()

local forceRemovalTime = 5
local destroyed = false

function removeLoadingScreen()
	if currScreenGui then
		currScreenGui:Destroy()
		currScreenGui = nil
	end
	if script then script:Destroy() end
	destroyed = true
end


function startForceLoadingDoneTimer()
	wait(forceRemovalTime)
	removeLoadingScreen()
end

function gameIsLoaded()
	if Game.ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
		removeLoadingScreen()
	else
		startForceLoadingDoneTimer()
	end
end

Game.ReplicatedFirst.RemoveDefaultLoadingGuiSignal:connect(function()
	removeLoadingScreen()
end)

if Game.ReplicatedFirst:IsDefaultLoadingGuiRemoved() then
	removeLoadingScreen()
	return
end

Game.Loaded:connect(function()
	gameIsLoaded()
end)

if Game:IsLoaded() then
	gameIsLoaded()
end



--------------------------------------------------------------------------
--
-- Animation (make the stuff we are showing look cool)

local blockSize = 10
local blockColor = Color3.new(33/255,66/255,209/255)

local yPosScale = 0
local yPosOffset = -blockSize * 3.5

local tweenStyle = Enum.EasingStyle.Sine
local tweenVelocity = 1500
local tweenTime = (currScreenGui.AbsoluteSize.X/2)/tweenVelocity 

function createBlock()
	local initBlock = Instance.new("Frame")
	initBlock.ZIndex = 5
	initBlock.Size = UDim2.new(0,blockSize,0,blockSize)
	initBlock.BackgroundColor3 = COLORS.DARK
	initBlock.BorderSizePixel = 0
	initBlock.Position = UDim2.new(0,-blockSize,yPosScale,yPosOffset)
	initBlock.Parent = currScreenGui.MainBackgroundContainer.BottomBar
	
	return initBlock
end


local blocks = {}
for i = 1,6 do
	blocks[i] = createBlock()
end

function getYOffset(newSize)
	return yPosOffset - (newSize/3)
end

function rightScreenExit()
	wait(tweenTime * 3)
	if not currScreenGui then return end
	
	local regSize = blocks[6].Size
	local regPos = blocks[6].Position
	
	blocks[6].Size = blocks[1].Size 
	blocks[6].Position = blocks[1].Position
	
	blocks[1].Size =  regSize
	blocks[1].Position = regPos
	
	wait()

	for i = 1,6 do
		local delayTime = tweenTime * (i - 1) * 0.5
		Delay(delayTime, function()
			if not currScreenGui then return end

			local blockIndex = i
			local blockSizeMultiplier = 4 - (i * 0.5)
			
			blocks[blockIndex]:TweenPosition(UDim2.new(1,0,yPosScale,yPosOffset),
							  						Enum.EasingDirection.Out,tweenStyle,
		  					  						tweenTime,true)
			if i == 6 then
				blocks[6]:TweenSizeAndPosition(UDim2.new(0,blockSize,0,blockSize),
												UDim2.new(1,0,yPosScale,yPosOffset),
												Enum.EasingDirection.InOut,tweenStyle,
												tweenTime,true)
					
				wait(tweenTime * 1.1)
				leftScreenEntrance()
			else
				local newSize = blockSize * blockSizeMultiplier
				blocks[6]:TweenSizeAndPosition(UDim2.new(0,newSize,0,newSize),
												UDim2.new(0.5,-newSize/2,yPosScale,getYOffset(newSize)),
												Enum.EasingDirection.InOut,tweenStyle,
												tweenTime * 0.75,true)
			end
		end)
	end
end

function leftScreenEntrance()
	if not currScreenGui then return end

	for i = 1,6 do
		blocks[i].Size = UDim2.new(0,blockSize,0,blockSize)
		blocks[i].Position = UDim2.new(0,-blockSize,yPosScale,yPosOffset)
	end
	
	blocks[1]:TweenPosition(UDim2.new(0.5,-blockSize/2,yPosScale,yPosOffset),Enum.EasingDirection.Out,tweenStyle,tweenTime,true,function()
		for i = 1, 6 do
			local delayTime = tweenTime * (i - 1) * 0.5
			
			Delay(delayTime, function()
				if not currScreenGui then return end

				local blockIndex = i
				local blockSizeMultiplier = 1 + (i * 0.5)
			
				blocks[blockIndex]:TweenPosition(UDim2.new(0.5,-blockSize/2,yPosScale,yPosOffset),
									  Enum.EasingDirection.Out,tweenStyle,
				  					  tweenTime,true)
				
				local newSize = blockSize * blockSizeMultiplier
				blocks[1]:TweenSizeAndPosition(UDim2.new(0,newSize,0,newSize),
											UDim2.new(0.5,-newSize/2,yPosScale,getYOffset(newSize)),
											Enum.EasingDirection.InOut,tweenStyle,
											tweenTime * 0.75,true)
				
				
				if i == 4 then
					rightScreenExit()
				end
			end)
		end
	end)
end

function startLoadingAnimation()
	currScreenGui.MainBackgroundContainer.BackgroundThumbnail:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.InOut,Enum.EasingStyle.Linear,20,true)
	leftScreenEntrance()
end

startLoadingAnimation()