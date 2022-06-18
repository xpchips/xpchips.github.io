
--new playerlist by Zach Lindblad (fusroblox)
--contact him for any revisions/issues

--------------------  
-- Super Util
-------------------- 
--[[
	Generic object Create function, which I am using to create Gui's 
	Thanks to Stravant! 
--]]
local Obj = {}
function Obj.Create(guiType)
	return function(data)
		local obj = Instance.new(guiType)
		for k, v in pairs(data) do
			if type(k) == 'number' then
				v.Parent = obj
			else
				obj[k] = v
			end
		end
		return obj
	end
end 

--[[
	makes a full sized background for a guiobject
	@Args:
	imgName		asset name of image to fill background
	@Return:	background gui object
--]]
function MakeBackgroundGuiObj(imgName)
	return Obj.Create'ImageLabel'
	{
		Name = 'Background',
		BackgroundTransparency = 1,
		Image = imgName,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1,0,1,0),
	}
end
--[[ turns 255 integer color value to a color3 --]]
function Color3I(r,g,b)
	return Color3.new(r/255,g/255,b/255)
end

--[[
	Gets correct icon for builder's club status to display by name
	@Args:
	membershipType		Enum of membership status
	@Return: 			string of image asset
--]]
function getMembershipTypeIcon(membershipType)
	if membershipType == Enum.MembershipType.None then
		return ""--"rbxasset://textures/ui/TinyBcIcon.png"--
	elseif membershipType == Enum.MembershipType.BuildersClub then
		return "rbxasset://textures/ui/TinyBcIcon.png"
	elseif membershipType == Enum.MembershipType.TurboBuildersClub then
		return "rbxasset://textures/ui/TinyTbcIcon.png"
	elseif membershipType == Enum.MembershipType.OutrageousBuildersClub then
		return "rbxasset://textures/ui/TinyObcIcon.png"
	else
		error("Unknown membershipType" .. membershipType)
	end	
end

--[[
	Utility function to create buttons for the popup menus
	@Args:
	nparent		what to parent this button to
	ntext		text to put on this button
	index		number index of this entry in menu
	last		is this the last element of the popup menu
	@Return:	a popup menu button
--]]
function MakePopupButton(nparent,ntext,index,last)
	local tobj = Obj.Create"ImageButton"
	{
		Name = 'ReportButton',
		BackgroundTransparency = 1,
		Position = UDim2.new(0,0,1*index,0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex=9,
		Obj.Create'TextLabel'
		{
			Name = 'ButtonText',
			BackgroundTransparency = 1,
			Position = UDim2.new(.07, 0, .07, 0),
			Size = UDim2.new(.86,0,.86,0),
			Parent = HeaderFrame,
			Font = 'ArialBold',
			Text = ntext,
			FontSize = 'Size14',
			TextScaled = true,
			TextColor3 = Color3.new(1,1,1),
			TextStrokeTransparency = 1,
			ZIndex=9,
		},
		Parent = nparent,
	}
	if index==0 then
		tobj.Image = 'http://www.roblox.com/asset/?id=97108784'
	elseif last then
		tobj.Image = 'http://www.roblox.com/asset/?id=97109175'
	else
		if index%2==1 then
			tobj.Image = 'http://www.roblox.com/asset/?id=97112126'
		else
			tobj.Image = 'http://www.roblox.com/asset/?id=97109338'
		end
	end
	return tobj
end

--[[
	simple function to toggle the display of debug output
--]]
local DebugPrintEnabled=false
function debugprint(str)
	if DebugPrintEnabled then
		print(str)
	end
end

--[[
	obligatory wait for child function
	@Args:
	parent		Parent object to look for child in
	child		name of child object to look for
	@Return: object waited for
--]]
function WaitForChild(parent,child)
	while not parent:FindFirstChild(child) do
		wait() debugprint(" child "..parent.Name.." waiting for "..child)
	end
	return parent[child]
end

 ---------------------------  
 -- Workspace Objects
 --------------------------- 

-- might want to move all this to an init function, wait for localplayer elsewhere
local Players = game:GetService('Players')
-- make sure this doesn't run on the server(it will if you dont do this)
while not Players.LocalPlayer do
	Players.Changed:wait() 
end

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Obj.Create"Frame"
{
	Name = 'PlayerListScreen',
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Parent = script.Parent -- LocalPlayer.PlayerGui -- 
}
local MainFrame = Obj.Create"Frame"
{
	Name = 'LeaderBoardFrame',
	Position = UDim2.new(1, -150, 0.005, 0),
	Size = UDim2.new(0, 150, 0, 800),--0.99000001
	BackgroundTransparency = 1,
	Parent = ScreenGui,
}

local TemplateFrameYSize = 0.670000017

 -- HEADER
local HeaderFrame = Obj.Create"Frame"
{
	Name = 'Header',
	BackgroundTransparency = 1,
	Position = UDim2.new(0,0,0,0),
	Size = UDim2.new(1, 0, .07, 0),
	Parent = MainFrame,
	MakeBackgroundGuiObj('http://www.roblox.com/asset/?id=94692054'),
}
	local HeaderFrameHeight = HeaderFrame.Size.Y.Scale
	local MaximizeButton = Obj.Create"ImageButton"
	{
		Name = 'MaximizeButton',
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1,0,1,0),
		Parent = HeaderFrame,
	}
	local HeaderName = Obj.Create"TextLabel"
	{
		Name = 'PlayerName',
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, .01, 0),
		Size = UDim2.new(.98,0,.38,0),
		Parent = HeaderFrame,
		Font = 'ArialBold',
		Text = LocalPlayer.Name,
		FontSize='Size24',
		--TextScaled = true,
		TextColor3 = Color3.new(1,1,1),
		TextStrokeColor3 = Color3.new(0,0,0),
		TextStrokeTransparency = 0,
		TextXAlignment = 'Right',
		TextYAlignment = 'Center',
	}
	local HeaderScore = Obj.Create"TextLabel"
	{
		Name = 'PlayerScore',
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, .5, 0),
		Size = UDim2.new(.98,0,.5,0),
		Parent = HeaderFrame,
		Font = 'ArialBold',
		Text = '',
		--FontSize='Size24',
		TextScaled = true,
		TextColor3 = Color3.new(1,1,1),
		TextStrokeTransparency = 1,
		TextXAlignment = 'Right',
	}
 -- BOTTOM
local BottomFrame = Obj.Create"Frame"
{
	Name = 'Bottom',
	BackgroundTransparency = 1,
	Position = UDim2.new(0,0,.07,0),
	Size = UDim2.new(1, 0, .03, 0),
	Parent = MainFrame,
	MakeBackgroundGuiObj('http://www.roblox.com/asset/?id=94754966'),
}
	local ExtendButton = Obj.Create"ImageButton"
	{
		Name = 'bigbutton',
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1,0,1.5,0),
		ZIndex = 3,
		Parent = BottomFrame,
	}
	local ExtendTab = Obj.Create"ImageButton"
	{
		Name = 'extendTab',
		Active = true,
		BackgroundTransparency = 1,
		Image = 'http://www.roblox.com/asset/?id=94692731',
		Position = UDim2.new(.608, 0, .3, 0),
		Size = UDim2.new(.3,0,.7,0),
		Parent = BottomFrame,
	}
local TopClipFrame = Obj.Create"Frame"
{
	Name = 'ListFrame',
	BackgroundTransparency = 1,
	Position = UDim2.new(0,0,.07,0),
	Size = UDim2.new(1, 0, 1, 0),
	Parent = MainFrame,
	ClipsDescendants = true,
}
	local BottomClipFrame = Obj.Create"Frame"
	{
		Name = 'BottomFrame',
		BackgroundTransparency = 1,
		Position = UDim2.new(0,0, - .76,0),
		Size = UDim2.new(1, 0, 1, 0),
		Parent = TopClipFrame,
		ClipsDescendants = true,
	}
		local ScrollBarFrame = Obj.Create"Frame"
		{
			Name = 'ScrollBarFrame',
			BackgroundTransparency = 1,
			Position = UDim2.new(.97,0,.76,0),
			Size = UDim2.new(.02, 0, .24, 0),
			Parent = BottomClipFrame,
		}
			local ScrollBar = Obj.Create"Frame"
			{
				Name = 'ScrollBar',
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(.2,.2,.2),
				Position = UDim2.new(0,0,0,0),
				Size = UDim2.new(1, 0, .5, 0),
				ZIndex = 5,
				Parent = ScrollBarFrame,
				
			}
		local ListFrame = Obj.Create"Frame"
		{
			Name = 'SubFrame',
			BackgroundTransparency = 1,
			Position = UDim2.new(0,0,.76,0),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = BottomClipFrame,
		}
local PopUpClipFrame = Obj.Create"Frame"
{
	Name = 'PopUpFrame',
	BackgroundTransparency = 1,
	SizeConstraint='RelativeXX',
	Position = MainFrame.Position + UDim2.new( 0,-150,0,0),
	Size = UDim2.new(0,150,0,800),
	Parent = MainFrame,
	ClipsDescendants = true,
	ZIndex=9,
}
	local PopUpPanel = Obj.Create"Frame"
	{
		Name = 'Panel',
		BackgroundTransparency = 1,
		Position = UDim2.new(1,0,0,0),
		Size = UDim2.new(1,0,.032,0),
		Parent = PopUpClipFrame,
	}
		local ReportPlayerButton = MakePopupButton(PopUpPanel,'ReportPlayer',0)
		local FriendPlayerButton = MakePopupButton(PopUpPanel,'Friend',1,true)
	local PersonalServerPanel = Obj.Create"Frame"
	{
		Name = 'Panel',
		BackgroundTransparency = 1,
		Position = UDim2.new(1,0,0,0),
		Size = UDim2.new(1,0,.032,0),
		Parent = PopUpClipFrame,

	}
		local PSReportPlayerButton = MakePopupButton(PersonalServerPanel,'ReportPlayer',0)
		local PSFriendPlayerButton = MakePopupButton(PersonalServerPanel,'Friend',1)
		local BanPlayerButton = MakePopupButton(PersonalServerPanel,'Ban',2)
		local VisitorButton = MakePopupButton(PersonalServerPanel,'Visitor',3)
		local MemberButton = MakePopupButton(PersonalServerPanel,'Member',4)
		local AdminButton = MakePopupButton(PersonalServerPanel,'Admin',5,true)
local StatTitles = Obj.Create"Frame"
{
	Name = 'StatTitles',
	BackgroundTransparency = 1,
	Position = UDim2.new(0,0,.04,0),
	Size = UDim2.new(1, 0, .03, 0),
	Parent = MainFrame,
}

local IsMinimized = Instance.new('BoolValue')
local IsMaximized = Instance.new('BoolValue')
local IsTabified = Instance.new('BoolValue')


local MiddleTemplate = Obj.Create"Frame"
{
	Name = 'MidTemplate',
	BackgroundTransparency = 1,
	Position = UDim2.new(100,0,.07,0),
	Size = UDim2.new(1, 0, .03, 0),
	Obj.Create'ImageLabel'
	{
		Name = 'BCLabel',
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(.005, 0, .15, 0),
		Size = UDim2.new(0,20,0,20),
		SizeConstraint = 'RelativeYY',
		Image = "",
		ZIndex = 3,
	},
	Obj.Create"ImageButton"
	{
		Name = 'ClickListener',
		Active = true,
		BackgroundTransparency = 1,
		Position = UDim2.new(.005, 1, 0, 0),
		Size = UDim2.new(.96,0,1,0),
		ZIndex = 3,
	},
	Obj.Create"Frame"
	{
		Name = 'TitleFrame',
		BackgroundTransparency = 1,
		Position = UDim2.new(.01, 0, .1, 0),
		Size = UDim2.new(0,140,.67,0),
		ClipsDescendants=true,
		Obj.Create"TextLabel"
		{
			Name = 'Title',
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(100,0,1,0),
			Font = 'Arial',
			FontSize='Size14',
			TextColor3 = Color3.new(1,1,1),
			TextXAlignment = 'Left',
			ZIndex = 3,
		},
	},
	
	Obj.Create"TextLabel"
	{
		Name = 'PlayerScore',
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, .1, 0),
		Size = UDim2.new(1,0,.67,0),
		Font = 'Arial',
		Text = '',
		FontSize='Size14',
		TextColor3 = Color3.new(1,1,1),
		TextXAlignment = 'Left',
		ZIndex = 3,
	},
	Obj.Create'IntValue'{Name = 'ID'},
	Obj.Create'ObjectValue'{Name = 'Player'},
	Obj.Create'IntValue'{Name = 'Score'},	
	ZIndex = 3,
}
local MiddleBGTemplate = Obj.Create"Frame"
{
	Name = 'MidBGTemplate',
	BackgroundTransparency = 1,
	Position = UDim2.new(100,0,.07,0),
	Size = UDim2.new(1, 0, .03, 0),
	MakeBackgroundGuiObj('http://www.roblox.com/asset/?id=94692025'),
	
}

 -- REPORT ABUSE OBJECTS

local ReportAbuseShield = Obj.Create"TextButton"
{
	Name = "ReportAbuseShield",
	Text = "",
	AutoButtonColor = false,
	Active = true,
	Visible = true,
	Size = UDim2.new(1,0,1,0),
	BackgroundColor3 = Color3I(51,51,51),
	BorderColor3 = Color3I(27,42,53),
	BackgroundTransparency = 1,
}

local ReportAbuseFrame = Obj.Create "Frame"
{
	Name = "Settings",
	Position = UDim2.new(0.5, - 250, 0.5, - 200),
	Size = UDim2.new(0.0, 500, 0.0, 400),
	BackgroundTransparency = 1,
	Active = true,
	Parent = ReportAbuseShield,
}

local AbuseSettingsFrame = Obj.Create"Frame"
{
	Name = "ReportAbuseStyle",
	Size = UDim2.new(1, 0, 1, 0),
	Active = true,
	BackgroundTransparency = 1,
	MakeBackgroundGuiObj('http://www.roblox.com/asset/?id=96488767'), -- 96480351'),
	Obj.Create"TextLabel"
	{
		Name = "Title",
		Text = "Report Abuse",
		TextColor3 = Color3I(221,221,221),
		Position = UDim2.new(0.5, 0, 0, 30),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size36,
	},
	Obj.Create"TextLabel"
	{
		Name = "Description",
		Text = "This will send a complete report to a moderator.  The moderator will review the chat log and take appropriate action.",
		TextColor3 = Color3I(221,221,221),
		Position = UDim2.new(.01, 0, 0, 55),
		Size = UDim2.new(.99, 0, 0, 40),
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		TextWrap = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	},
	Obj.Create"TextLabel"
	{
		Name = "AbuseLabel",
		Text = "What did they do?",
		Font = Enum.Font.Arial,
		BackgroundTransparency = 1,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025,0,0,140),
		Size = UDim2.new(0.4,0,0,36),
		TextColor3 = Color3I(255,255,255),
		TextXAlignment = Enum.TextXAlignment.Left,
	},
	Obj.Create"TextLabel"
	{
		Name = "ShortDescriptionLabel",
		Text = "Short Description: (optional)",
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025,0,0,180),
		Size = UDim2.new(0.95,0,0,36),
		TextColor3 = Color3I(255,255,255),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
	},
	Obj.Create"TextLabel"
	{
		Name = "ReportingPlayerLabel",
		Text = "Reporting Player",
		BackgroundTransparency = 1,
		Font = Enum.Font.Arial,
		FontSize = Enum.FontSize.Size18,
		Position = UDim2.new(0.025,0,0,100),
		Size = UDim2.new(0.95,0,0,36),
		TextColor3 = Color3I(255,255,255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = AbuseSettingsFrame
	},

	Parent = ReportAbuseFrame,
}

local AbusePlayerLabel = Obj.Create"TextLabel"
{
	Name = "PlayerLabel",
	Text = "",
	BackgroundTransparency = 1,
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size18,
	Position = UDim2.new(0.025,0,0,100),
	Size = UDim2.new(0.95,0,0,36),
	TextColor3 = Color3I(255,255,255),
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = AbuseSettingsFrame
}

local SubmitReportButton = Obj.Create"ImageButton"
{
	Name = "SubmitReportBtn",
	Active = false,
	BackgroundTransparency = 1,
	Position = UDim2.new(.5, - 200, 1, - 80),
	Size = UDim2.new(0,150,0,50),
	AutoButtonColor = false,
	Image = 'http://www.roblox.com/asset/?id=96502438', -- 96501119',
	Parent = AbuseSettingsFrame,
}

local CancelReportButton = Obj.Create"ImageButton"
{
	Name = "CancelBtn",
	BackgroundTransparency = 1,
	Position = UDim2.new(0.5, 50, 1, - 80),
	Size = UDim2.new(0,150,0,50),
	AutoButtonColor = true,
	Image = 'http://www.roblox.com/asset/?id=96500683',
	Parent = AbuseSettingsFrame,
}

local AbuseDescriptionWrapper = Obj.Create"Frame"
{
	Name = "AbuseDescriptionWrapper",
	Position = UDim2.new(0.025,0,0,220),
	Size = UDim2.new(0.95,0,1, - 310),
	BackgroundColor3 = Color3I(0,0,0),
	BorderSizePixel = 0,
	Parent = AbuseSettingsFrame,
}

local AbuseDescriptionBox 

local OriginalAbuseDescriptionBox = Obj.Create"TextBox"
{
	Name = "TextBox",
	Text = "",
	ClearTextOnFocus = false,
	Font = Enum.Font.Arial,
	FontSize = Enum.FontSize.Size18,
	Position = UDim2.new(0,3,0,3),
	Size = UDim2.new(1, - 6,1, - 6),
	TextColor3 = Color3I(255,255,255),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextWrap = true,
	BackgroundColor3 = Color3I(0,0,0),
	BorderSizePixel = 0,
}

local CalmingAbuseBox = Obj.Create'Frame'
{
	Name = 'AbuseFeedbackBox',
	BackgroundTransparency = 1,
	Position=UDim2.new(0.25, 0, 0.300000012, 0),
	Size=UDim2.new(0.5, 0, 0.370000005, 0),
	MakeBackgroundGuiObj('http://www.roblox.com/asset/?id=96506233'),
	Obj.Create'TextLabel'
	{
		Name = 'Header',
		Position=UDim2.new(0,10,.05,0),
		Size=UDim2.new(1, -30, .15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = 'Thanks for your report!',
		TextColor3 = Color3.new(1,1,1),
		FontSize = Enum.FontSize.Size48,
		Font = 'ArialBold',
	},
	Obj.Create'TextLabel'
	{
		Name = 'content',
		Position = UDim2.new(0,10,.20,0),
		Size = UDim2.new(1, -30, .40, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1,1,1),
		Text = 'Our moderators will review the chat logs and determine what happened.  The other user is probably just trying to make you mad.\n\nIf anyone used swear words, inappropriate language, or threatened you in real life, please report them for Bad Words or Threats',
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		FontSize = Enum.FontSize.Size24,
		Font = 'Arial',
	},
	Obj.Create'ImageButton'
	{
		Name = "OkButton",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -75, 1, -80),
		Size = UDim2.new(0,150,0,50),
		AutoButtonColor = true,
		Image = 'http://www.roblox.com/asset/?id=96507959',
	}
}
local NormalAbuseBox = Obj.Create'Frame'
{
	Name = 'AbuseFeedbackBox',
	BackgroundTransparency = 1,
	Position = UDim2.new(0.25, 0, 0.300000012, 0),
	Size = UDim2.new(0.5, 0, 0.370000005, 0),
	MakeBackgroundGuiObj('http://www.roblox.com/asset/?id=96506233'),
	Obj.Create'TextLabel'
	{
		Name = 'Header',
		Position = UDim2.new(0,10,.05,0),
		Size = UDim2.new(1, -30, .15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1,1,1),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = 'Thanks for your report!',
		FontSize = Enum.FontSize.Size48,
		Font ='ArialBold'
	},
	Obj.Create'TextLabel'
	{
		Name = 'content',
		Position = UDim2.new(0,10,.20,0),
		Size = UDim2.new(1, -30, .15, 0),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1,1,1),
		Text = "Our moderators will review the chat logs and determine what happened.",
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		FontSize = Enum.FontSize.Size24,
		Font = 'Arial',
	},
	Obj.Create'ImageButton'
	{
		Name = "OkButton",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -75, 1, -80),
		Size = UDim2.new(0,150,0,50),
		AutoButtonColor = true,
		Image = 'http://www.roblox.com/asset/?id=96507959',
	},
}

local BigButton=Instance.new('ImageButton')
	BigButton.Size=UDim2.new(1,0,1,0)
	BigButton.BackgroundTransparency=1
	BigButton.ZIndex=8
	BigButton.Visible=false
	--BigButton.Active=false
	BigButton.Parent=ScreenGui
	
 -------------------------  
 -- Script objects
 ------------------------- 
local RbxGui = assert(LoadLibrary('RbxGui'))

 -- number of entries to show if you click minimize
local DefaultEntriesOnScreen = 8


	
local Images = {
	bottomDark = '94691904',
	bottomLight = '94691940',
	midDark = '94691980',
	midLight = '94692025',
	LargeDark = '96098866',
	LargeLight = '96098920',
	LargeHeader = '96097470',
	NormalHeader = '94692054',
	LargeBottom = '96397271', -- '96098152',
	NormalBottom = '94754966',
	DarkBluePopupMid = '97114905',
	LightBluePopupMid = '97114905',
	DarkPopupMid = '97112126',
	LightPopupMid = '97109338',
	DarkBluePopupTop = '97114838',
	LightBluePopupTop = '',
	DarkPopupTop = '',
	LightPopupTop = '',
	DarkBluePopupBottom = '97114758',
	LightBluePopupBottom = '',
	DarkPopupBottom = '97109175',
	LightPopupBottom = '',
}

for _,i in pairs(Images) do
	Game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id="..i)
end

 -- ordered array of 'score data', each entry has:
 -- Name(String)
 -- Priority(number)
 -- IsPrimary (bool, should it be shown in upper right)
 -- MaxLength (integer, of the length of the longest element for this column)
local ScoreNames = {}
 -- prevents flipping in playerlist panels
local AddId = 0
 -- intermediate table form of all player entries in format of:
 -- Frame
 -- Player
 -- Score
 -- ID
 -- MyTeam (team ENRTY(not actual team) I am currently on)
local PlayerFrames = {}
 -- intermediate ordered frame array, composed of Entrys of
 -- Frame
 -- MyTeam (my team object)
 -- MyPlayers ( an ordered array of all player frames in team )
 -- AutoHide (bool saying whether it should be hidden)
 -- IsHidden (bool)
 -- ID (int to prevent flipping out of leaderboard, fun times)
local TeamFrames = {}
 -- one special entry from teamFrames, for unaffiliated players, only shown if players non - empty
local NeutralTeam = nil

 -- final 'to be displayed' list of frames
local MiddleFrames = {}
local MiddleFrameBackgrounds = {}
local MiddleFrameHeight = .03
 -- time of last click
local LastClick = 0
local ButtonCooldown = .25



 -- you get 200 of x screen space per stat added, start width 16%
local BaseScreenXSize = 150
local SpacingPerStat = 10 --spacing between stats


local MaximizedBounds = UDim2.new(.5,0,1,0)
local MaximizedPosition = UDim2.new(.25,0,.1,0)
local NormalBounds = UDim2.new(0,BaseScreenXSize, 0, 800)
local NormalPosition = UDim2.new(1 , - BaseScreenXSize, 0.005, 0)

local MinimizedBounds = UDim2.new(0, BaseScreenXSize, 0.99000001, 0)


 -- number of stats to show from leaderstats
local NumPrimaryStats = 0
 -- where the scroll par currently is positioned
local ScrollPosition = 0.75999999
local IsDragging = false -- am I dragging the player list

local DefaultBottomClipPos = BottomClipFrame.Position.Y.Scale

local LastSelectedPlayerEntry = nil
local SelectedPlayerEntry = nil
local SelectedPlayer = nil

 -- locks(semaphores) for stopping race conditions
local AddingFrameLock = false
local ChangingOrderLock = false
local AddingStatLock = false
local BaseUpdateLock = false
local WaitForClickLock = false
local InPopupWaitForClick=false


 -- report abuse objects
local AbuseName
local Abuses = {
	"Bad Words or Threats",
	"Bad Username",
	"Talking about Dating",
	"Account Trading or Sharing",
	"Asking Personal Questions",
	"Rude or Mean Behavior",
	"False Reporting Me"
}
local UpdateAbuseFunction
local AbuseDropDown, UpdateAbuseSelection

local PrivilegeLevel = 
{
	Owner = 255,
	Admin = 240,
	Member = 128,
	Visitor = 10,
	Banned = 0,
}


local IsPersonalServer = not not game.Workspace:FindFirstChild("PSVariable")
if IsPersonalServer then
	--THIS SHOULD NOT BE HERE GUYS, only keeping to perserve old functionality
	game:GetService("ScriptContext"):AddCoreScript(64164692,game.Players.LocalPlayer,"BuildToolManager")
end
game.Workspace.ChildAdded:connect(function(nchild)
	if nchild.Name=='PSVariable' and nchild:IsA('BoolValue') then
		IsPersonalServer=true
		--THIS SHOULD NOT BE HERE GUYS, only keeping to perserve old functionality
		game:GetService("ScriptContext"):AddCoreScript(64164692,game.Players.LocalPlayer,"BuildToolManager")
	end
end)
 -------------------------------  
 -- Static Functions
 ------------------------------- 
function GetTotalEntries()
	return math.min(#MiddleFrameBackgrounds,DefaultEntriesOnScreen)
end

function AreAllEntriesOnScreen()
	return #MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale <= 1 + BottomClipFrame.Position.Y.Scale
end

function GetLengthOfVisbleScroll()
	return 1 + BottomClipFrame.Position.Y.Scale
end

function GetMaxScroll()
	return BottomClipFrame.Position.Y.Scale *  - 1
end
 -- can be optimized by caching when this varible changes
function GetMinScroll()
	if AreAllEntriesOnScreen() then
		return GetMaxScroll()
	else
		return (GetMaxScroll() - (#MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale)) + (1 + BottomClipFrame.Position.Y.Scale)
	end
end

function AbsoluteToPercent(x,y)
	return Vector2.new(x,y)/ScreenGui.AbsoluteSize
end
--[[
	tweens text transparency of element from starta to enda over length of time
	Warning: should be put in a Spawn call
	@Args:
	element		textobject to tween transparency on
	starta		alpha to start tweening
	enda		alpha to end tweening on
	length		how many seconds to spend tweening
--]]
function TweenTextTransparency(element,starta,enda,length)
	local startTime = time()
	while time() - startTime < length do
		element.TextTransparency = ((enda - starta) * ((time() - startTime)/length)) + starta
		wait(.01)
	end
	element.TextTransparency = enda
end
--[[
	tweens background transparency of element from starta to enda over length of time
	Warning: should be put in a Spawn call
	@Args:
	element		guiobject to tween transparency on
	starta		alpha to start tweening
	enda		alpha to end tweening on
	length		how many seconds to spend tweening
--]]
function TweenBackgroundTransparency(element,starta,enda,length)
	local startTime = time()
	while time() - startTime < length do
		element.BackgroundTransparency = ((enda - starta) * ((time() - startTime)/length)) + starta
		wait(.01)
	end
	element.BackgroundTransparency = enda
end

--[[
	UGLY UGLY HACK FUNCTION
	replace with some sort of global input catching A.S.A. FREAKING P.
	creates a fullsize gui element to catch next mouse up event(completeing a click)
	@Args:
	frameParent		Object to parent fullscreen gui to
	polledFunction	function to call on mouse moved events in this gui
	exitFunction	function to call when click event is fired
--]]
function WaitForClick(frameParent,polledFunction,exitFunction)
	if WaitForClickLock then return end
	WaitForClickLock=true
	BigButton.Visible=true
	--BigButton.Active=true
	--BigButton.Parent=frameParent
	local upHappened=false
	local connection, connection2
	connection2=BigButton.MouseMoved:connect( function(nx,ny)
		polledFunction(nx,ny)
	end)
	connection=BigButton.MouseButton1Up:connect(function(nx,ny)
		exitFunction(nx,ny)
		BigButton.Visible=false
		connection:disconnect()
		connection2:disconnect()
	end)
	WaitForClickLock=false
end


---------------------------
--Personal Server Handling
---------------------------
--[[
	returns privlage level based on integer rank
	Note: these privilege levels seem completely arbitrary, but no documentation exists
	this is all from the old player list, really weird
	@Args:
	rank	Integer rank value for player
	@Return		Normalized integer value for rank?
--]]
function GetPrivilegeType(rank)
	if rank <= PrivilegeLevel['Banned'] then
		return PrivilegeLevel['Banned']
	elseif rank <= PrivilegeLevel['Visitor'] then
		return PrivilegeLevel['Visitor']
	elseif rank <= PrivilegeLevel['Member'] then
		return PrivilegeLevel['Member']
	elseif rank <= PrivilegeLevel['Admin'] then
		return PrivilegeLevel['Admin']
	else
		return PrivilegeLevel['Owner']
	end
end

--[[
	gives a player a new privilage rank
	Note: Very odd that I have to use loops with this instead of directly setting the rank
	but no documentation for personal server service exists
	@Args:
	player		player to change rank of
	nrank		new integer rank to give player
--]]
function SetPrivilegeRank(player,nrank)
	while player.PersonalServerRank<nrank do
		game:GetService("PersonalServerService"):Promote(player)
	end
	while player.PersonalServerRank>nrank do
		game:GetService("PersonalServerService"):Demote(player)
	end
end
--[[
	called when player selects new privilege level from popup menu
	@Args:
	player		player to set privileges on
	nlevel		new privilege level for this player
--]]
function OnPrivilegeLevelSelect(player,nlevel)
	debugprint('setting privilege level')
	SetPrivilegeRank(player,nlevel)
	HighlightMyRank(player)
	PersonalServerPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", .5,true)
end

--[[
	Highlights current rank of this player in the popup menu
	@Args:
	player		Player to check for rank on
--]]
function HighlightMyRank(player)
	BanPlayerButton.Image= 'http://www.roblox.com/asset/?id='..Images['LightPopupMid']
	VisitorButton.Image= 'http://www.roblox.com/asset/?id='..Images['DarkPopupMid']
	MemberButton.Image= 'http://www.roblox.com/asset/?id='..Images['LightPopupMid']
	AdminButton.Image= 'http://www.roblox.com/asset/?id='..Images['DarkPopupBottom']
	
	local rank=player.PersonalServerRank
	if rank <= PrivilegeLevel['Banned'] then
		BanPlayerButton.Image='http://www.roblox.com/asset/?id='..Images['LightBluePopupMid']
	elseif rank <= PrivilegeLevel['Visitor'] then
		VisitorButton.Image='http://www.roblox.com/asset/?id='..Images['DarkBluePopupMid']
	elseif rank <= PrivilegeLevel['Member'] then
		MemberButton.Image='http://www.roblox.com/asset/?id='..Images['LightBluePopupMid']
	elseif rank <= PrivilegeLevel['Admin'] then
		AdminButton.Image= 'http://www.roblox.com/asset/?id='..Images['DarkBluePopupBottom']
	end
end

BanPlayerButton.MouseButton1Click:connect(function() BigButton.Visible=false OnPrivilegeLevelSelect(SelectedPlayer,PrivilegeLevel['Banned']) end)
VisitorButton.MouseButton1Click:connect(function() BigButton.Visible=false OnPrivilegeLevelSelect(SelectedPlayer,PrivilegeLevel['Visitor']) end)
MemberButton.MouseButton1Click:connect(function() BigButton.Visible=false OnPrivilegeLevelSelect(SelectedPlayer,PrivilegeLevel['Member']) end)
AdminButton.MouseButton1Click:connect(function() BigButton.Visible=false OnPrivilegeLevelSelect(SelectedPlayer,PrivilegeLevel['Admin']) end)

 --------------------------  
 -- Report abuse handling
 -------------------------- 
--[[
	does final reporting of abuse on selected player, calls closeAbuseDialog
--]]
function OnSubmitAbuse()
	if SubmitReportButton.Active then
		if AbuseName and SelectedPlayer then
			AbuseSettingsFrame.Visible = false
			game.Players:ReportAbuse(SelectedPlayer, AbuseName, AbuseDescriptionBox.Text)
			if AbuseName == "Rude or Mean Behavior" or AbuseName == "False Reporting Me" then
				CalmingAbuseBox.Parent = ReportAbuseShield
			else
				debugprint('opening abuse box')
				NormalAbuseBox.Parent = ReportAbuseShield
			end
		else
			CloseAbuseDialog()
		end
	end
end

--[[
	opens the abuse dialog, initialises text to display selectedplayer
--]]
function OpenAbuseDialog()
	debugprint('adding report dialog')
	AbusePlayerLabel.Text = SelectedPlayer.Name
	--AbuseDescriptionBox.Text = ""
	PopUpPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", .5,true)
	AbuseDescriptionBox=OriginalAbuseDescriptionBox:Clone()
	AbuseDescriptionBox.Parent = AbuseDescriptionWrapper
	ReportAbuseShield.Parent = ScreenGui
end
--[[
	resets and closes abuse dialog
--]]
function CloseAbuseDialog()
	AbuseName = nil
	SubmitReportButton.Active = false
	SubmitReportButton.Image = 'http://www.roblox.com/asset/?id=96502438' -- 96501119',
	--AbuseDescriptionBox.Text = ""
	AbuseDescriptionBox:Destroy()
	CalmingAbuseBox.Parent = nil
	NormalAbuseBox.Parent = nil
	ReportAbuseShield.Parent = nil
	AbuseSettingsFrame.Visible = true
end

--[[
	creates dropdownbox, registers all listeners for abuse dialog
--]]
function InitReportAbuse()

	UpdateAbuseFunction = function(abuseText) 
		AbuseName = abuseText 
		if AbuseName and SelectedPlayer then
			SubmitReportButton.Active = true
			SubmitReportButton.Image = 'http://www.roblox.com/asset/?id=96501119'
		end
	end
	
	AbuseDropDown, UpdateAbuseSelection = RbxGui.CreateDropDownMenu(Abuses, UpdateAbuseFunction, true)
	AbuseDropDown.Name = "AbuseComboBox"
	AbuseDropDown.Position = UDim2.new(0.425, 0, 0, 142)
	AbuseDropDown.Size = UDim2.new(0.55,0,0,32)
	AbuseDropDown.Parent = AbuseSettingsFrame
	
	
	CancelReportButton.MouseButton1Click:connect(CloseAbuseDialog)
	SubmitReportButton.MouseButton1Click:connect(OnSubmitAbuse)
	ReportPlayerButton.MouseButton1Click:connect(function() BigButton.Visible=false OpenAbuseDialog() end)
	PSReportPlayerButton.MouseButton1Click:connect(function() BigButton.Visible=false OpenAbuseDialog() end)
	CalmingAbuseBox:FindFirstChild('OkButton').MouseButton1Down:connect(CloseAbuseDialog)
	NormalAbuseBox:FindFirstChild('OkButton').MouseButton1Down:connect(CloseAbuseDialog)
end

-------------------------------------
-- Friend/unfriending
-------------------------------------
--[[
	gets enum val of friend status, uses pcall for some reason?(from old playerlist)
	@Args:
	player	player object to check if friends with
	@Return: enum of friend status
--]]
local function GetFriendStatus(player)
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
--[[
	Updates text on popup friend button of SelectedPlayer
	called when popup opens
--]]
function OnFriendPopUpOpen()
	local friendButton
	if IsPersonalServer and LocalPlayer.PersonalServerRank >= PrivilegeLevel['Admin'] then
		friendButton=PSFriendPlayerButton
	else
		friendButton=FriendPlayerButton
	end
	local friendStatus=GetFriendStatus(SelectedPlayer)
	debugprint('status: ' .. tostring(friendStatus))
	if friendStatus==Enum.FriendStatus.Friend then
		friendButton:FindFirstChild('ButtonText').Text='UnFriend Player'
	elseif friendStatus==Enum.FriendStatus.Unknown or friendStatus==Enum.FriendStatus.NotFriend then
		friendButton:FindFirstChild('ButtonText').Text='Send Friend Request'
	elseif friendStatus==Enum.FriendStatus.FriendRequestSent then
		friendButton:FindFirstChild('ButtonText').Text='Friend Request Sent'
	elseif friendStatus==Enum.FriendStatus.FriendRequestReceived then
		friendButton:FindFirstChild('ButtonText').Text='Accept Friend Request'
	end
end
--[[
	when friend button is clicked, tries to take appropriate action, 
	based on current friend status with SelectedPlayer
--]]
function OnFriendButtonSelect()
	BigButton.Visible=false
	local friendStatus=GetFriendStatus(SelectedPlayer)
	if friendStatus==Enum.FriendStatus.Friend then
		game.Players.LocalPlayer:RevokeFriendship(SelectedPlayer)
	elseif friendStatus==Enum.FriendStatus.Unknown or friendStatus==Enum.FriendStatus.NotFriend then
		game.Players.LocalPlayer:RequestFriendship(SelectedPlayer)
	elseif friendStatus==Enum.FriendStatus.FriendRequestSent then
		
	elseif  friendStatus==Enum.FriendStatus.FriendRequestReceived then
		game.Players.LocalPlayer:RequestFriendship(SelectedPlayer)
	end
	PersonalServerPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", .5,true)
	PopUpPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", .5,true)
end

PSFriendPlayerButton.MouseButton1Click:connect(OnFriendButtonSelect)
FriendPlayerButton.MouseButton1Click:connect(OnFriendButtonSelect)
------------------------------------  
-- Player Entry Handling
------------------------------------ 
--[[
	used by lua's table.sort to sort player entries
--]]
function PlayerSortFunction(a,b)
 -- prevents flipping out leaderboard
	if a['Score'] == b['Score'] then
		return a['ID'] < b['ID']
	end
	if not a['Score'] then return false end
	if not b['Score'] then return true end
	return a['Score'] < b['Score']
end

 ---------------------------------  
 -- Stat Handling
 ---------------------------------  
 -- removes and closes all leaderboard stuffs
function BlowThisPopsicleStand()
	--ScreenGui:Destroy()
	--script:Destroy()
	--time to make the fanboys rage...
	Tabify()
end
--[[
	used by lua's table.sort to prioritize score entries
--]]
function StatSort(a,b)
 -- primary stats should be shown before all others
	if a.IsPrimary ~= b.IsPrimary then
		return a.IsPrimary
	end
 -- if priorities are equal, then return the first added one
	if a.Priority == b.Priority then
		return a.AddId < b.AddId
	end
	return a.Priority < b.Priority
end
--[[
	doing WAAY too much here, for optimization update only your team
	@Args:
	playerEntry		Entry of player who had a stat change
	property		Name of stat changed
--]]
function StatChanged(playerEntry,property)

 -- if(playerEntry['MyTeam']) then
 -- UpdateSingleTeam(playerEntry['MyTeam'])
 -- else
		BaseUpdate()
 -- end
end
--[[
	Called when stat is added
	if playerEntry is localplayer, will add to score names and re-sort the stats, and resize the width of the leaderboard
	for all players, will add a listener for if this stat changes
	if stat is a string value, crashes the leaderboard
	Note:change crash to a 'tabify' leaderboard later
	@Args:
	nchild			new child value to leaderstats
	playerEntry		entry this stat was added to
--]]
function StatAdded(nchild,playerEntry)
 -- dont re - add a leaderstat I alreday have
	while AddingStatLock do debugprint('in stat added function lock') wait(1/30) end
	AddingStatLock = true
	if not (nchild:IsA('IntValue') or nchild:IsA('NumberValue')) then
		BlowThisPopsicleStand()
	else
		if playerEntry['Player'] == LocalPlayer then
			
			local nstat = {}
			nstat['Name'] = nchild.Name
			nstat['Priority'] = 0
			if(nchild:FindFirstChild('Priority')) then
				nstat['Priority'] = nchild.Priority
			end
			nstat['IsPrimary'] = false
			if(nchild:FindFirstChild('IsPrimary')) then
				nstat['IsPrimary'] = true
			end
			if(nstat['IsPrimary']) then
				NumPrimaryStats = NumPrimaryStats + 1
			end
			nstat.AddId = AddId
			AddId = AddId + 1
			table.insert(ScoreNames,nstat)
			table.sort(ScoreNames,StatSort)
			UpdateMaximize()

		end
	end
		AddingStatLock = false
		StatChanged(playerEntry)
		nchild.Changed:connect(function(property) StatChanged(playerEntry,property) end)
	
	
end
--[[
	Called when stat is removed from player
	for all players, destroys the stat frame associated with this value,
	then calls statchanged(to resize frame)
	if playerEntry==localplayer, will remove from scorenames
	@Args:
	nchild			___value to be removed
	playerEntry		entry of player value is being removed from
--]]
function StatRemoved(nchild,playerEntry)
	while AddingStatLock do debugprint('In Adding Stat Lock1') wait(1/30) end
	AddingStatLock = true
	if playerEntry['Frame']:FindFirstChild(nchild.Name) then
		debugprint('Destroyed frame!')
		playerEntry['Frame'][nchild.Name].Parent = nil
	end
	if playerEntry['Player'].Name == LocalPlayer.Name then
		for i,val in ipairs(ScoreNames) do
			if val['IsPrimary'] then
				NumPrimaryStats = NumPrimaryStats - 1
			end
			if val['Name'] == nchild.Name then
				table.remove(ScoreNames,i)
			end
		end
	end
	AddingStatLock = false
	StatChanged(playerEntry)
end
--[[
	clears all stats from a given playerEntry
	used when leaderstats are removed, or when new leaderstats are added(for weird edge case)+
--]]
function RemoveAllStats(playerEntry)
	while AddingStatLock do debugprint('In Adding Stat Lock1') wait(1/30) end
	AddingStatLock = true

	for i,val in ipairs(ScoreNames) do
		if playerEntry['Frame']:FindFirstChild(val['Name']) then
			debugprint('Destroyed frame!')
			playerEntry['Frame'][val['Name']].Parent = nil
		end
		if playerEntry['Player'].Name == LocalPlayer.Name then
			NumPrimaryStats = NumPrimaryStats - 1
		end
	end
	if playerEntry['Player'].Name == LocalPlayer.Name then
		NumPrimaryStats = NumPrimaryStats - 1
	end
	
	AddingStatLock = false
	StatChanged(playerEntry)
end

--[[
	
--]]
function MakeScoreEntry(entry,scoreval,panel)
	if not panel:FindFirstChild('PlayerScore') then return end
	local nscoretxt = panel:FindFirstChild('PlayerScore'):Clone()
	local thisScore = nil
	repeat	
		wait()
		debugprint('stuck in leaderstat loop')
		if entry['Player']:FindFirstChild('leaderstats') then
			thisScore = entry['Player']:FindFirstChild('leaderstats'):FindFirstChild(scoreval['Name'])
		end
	until thisScore or not entry['Player'].Parent
	
	if not entry['Player'].Parent then return end
	
	nscoretxt.Name = scoreval['Name']
	nscoretxt.Text = thisScore.Value
	if scoreval['Name'] == ScoreNames[1]['Name'] then
		debugprint('changing score')
		entry['Score'] = thisScore.Value
		if entry['Player'] == LocalPlayer then HeaderScore.Text = tostring(thisScore.Value) end
	end

	thisScore.Changed:connect(function()
		if not thisScore.Parent then return end
		if scoreval['Name'] == ScoreNames[1]['Name'] then
			
			entry['Score'] = thisScore.Value
			if entry['Player'] == LocalPlayer then HeaderScore.Text = tostring(thisScore.Value) end
		end
		nscoretxt.Text = tostring(thisScore.Value)
	end)
	return nscoretxt

end

function CreateStatTitle(statName)
	
	local ntitle = MiddleTemplate:FindFirstChild('PlayerScore'):Clone()
	ntitle.Name = statName
	ntitle.Text = statName
	-- ntitle
	if IsMaximized.Value then
		ntitle.TextTransparency = 0
	else
		ntitle.TextTransparency = 1
	end
	ntitle.Parent = StatTitles
end

function RecreateScoreColumns(ptable)
	Spawn(function()
		while AddingStatLock do debugprint ('In Adding Stat Lock2') wait(1/30) end
		AddingStatLock = true
		local Xoffset=BaseScreenXSize --current offset from left
		local MaxSizeColumn=0 --max size for this column
		
		-- foreach known leaderstat
		for j = 1, #ScoreNames,1 do
			local scoreval = ScoreNames[j]
			if scoreval['ColumnSize'] then
				MaxSizeColumn=scoreval['ColumnSize']
			else
				MaxSizeColumn=0
			end
			-- for each entry in this player table
			for i,entry in ipairs(ptable) do
				local panel = entry['Frame']
				local tplayer = entry['Player']
				-- if this panel does not have an element named after this stat
				if not panel:FindFirstChild(scoreval['Name']) then
					-- make an entry for this object
					local nentry = MakeScoreEntry(entry,scoreval,panel)
					if nentry then
						debugprint('adding '..nentry.Name..' to '..entry['Player'].Name )
						nentry.Parent = panel
						-- add score to team
						if entry['MyTeam'] and entry['MyTeam'] ~= NeutralTeam and not entry['MyTeam']['Frame']:FindFirstChild(scoreval['Name']) then
							local ntitle = nentry:Clone()
							ntitle.Parent = entry['MyTeam']['Frame']
						end
						
					end
				end
				scoreval['XOffset']=Xoffset

				if panel:FindFirstChild(scoreval['Name']) then
					MaxSizeColumn=math.max(MaxSizeColumn,panel[scoreval['Name']].TextBounds.X)
				end
			end
			-- add stat title to top bar
			if not StatTitles:FindFirstChild(scoreval['Name']) then
				CreateStatTitle(scoreval['Name'])
			end
			scoreval['ColumnSize']=MaxSizeColumn
			StatTitles[scoreval['Name'] ].Position=UDim2.new(.4+((.6/#ScoreNames)*(j-1)),0,0,0)

			Xoffset= Xoffset+SpacingPerStat+MaxSizeColumn
		end
		--print(Xoffset)
		--NEED TO TAKE INTO ACCOUNT EACH STAT SIZE
		NormalBounds = UDim2.new(0, math.max(Xoffset,NormalBounds.X.Offset), 0, 800)
		NormalPosition = UDim2.new(1 , -NormalBounds.X.Offset, NormalPosition.Y.Scale, 0)
		UpdateHeaderNameSize()
		UpdateMaximize()
		
		AddingStatLock = false
	end)
end
 ---------------------------  
 -- Minimizing and maximizing
 --------------------------- 

function ToggleMinimize()
	IsMinimized.Value = not IsMinimized.Value
end

function ToggleMaximize()
	IsMaximized.Value = not IsMaximized.Value
	
end

function Tabify()
	IsTabified.Value= true
	IsMaximized.Value=false
	IsMinimized.Value=true
	UpdateMinimize()
	IsTabified.Value= true
	ScreenGui:TweenPosition(UDim2.new(NormalBounds.X.Scale, NormalBounds.X.Offset-10, 0,0),'Out','Quad',1,true)
end

function UnTabify()
	if IsTabified.Value then
		IsTabified.Value= false
		ScreenGui:TweenPosition(UDim2.new(0, 0, 0,0),'Out','Quad',1,true)
	end
end

--[[
	Does more than it looks like
	monitors positions of the clipping frames and bottom frames
	called from EVERYWHERE
--]]
function UpdateMinimize()

	if IsMinimized.Value then
		if IsMaximized.Value then
			ToggleMaximize()
		end
		if not IsTabified.Value then
			MainFrame:TweenSizeAndPosition(UDim2.new(0.010, HeaderName.TextBounds.X, NormalBounds.Y.Scale,NormalBounds.Y.Offset),
				UDim2.new(.990, -HeaderName.TextBounds.X, NormalPosition.Y.Scale,0),'Out','Quad',1,true)
		else 
			MainFrame:TweenSizeAndPosition(NormalBounds,NormalPosition,'Out','Quad',1,true)
		end
		BottomClipFrame:TweenPosition(UDim2.new(0,0,DefaultBottomClipPos - (((GetTotalEntries()) * MiddleTemplate.Size.Y.Scale)),0), "Out", "Linear", .25,true)
		BottomFrame:TweenPosition(UDim2.new(0,0,HeaderFrameHeight,0), "Out", "Linear", .25,true)
		ExtendTab.Image = 'http://www.roblox.com/asset/?id=94692731'
	else
		if not IsMaximized.Value then
			MainFrame:TweenSizeAndPosition(NormalBounds,NormalPosition,'Out','Quad',1,true)
		end
		BottomClipFrame:TweenPosition(UDim2.new(0,0,DefaultBottomClipPos,0), "Out", "Linear", .25,true)
		BottomFrame:TweenPosition(UDim2.new(0,0,((GetTotalEntries()) * MiddleTemplate.Size.Y.Scale) + HeaderFrameHeight,0), "Out", "Linear", .25,true)
		
		ExtendTab.Image = 'http://www.roblox.com/asset/?id=94825585'
	end
end

--[[
	Manages the position/size of the mainFrame, swaps out different resolution images for the frame
	fades in and out the stat names, moves position of headername and header score
--]]
function UpdateMaximize()
	if IsMaximized.Value then
		if IsMinimized.Value then
			ToggleMinimize()
		end
		--local windowSize=ScreenGui.AbsoluteSize
		--MaximizedBounds=UDim2.new(0,windowSize.x*.8,0,(windowSize.x*.8)*.75)
		MainFrame:TweenSizeAndPosition(MaximizedBounds,MaximizedPosition,'Out','Quad',1,true)
		HeaderScore:TweenPosition(UDim2.new(0,0,HeaderName.Position.Y.Scale,0), "Out", "Linear", .25,true)
		HeaderName:TweenPosition(UDim2.new( - .1, - HeaderScore.TextBounds.x,HeaderName.Position.Y.Scale,0), "Out", "Linear", .25,true)
		HeaderFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['LargeHeader']
		BottomFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['LargeBottom']
		for index, i in ipairs(MiddleFrameBackgrounds) do
			if (index%2) ~= 1 then
				i.Background.Image = 'http://www.roblox.com/asset/?id='..Images['LargeDark']
			else
				i.Background.Image = 'http://www.roblox.com/asset/?id='..Images['LargeLight']
			end
		end
		for index, i in ipairs(MiddleFrames) do
			i.ClickListener.Size = UDim2.new(.975,0,i.ClickListener.Size.Y.Scale,0)
			for j=1, #ScoreNames,1 do
				local scoreval = ScoreNames[j]
				if i:FindFirstChild(scoreval['Name']) then
					i[scoreval['Name']]:TweenPosition(UDim2.new(.4+((.6/#ScoreNames)*(j-1)),0,0,0), "Out", "Linear", .25,true)
				end
			end
		end
		for i,entry in ipairs(PlayerFrames) do
			WaitForChild(entry['Frame'],'TitleFrame').Size=UDim2.new(.4,0,entry['Frame'].TitleFrame.Size.Y.Scale,0)
			
		end

		for index,i in pairs(StatTitles:GetChildren()) do
			Spawn(function()TweenTextTransparency(i,i.TextTransparency,0,.25) end)
			--i:TweenPosition(UDim2.new(.4+((.6/#ScoreNames)*(index-1)),0,0,0), "Out", "Linear", .25,true)
		end
		
	else
		if not IsMinimized.Value then
			MainFrame:TweenSizeAndPosition(NormalBounds,NormalPosition,'Out','Quad',1,true)
		end
		HeaderScore:TweenPosition(UDim2.new(0,0,.5,0), "Out", "Linear", .25,true)
		HeaderName:TweenPosition(UDim2.new(0,0,HeaderName.Position.Y.Scale,0), "Out", "Linear", .25,true)
		HeaderFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['NormalHeader']
		BottomFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['NormalBottom']
		for index, i in ipairs(MiddleFrameBackgrounds) do
			if index%2 ~= 1 then
				i.Background.Image = 'http://www.roblox.com/asset/?id='..Images['midDark']
			else
				i.Background.Image = 'http://www.roblox.com/asset/?id='..Images['midLight']
			end
		end
		for index, i in ipairs(MiddleFrames) do
			if i:FindFirstChild('ClickListener') then
				i.ClickListener.Size = UDim2.new(.96,0,i.ClickListener.Size.Y.Scale,0)
				for j=1, #ScoreNames,1 do
					local scoreval = ScoreNames[j]
					--print(scoreval['XOffset'])
					if i:FindFirstChild(scoreval['Name']) and scoreval['XOffset'] then
						i[scoreval['Name']]:TweenPosition(UDim2.new(0,scoreval['XOffset'],0,0), "Out", "Linear", .25,true)
					end
				end
			end
		end
		for i,entry in ipairs(PlayerFrames) do
			WaitForChild(entry['Frame'],'TitleFrame').Size=UDim2.new(0,BaseScreenXSize,entry['Frame'].TitleFrame.Size.Y.Scale,0)
			
		end
		for _,i in pairs(StatTitles:GetChildren()) do
			Spawn(function()TweenTextTransparency(i,i.TextTransparency,1,.25) end)
		end
		for i,entry in ipairs(PlayerFrames) do
			WaitForChild(entry['Frame'],'TitleFrame').Size=UDim2.new(0,BaseScreenXSize*.9,entry['Frame'].TitleFrame.Size.Y.Scale,0)
		end
	end
	
end

 ------------------------  
 -- Scroll Bar functions
 ------------------------ 
--[[
	updates whether the scroll bar should be showing, if it is showing, updates
	the size of it
--]]
function UpdateScrollBarVisibility()
	if AreAllEntriesOnScreen() then
		ScrollBar.BackgroundTransparency = 1
	else
		ScrollBar.BackgroundTransparency = 0
		UpdateScrollBarSize()
	end
end 
--[[
	updates size of scrollbar depending on how many entries exist
--]]
function UpdateScrollBarSize()
	local entryListSize = #MiddleFrameBackgrounds * MiddleTemplate.Size.Y.Scale
	local shownAreaSize = ((BottomClipFrame.Position.Y.Scale) + 1)
	ScrollBar.Size = UDim2.new(1,0,shownAreaSize/entryListSize,0)
	
end 
--[[
	updates position of listframe so that no gaps at the bottom or top of the list are visible
	updates position of scrollbar to match what parts of the list are visible
--]]
function UpdateScrollPosition()
	local minPos = GetMinScroll()
	local maxPos = GetMaxScroll()
	local scrollLength = maxPos - minPos
	
	local yscrollpos=math.max(math.min(ListFrame.Position.Y.Scale,maxPos),minPos)
	ListFrame.Position=UDim2.new(ListFrame.Position.X.Scale,ListFrame.Position.X.Offset,yscrollpos,ListFrame.Position.Y.Offset)
	
	local adjustedLength = 1 - ScrollBar.Size.Y.Scale
	ScrollBar.Position = UDim2.new(0,0,adjustedLength - (adjustedLength * ((ListFrame.Position.Y.Scale - minPos)/scrollLength)),0)
end

--[[ 
	WARNING:this is in a working state, but uses massive hacks
	revize when global input is available
	Manages scrolling of the playerlist on mouse drag
--]]
function StartDrag()
	Delay(0,function()
		debugprint('Got Click')
		local stopDrag = false
		local function dragExit() 
			debugprint('undone click') 
			stopDrag = true 
		end
		local startY = AbsoluteToPercent(Mouse.X,Mouse.Y).Y
		local StartFrame = ListFrame.Position
		local function dragpoll(nx,ny)
			local nowY = AbsoluteToPercent(nx,ny).Y
			local newFrameY = math.max(math.min(StartFrame.Y.Scale + (nowY - startY),GetMaxScroll()),GetMinScroll())
			ListFrame.Position = UDim2.new(StartFrame.X.Scale,StartFrame.X.Offset,newFrameY,StartFrame.Y.Offset)
			UpdateScrollPosition()
		end
		Spawn(function() WaitForClick(ScreenGui,dragpoll,dragExit) end)
	end)
end

 -------------------------------  
 -- Input Callback functions
 ------------------------------- 
IsMaximized.Value=false
IsMinimized.Value=false
IsMaximized.Changed:connect(UpdateMaximize)
IsMinimized.Changed:connect(UpdateMinimize)

ExtendButton.MouseButton1Click:connect(function() 
	if(time() - LastClick < ButtonCooldown) then return end
	LastClick = time()
	UnTabify()
	ToggleMinimize()
end)

MaximizeButton.MouseButton1Click:connect(function()
	if(time() - LastClick < ButtonCooldown) then return end
	LastClick = time()
	UnTabify()
	ToggleMaximize()
end)

MaximizeButton.MouseButton2Click:connect(function()
	if(time() - LastClick < ButtonCooldown) then return end
	LastClick = time()
	Tabify()
end)


-------------------------------  
-- MiddleFrames management
------------------------------- 
--[[
	adds a background frame to the listframe
--]]
function AddMiddleBGFrame()
	local nBGFrame = MiddleBGTemplate:Clone()
	nBGFrame.Position = UDim2.new(0,0,((#MiddleFrameBackgrounds) * nBGFrame.Size.Y.Scale),0)
	if (#MiddleFrameBackgrounds+1)%2 ~= 1 then
		if IsMaximized.Value then
			nBGFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['LargeDark']
		else
			nBGFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['midDark']
		end
	else
		if IsMaximized.Value then
			nBGFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['LargeLight']
		else
			nBGFrame.Background.Image = 'http://www.roblox.com/asset/?id='..Images['midLight']
		end
	end
	nBGFrame.Parent = ListFrame
	table.insert(MiddleFrameBackgrounds,nBGFrame)
	if not IsMinimized.Value  then 
 -- BottomFrame:TweenPosition(UDim2.new(0,0,((#MiddleFrameBackgrounds) * nBGFrame.Size.Y.Scale) + HeaderFrameHeight,0), "Out", "Quad", .5,true) 
		UpdateMinimize()
	end
end
--[[
	removes a background from from the listframe
--]]
function RemoveMiddleBGFrame()
	MiddleFrameBackgrounds[#MiddleFrameBackgrounds]:Destroy()
	table.remove(MiddleFrameBackgrounds,#MiddleFrameBackgrounds)
	if not IsMinimized.Value then
 -- BottomFrame:TweenPosition(UDim2.new(0,0,((#MiddleFrameBackgrounds) * MiddleTemplate.Size.Y.Scale) + HeaderFrameHeight,0), "Out", "Quad", .5)
		UpdateMinimize()
	end
end
-------------------------------  
-- Player Callback functions
------------------------------- 
local FONT_SIZES = 
{'Size8','Size9','Size10','Size11','Size12','Size14','Size24','Size36','Size48'}
--[[
	note:should probably set to something other than mainFrame.AbsoluteSize, should work for now
	if textbounds ever works on textscaled, switch to that :(
--]]
function ChangeHeaderName(nname)
	HeaderName.Text = nname
	UpdateHeaderNameSize()
end

--[[ 
	Will fit the player's name to the bounds of the header
	called on resize of the window and playedr name change events
	HACK: cannot use 'Textscaled' due to unable to find text bounds when scaled
--]]
function UpdateHeaderNameSize()
	local tHeader= HeaderName:Clone()
	tHeader.Position=UDim2.new(2,0,2,0)
	tHeader.Parent=ScreenGui
	local fSize=7 --Size24 in table
	tHeader.FontSize=FONT_SIZES[fSize]
	Delay(.2,function()
		while tHeader.TextBounds.x==0 do wait(1/30) end
		while tHeader.TextBounds.x-(NormalBounds.X.Offset) > 1 do
			fSize=fSize-1
			tHeader.FontSize=FONT_SIZES[fSize]
			wait(.2)
		end
		HeaderName.FontSize=tHeader.FontSize
		tHeader:Destroy()
	end)
end
ScreenGui.Changed:connect(UpdateHeaderNameSize)

--[[
	called only when the leaderstats object is added to a given player entry
	removes old stats, adds any existing stats, and sets up listeners for new stats
	@Args:
	playerEntry		A reference to the ENTRY(table) of the player who had leaderstats added
--]]
function LeaderstatsAdded(playerEntry)
	RemoveAllStats(playerEntry)
	local nplayer = playerEntry['Player']
	for _,i in pairs(nplayer.leaderstats:GetChildren()) do
		StatAdded(i,playerEntry)
	end
	nplayer.leaderstats.ChildAdded:connect(function(nchild) StatAdded(nchild,playerEntry) end)
	nplayer.leaderstats.ChildRemoved:connect(function(nchild) StatRemoved(nchild,playerEntry) end)
end
--[[
	called when leaderstats object is removed from play in player entry
	Note: may not be needed, might be able to just rely on leaderstats added
	@Args:
	oldLeaderstats	leaderstats object to be removed
	playerEntry		A reference to the ENTRY(table) of the player
--]]
function LeaderstatsRemoved(oldLeaderstats,playerEntry)
	while AddingFrameLock do debugprint('waiting to insert '..playerEntry['Player'].Name) wait(1/30) end 
	AddingFrameLock = true
	RemoveAllStats(playerEntry)
	AddingFrameLock = false
end

--[[
	prepares the needed movingpanel to be tweened on screen, and updates the position of the popup clip
	frame to match the selected player frame's position
	@Args:
	movingPanel		The popup panel to tween on screen
--]]
function InitMovingPanel(movingPanel)
	PopUpClipFrame.Position =  UDim2.new( 0,-PopUpClipFrame.Size.X.Offset,(SelectedPlayerEntry['Frame'].Position.Y.Scale)+HeaderFrame.Size.Y.Scale,
		(SelectedPlayerEntry['Frame'].Position.Y.Offset)+HeaderFrame.Size.Y.Offset)
	movingPanel:TweenPosition(UDim2.new(0,0,0,0), "Out", "Quad", .5,true)
	OnFriendPopUpOpen()
	if IsPersonalServer then
		HighlightMyRank(SelectedPlayer)
	end
	WaitForClick(ScreenGui,function() end,function(nx,ny)
		movingPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", .5,true)
		--connection:disconnect()
	end)
	
end

--[[
	Called when a player entry in the leaderboard is clicked
	either will highlight entry and start the drag event, or open a popup menu
	@Args:
	entry	the player entry clicked
--]]
function OnPlayerEntrySelect(entry)
	local movingPanel
	--if this is a personal server, and you are an admin and the selected person is a lower rank than you, then...
	if IsPersonalServer and LocalPlayer.PersonalServerRank >= PrivilegeLevel['Admin'] and LocalPlayer.PersonalServerRank > SelectedPlayer.PersonalServerRank then 
			--and LocalPlayer.PersonalServerRank>entry['Player'].PersonalServerRank then
		movingPanel=PersonalServerPanel
	else
		movingPanel=PopUpPanel
	end
	if entry == SelectedPlayerEntry and SelectedPlayer~=LocalPlayer then
		InPopupWaitForClick=true
		WaitForClick(ScreenGui,function() end, function()
			InitMovingPanel(movingPanel)
			SelectedPlayerEntry = nil
			inWaitForClick=false
		end)
	else
		
		--movingPanel:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", .5,true)
		SelectedPlayerEntry = entry
		SelectedPlayer = entry['Player']
		entry['Frame'].BackgroundColor3 = Color3.new(0,1,1)
		entry['Frame'].BackgroundTransparency = .5
		Spawn(function() TweenBackgroundTransparency(entry['Frame'],.5,1,1) end)
		Delay(1, function()
			if not InPopupWaitForClick then
				SelectedPlayerEntry = nil
			end
		end)
		StartDrag()
	end

	
end

--[[
	the basic update for the playerlist mode's state,
	assures the order and length of the player frames
--]]
function PlayerListModeUpdate()
	RecreateScoreColumns(PlayerFrames)
	table.sort(PlayerFrames,PlayerSortFunction)
	for i,val in ipairs(PlayerFrames) do
		MiddleFrames[i] = val['Frame']
	end
	for i = #PlayerFrames + 1,#MiddleFrames,1 do
		MiddleFrames[i] = nil
	end
	UpdateMinimize()
end
--[[
	this one's a doozie, what happens when a player is added to the game
	inits their player frame and player entry, assigns them to a team if possible,
	and hooks up their leaderstats
	@Args:
	nplayer		new player object to insert
--]]
function InsertPlayerFrame(nplayer)
	while AddingFrameLock do debugprint('waiting to insert '..nplayer.Name) wait(1/30) end 
	AddingFrameLock = true
	
	local nFrame = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nFrame,'TitleFrame'),'Title').Text = nplayer.Name
	if nplayer.Name == LocalPlayer.Name then
		nFrame.TitleFrame.Title.Font = 'ArialBold'
		nFrame.PlayerScore.Font = 'ArialBold'
		ChangeHeaderName(nplayer.Name)
	elseif LocalPlayer:IsFriendsWith(nplayer.userId) then
		nFrame.TitleFrame.Title.TextColor3 = Color3.new(251/255,253/255,116/255)
	end

	nFrame.Position = UDim2.new(1,0,((#MiddleFrames) * nFrame.Size.Y.Scale),0)
	nFrame:FindFirstChild('BCLabel').Image = getMembershipTypeIcon(nplayer.MembershipType)
	nFrame.Name = nplayer.Name
	WaitForChild(WaitForChild(nFrame,'TitleFrame'),'Title').Text = nplayer.Name
	if(nFrame:FindFirstChild('BCLabel').Image ~= '') then
		nFrame.TitleFrame.Title.Position=nFrame.TitleFrame.Title.Position+UDim2.new(0,20,0,0)
	end
	nFrame.Parent = ListFrame
	nFrame:TweenPosition(UDim2.new(0,0,((#MiddleFrames) * nFrame.Size.Y.Scale),0), "Out", "Quad", .5,true)
	UpdateMinimize()
	local nentry = {}
	nentry['Frame'] = nFrame
	nentry['Player'] = nplayer
	nentry['ID'] = AddId
	AddId = AddId + 1
	table.insert(PlayerFrames,nentry)
	if #TeamFrames~=0 then
		
		if nplayer.Neutral then
			if not NeutralTeam then AddNeutralTeam() end
			AddPlayerToTeam(NeutralTeam,nentry)
			nentry['MyTeam'] = NeutralTeam
		else
			local addedToTeam=false
			for i,tval in ipairs(TeamFrames) do
				if tval['MyTeam'].TeamColor == nplayer.TeamColor then
					AddPlayerToTeam(tval,nentry)
					nentry['MyTeam'] = tval
					addedToTeam=true
				end
			end
			if not addedToTeam then
				if not NeutralTeam then AddNeutralTeam() end
				AddPlayerToTeam(NeutralTeam,nentry)
				nentry['MyTeam'] = NeutralTeam
			end
		end
		
	end
	
	if nplayer:FindFirstChild('leaderstats') then
		LeaderstatsAdded(nentry)
	end
	
	nplayer.ChildAdded:connect(function(nchild) 
		if nchild.Name == 'leaderstats' then
			while AddingFrameLock do debugprint('in adding leaderstats lock') wait(1/30) end
			AddingFrameLock = true
			LeaderstatsAdded(nentry)
			AddingFrameLock = false
		end
	end)

	nplayer.ChildRemoved:connect(function (nchild)
		if nchild.Name == 'leaderstats' then
			LeaderstatsRemoved(nchild,nentry)
		end
	end)
	nplayer.Changed:connect(function(prop)PlayerChanged(nentry,prop) end)
	
	local listener = WaitForChild(nFrame,'ClickListener')
	listener.Active = true
	listener.MouseButton1Down:connect(function() OnPlayerEntrySelect(nentry) end)
	
	AddMiddleBGFrame()
	BaseUpdate()
	AddingFrameLock = false
end

--[[
	Note:major optimization can be done here
	removes this player's frame if it exists, calls base update
--]]
Players.ChildRemoved:connect(function(tplayer)
	while AddingFrameLock do debugprint('in removing player frame lock') wait(1/30) end 
	AddingFrameLock = true
	
	local tteam
	for i,key in ipairs(PlayerFrames) do
		if tplayer == key['Player'] then
			key['Frame']:Destroy()
			tteam=key['MyTeam']
			table.remove(PlayerFrames,i)
		end
	end
	if tteam then
		for j,tentry in ipairs(tteam['MyPlayers']) do
			if tentry['Player'] == tplayer then 
				RemovePlayerFromTeam(tteam,j) 
			end
		end
	end

	RemoveMiddleBGFrame()
	UpdateMinimize()
	BaseUpdate()
	AddingFrameLock = false
end)

----------------------------  
-- Team Callback Functions
---------------------------- 
--[[
	turns a list of team entries with sub lists of players into a single ordered
	list, in the correct order,and of the correct length
	@Args:
	tframes		the team entries to unroll
	outframes	the list to unroll these entries into
--]]
function UnrollTeams(tframes,outframes)
	local numEntries = 0
	if NeutralTeam and not NeutralTeam['IsHidden'] then
		for i,val in ipairs(NeutralTeam['MyPlayers']) do
			numEntries = numEntries + 1
			outframes[numEntries] = val['Frame']
		end
		numEntries = numEntries + 1
		outframes[numEntries] = NeutralTeam['Frame']
	end
	for i,val in ipairs(tframes) do
		if not val['IsHidden'] then
			for j,pval in ipairs(val.MyPlayers) do
				numEntries = numEntries + 1
				outframes[numEntries] = pval['Frame']
			end
			numEntries = numEntries + 1
			outframes[numEntries] = val['Frame']
		end
	end
 -- clear any additional entries from outframes
	for i = numEntries + 1,#outframes,1 do
		outframes[i] = nil
	end
end
--[[
	uses lua's table.sort to sort the teams
--]]
function TeamSortFunc(a,b)
	if a['TeamScore'] == b['TeamScore'] then
		return a['ID'] < b['ID']
	end
	if not a['TeamScore'] then return false end
	if not b['TeamScore'] then return true end
	return a['TeamScore'] < b['TeamScore']

end
--[[
	consider adding lock with wait for performance
	sorts each of the team's player lists induvidually, adds up the team scores.
	@Args:
	tentries		table of team entries	
--]]
function SortTeams(tentries)
	for i,val in ipairs(tentries) do
		RecreateScoreColumns(val['MyPlayers'])

		table.sort(val['MyPlayers'],PlayerSortFunction)
		AddTeamScores(val)
	end
	table.sort(tentries,TeamSortFunc)
end
--[[
	base update for team mode, adds up the scores of all teams, sorts them,
	then unrolls them into middleframes
--]]
function TeamListModeUpdate()
	SortTeams(TeamFrames)
	if NeutralTeam then
		AddTeamScores(NeutralTeam)
		RecreateScoreColumns(NeutralTeam['MyPlayers'])
	end
	UnrollTeams(TeamFrames,MiddleFrames)
end
--[[
	adds up all the score of this team's players to form the team score
	@Args:
	team		team entry to sum the scores of
--]]
function AddTeamScores(team)
	
	for j = 1, #ScoreNames,1 do
		local i = ScoreNames[j]
		local tscore = 0
		for _,j in ipairs(team['MyPlayers']) do
			if j['Player']:FindFirstChild('leaderstats') and j['Player'].leaderstats:FindFirstChild(i['Name']) then
				tscore = tscore + j['Player'].leaderstats[i['Name']].Value
			end
		end
		if team['Frame']:FindFirstChild(i['Name']) then
			team['Frame'][i['Name']].Size = UDim2.new(1 - (ScrollBarFrame.Size.X.Scale * 2),- ((j-1) * SpacingPerStat),TemplateFrameYSize,0)
			team['Frame'][i['Name']].Text = tostring(tscore)
		end
	end
	UpdateMinimize()
end
--[[
	currently not used, could be used to heavily optimize this script in the future
	updates only the team passed in
--]]
function UpdateSingleTeam(team)
	--[[SortTeams(TeamFrames,team)
	if(team == NeutralTeam) then
		RecreateScoreColumns(NeutralTeam['MyPlayers'])
	end
	UnrollTeams(TeamFrames,MiddleFrames)--]]
end
--[[
	finds previous team this player was on, and if it exists calls removeplayerfromteam
	@Args
	entry	Player entry
--]]
function FindRemovePlayerFromTeam(entry)
	if entry['MyTeam'] then 
		for j,oldEntry in ipairs(entry['MyTeam']['MyPlayers']) do
			if oldEntry['Player'] == entry['Player'] then
				RemovePlayerFromTeam(entry['MyTeam'],j)
				return
			end
		end
	elseif NeutralTeam then
		for j,oldEntry in ipairs(NeutralTeam['MyPlayers']) do
			if oldEntry['Player'] == entry['Player'] then
				RemovePlayerFromTeam(entry['MyTeam'],j)
				return
			end
		end
	end
end
--[[
	removes a single player from a given team (not usually called directly)
	@Args:
	teamEntry		team entry to remove player from
	index			index of player in 'MyPlayers' list to remove
--]]
function RemovePlayerFromTeam(teamEntry,index)
	table.remove(teamEntry['MyPlayers'],index)
	--if teamEntry['AutoHide'] and #teamEntry['MyPlayers'] == 0 then
	if teamEntry==NeutralTeam and #teamEntry['MyPlayers']==0 then
		teamEntry['Frame'].Parent = nil
		teamEntry['IsHidden'] = true
		NeutralTeam=nil
		RemoveMiddleBGFrame()
	end
end
--[[
	adds player entry entry to teamentry
	removes them from any previous team
	@Args:
	teamEntry		entry of team to add player to
	entry			player entry to add to this team
--]]
function AddPlayerToTeam(teamEntry,entry)
	table.insert(teamEntry['MyPlayers'],entry)
	if entry['MyTeam'] then
		FindRemovePlayerFromTeam(entry)
	end
	entry['MyTeam'] = teamEntry
	if teamEntry['IsHidden'] then
		teamEntry['Frame'].Parent = ListFrame
		AddMiddleBGFrame()
	end
	teamEntry['IsHidden'] = false
end
--[[
	Note:another big one, consiter breaking up
	called when any children of player changes
	handles 'Neutral', teamColor, Name and MembershipType changes
	@Args
	entry		Player entry changed
	property	name of property changed
--]]
function PlayerChanged(entry, property)
	if property == 'Neutral' then
 -- if player changing to neutral
		if entry['Player'].Neutral then
			FindRemovePlayerFromTeam(entry)
			AddPlayerToTeam(NeutralTeam,entry)
		else
 -- else player switching to a team, or a weird edgecase
 -- remove from neutral teams
			if NeutralTeam then
				for i,key in ipairs(NeutralTeam['MyPlayers']) do
					if key == entry then RemovePlayerFromTeam(NeutralTeam,i) end
				end
			end
 -- check to see if team exists, if it does add to that team
			local setToTeam = false
			for i,tframe in ipairs(TeamFrames) do
 -- add my entry on the new team
				if tframe['MyTeam'].TeamColor == entry['Player'].TeamColor then
					AddPlayerToTeam(tframe,entry)
					setToTeam = true
				end
			end
 -- if player was set to an invalid team, then set it back to neutral
			if not setToTeam then
				if not NeutralTeam then AddNeutralTeam() end
				AddPlayerToTeam(NeutralTeam,entry)
			end
		end
		
	end

	if property == 'TeamColor' and not entry['Player'].Neutral and entry['Player'] ~= entry['MyTeam'] then
		FindRemovePlayerFromTeam(entry)
 -- check to see if team exists, if it does add to that team
			local setToTeam = false
			for i,tframe in ipairs(TeamFrames) do
 -- add my entry on the new team
				if tframe['MyTeam'].TeamColor == entry['Player'].TeamColor then
					AddPlayerToTeam(tframe,entry)
					setToTeam = true
				end
			end
 -- if player was set to an invalid team, then set it back to neutral
			if not setToTeam then
				if not NeutralTeam then
					AddNeutralTeam()
				end
				AddPlayerToTeam(NeutralTeam,entry)
				
			end
	end
	if property == 'Name' or property == 'MembershipType' then
		entry['Frame']:FindFirstChild('BCLabel').Image = getMembershipTypeIcon(entry['Player'].MembershipType)
		entry['Frame'].Name = entry['Player'].Name
		entry['Frame'].TitleFrame.Title.Text = entry['Player'].Name
		if(entry['Frame'].BCLabel.Image ~= '') then
			entry['Frame'].TitleFrame.Title.Position=UDim2.new(.01, 20, .1, 0)
		end
		if entry['Player'] == LocalPlayer then
			ChangeHeaderName(entry['Player'].Name)
		end
	end
	BaseUpdate()
end

--[[
	adds a neutral team if nessisary
	Note: a lot of redundant code here, might want to refactor to share a function with insertteamframe
--]]
function AddNeutralTeam()
 -- while AddingFrameLock do wait() end 
 -- AddingFrameLock = true
	
	local defaultTeam = Instance.new('Team')
	defaultTeam.TeamColor = BrickColor.new('White')
	defaultTeam.Name = 'Neutral'
	local nentry = {}
	nentry['MyTeam'] = defaultTeam
	nentry['MyPlayers'] = {}
	nentry['Frame'] = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nentry['Frame'],'TitleFrame'),'Title').Text = defaultTeam.Name
	nentry['Frame'].TitleFrame.Title.Font = 'ArialBold'
	nentry['Frame'].BackgroundColor3 = defaultTeam.TeamColor.Color
	nentry['Frame'].BackgroundTransparency = .7
	nentry['Frame'].Position = UDim2.new(1,0,((#MiddleFrames) * nentry['Frame'].Size.Y.Scale),0)
	WaitForChild(nentry['Frame'],'ClickListener').MouseButton1Down:connect(StartDrag)
	nentry['AutoHide'] = true
	nentry['IsHidden'] = true
	for _,i in pairs(PlayerFrames) do
		if i['Player'].Neutral or not i['MyTeam'] then 
			AddPlayerToTeam(nentry,i)
		end
	end
	NeutralTeam = nentry
	UpdateMinimize()
	BaseUpdate()
	
 -- AddingFrameLock = false
end
--[[
	
--]]
function TeamScoreChanged(entry,nscore)
	WaitForChild(entry['Frame'],'PlayerScore').Text = tostring(nscore)
	entry['TeamScore'] = nscore
end
--[[
	called when child added to a team, used for autohide functionality
	Note: still has teamscore, consiter removing
--]]
function TeamChildAdded(entry,nchild)
	if nchild.Name == 'AutoHide' then
		entry['AutoHide'] = true
	elseif nchild.Name == 'TeamScore' then
		WaitForChild(entry['Frame'],'PlayerScore').Text = tostring(nchild.Value)
		entry['TeamScore'] = nchild.Value
		nchild.Changed:connect(function() TeamScoreChanged(entry,nchild.Value) end)
	end
end
--[[
	called when child added to a team, used for autohide functionality
	Note: still has teamscore, consiter removing
--]]
function TeamChildRemoved(entry,nchild)
	if nchild.Name == 'AutoHide' then
		entry['AutoHide'] = false
	elseif nchild.Name == 'TeamScore' then
		WaitForChild(entry['Frame'],'PlayerScore').Text = ""
		entry['TeamScore'] = nil
	end
end
--[[
	creates team entry and frame for this team, sets up listeners for this team
	adds any players intended for this team,Creates neutral team if this is the first team added
	Note:might be best to break this into multiple functions to simplify
	@Args:
	nteam	new team object added
--]]
function InsertTeamFrame(nteam) 
	while AddingFrameLock do debugprint('in adding team frame lock') wait(1/30) end 
	AddingFrameLock = true
	local nentry = {}
	nentry['MyTeam'] = nteam
	nentry['MyPlayers'] = {}
	nentry['Frame'] = MiddleTemplate:Clone()
	WaitForChild(WaitForChild(nentry['Frame'],'TitleFrame'),'Title').Text = nteam.Name
	nentry['Frame'].TitleFrame.Title.Font = 'ArialBold'
	nentry['Frame'].Position = UDim2.new(1,0,((#MiddleFrames) * nentry['Frame'].Size.Y.Scale),0)
	WaitForChild(nentry['Frame'],'ClickListener').MouseButton1Down:connect(StartDrag)
	nentry['Frame'].ClickListener.BackgroundColor3 = nteam.TeamColor.Color
	nentry['Frame'].ClickListener.BackgroundTransparency = .7
	AddId = AddId + 1
	nentry['ID'] = AddId
	nentry['AutoHide'] = false
	if nteam:FindFirstChild('AutoHide') then
		nentry['AutoHide'] = true
	end
	if nteam:FindFirstChild('TeamScore') then
		TeamChildAdded(nentry,nteam.TeamScore)
		
	end
	nteam.ChildAdded:connect(function(nchild) TeamChildAdded(nentry,nchild) end)
	nteam.ChildRemoved:connect(function(nchild) TeamChildRemoved(nentry,nchild) end)

	for _,i in pairs(PlayerFrames) do
		if not i['Player'].Neutral and i['Player'].TeamColor == nteam.TeamColor then 
			AddPlayerToTeam(nentry,i) 
		end
	end
	nentry['IsHidden'] = false
	if not nentry['AutoHide'] or #nentry['MyPlayers'] > 0 then
		
		nentry['Frame'].Parent = ListFrame
		nentry['Frame']:TweenPosition(UDim2.new(0,0,((#MiddleFrames) * nentry['Frame'].Size.Y.Scale),0), "Out", "Quad", .5,true)
		AddMiddleBGFrame()
	else
		nentry['IsHidden'] = true
		nentry['Frame'].Parent = nil
	end

	table.insert(TeamFrames,nentry)
	UpdateMinimize()
	BaseUpdate()
	if #TeamFrames == 1 then
		AddNeutralTeam()
	end
	AddingFrameLock = false
end
--[[
	removes team from team list
	WARNING:currently non-functional, but doesnt work in old playerlist either :/
	@Args:
	nteam		Teamobject to remove
--]]
function RemoveTeamFrame(nteam)
	while AddingFrameLock do debugprint('in removing team frame lock') wait(1/30) end 
	AddingFrameLock = true
	if IsMinimized.Value then
 -- ListFrame.Position = ListFrame.Position + UDim2.new(0,0,MiddleTemplate.Size.Y.Scale,0)
	end
	local myEntry
	for i,key in ipairs(TeamFrames) do
		if nteam == key['MyTeam'] then
			myEntry = key
			key['Frame']:Destroy()
			table.remove(TeamFrames,i)
		end
	end
	for i,key in ipairs(myEntry['MyPlayers']) do
		RemovePlayerFromTeam(myEntry,i) 
		PlayerChanged(key, 'TeamColor')
	end
	RemoveMiddleBGFrame()
	BaseUpdate()
	AddingFrameLock = false
end

function TeamAdded(nteam)
	InsertTeamFrame(nteam)
end

function TeamRemoved(nteam)
	RemoveTeamFrame(nteam)
end
 --------------------------------- 
--[[
	called when ANYTHING changes the state of the playerlist
	re-sorts everything,assures correct positions of all elements
--]]
function BaseUpdate()
	while BaseUpdateLock do debugprint('in baseupdate lock') wait(1/30) end
	BaseUpdateLock = true
	if #TeamFrames == 0 then
		PlayerListModeUpdate()
	else
		TeamListModeUpdate()
	end
	for i,key in ipairs(MiddleFrames) do
		if key.Parent ~= nil then
			key:TweenPosition(UDim2.new(0,0,((#MiddleFrames - (i)) * key.Size.Y.Scale),0), "Out", "Quad", .9,true)
		end
	end
	if not IsMinimized.Value and #MiddleFrames>DefaultEntriesOnScreen then
		UpdateScrollPosition()
	end
	UpdateScrollBarVisibility()
	BaseUpdateLock = false
end

--[[
	code for attaching tab key to maximizing player list
--]]
game.GuiService:AddKey("\t")
local LastTabTime = time()
game.GuiService.KeyPressed:connect(
function(key)
	if key == "\t" then
		debugprint('caught tab key')
		local modalCheck, isModal = pcall(function() return game.GuiService.IsModalDialog end)
		if modalCheck == false or (modalCheck and isModal == false) then
			if time() - LastTabTime > 0.4 then
				LastTabTime = time()
				ToggleMaximize()
			end
		end
	end
end)

 ----------------------------  
 -- Hookups and initialization
 ----------------------------  
 
while not game:GetService('Teams') do wait(1/30) debugprint('Waiting For Teams') end
for _,i in pairs(game.Teams:GetTeams()) do TeamAdded(i) end
for _,i in pairs(Players:GetPlayers()) do InsertPlayerFrame(i) end

game.Teams.ChildAdded:connect(TeamAdded)
game.Teams.ChildRemoved:connect(TeamRemoved)
Players.ChildAdded:connect(InsertPlayerFrame)

InitReportAbuse()

BaseUpdate()


--UGGGLY,find a better way later
wait(2)
IsPersonalServer= not not game.Workspace:FindFirstChild("PSVariable")

 ----------------------------  
 -- Running Logic
 ---------------------------- 

 --no running logic WOOHOO!
