local t = {}

local function ScopedConnect(parentInstance, instance, event, signalFunc, syncFunc, removeFunc)
	local eventConnection = nil

	--Connection on parentInstance is scoped by parentInstance (when destroyed, it goes away)
	local tryConnect = function()
		if game:IsAncestorOf(parentInstance) then
			--Entering the world, make sure we are connected/synced
			if not eventConnection then
				eventConnection = instance[event]:connect(signalFunc)
				if syncFunc then syncFunc() end
			end
		else
			--Probably leaving the world, so disconnect for now
			if eventConnection then
				eventConnection:disconnect()
				if removeFunc then removeFunc() end
			end
		end
	end

	--Hook it up to ancestryChanged signal
	local connection = parentInstance.AncestryChanged:connect(tryConnect)
	
	--Now connect us if we're already in the world
	tryConnect()
	
	return connection
end

local function getScreenGuiAncestor(instance)
	local localInstance = instance
	while localInstance and not localInstance:IsA("ScreenGui") do
		localInstance = localInstance.Parent
	end
	return localInstance
end

local function CreateButtons(frame, buttons, yPos, ySize)
	local buttonNum = 1
	local buttonObjs = {}
	for i, obj in ipairs(buttons) do 
		local button = Instance.new("TextButton")
		button.Name = "Button" .. buttonNum
		button.Font = Enum.Font.Arial
		button.FontSize = Enum.FontSize.Size18
		button.AutoButtonColor = true
		if obj["Style"] then
			button.Style = obj.Style
		else
			button.Style = Enum.ButtonStyle.RobloxButton
		end
		button.Text = obj.Text
		button.TextColor3 = Color3.new(1,1,1)
		button.MouseButton1Click:connect(obj.Function)
		button.Parent = frame
		buttonObjs[buttonNum] = button

		buttonNum = buttonNum + 1
	end
	local numButtons = buttonNum-1

	if numButtons == 1 then
		frame.Button1.Position = UDim2.new(0.35, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(.4,0,ySize.Scale, ySize.Offset)
	elseif numButtons == 2 then
		frame.Button1.Position = UDim2.new(0.1, 0, yPos.Scale, yPos.Offset)
		frame.Button1.Size = UDim2.new(.8/3,0, ySize.Scale, ySize.Offset)

		frame.Button2.Position = UDim2.new(0.55, 0, yPos.Scale, yPos.Offset)
		frame.Button2.Size = UDim2.new(.35,0, ySize.Scale, ySize.Offset)
	elseif numButtons >= 3 then
		local spacing = .1 / numButtons
		local buttonSize = .9 / numButtons

		buttonNum = 1
		while buttonNum <= numButtons do
			buttonObjs[buttonNum].Position = UDim2.new(spacing*buttonNum + (buttonNum-1) * buttonSize, 0, yPos.Scale, yPos.Offset)
			buttonObjs[buttonNum].Size = UDim2.new(buttonSize, 0, ySize.Scale, ySize.Offset)
			buttonNum = buttonNum + 1
		end
	end
end

local function setSliderPos(newAbsPosX,slider,sliderPosition,bar,steps)

	local newStep = steps - 1 --otherwise we really get one more step than we want
	local relativePosX = math.min(1, math.max(0, (newAbsPosX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X ))
	local wholeNum, remainder = math.modf(relativePosX * newStep)
	if remainder > 0.5 then
		wholeNum = wholeNum + 1
	end
	relativePosX = wholeNum/newStep

	local result = math.ceil(relativePosX * newStep)
	if sliderPosition.Value ~= (result + 1) then --only update if we moved a step
		sliderPosition.Value = result + 1
		slider.Position = UDim2.new(relativePosX,-slider.AbsoluteSize.X/2,slider.Position.Y.Scale,slider.Position.Y.Offset)
	end
	
end

local function cancelSlide(areaSoak)
	areaSoak.Visible = false
	if areaSoakMouseMoveCon then areaSoakMouseMoveCon:disconnect() end
end

t.CreateStyledMessageDialog = function(title, message, style, buttons)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.5, 0, 0, 165)
	frame.Position = UDim2.new(0.25, 0, 0.5, -72.5)
	frame.Name = "MessageDialog"
	frame.Active = true
	frame.Style = Enum.FrameStyle.RobloxRound	
	
	local styleImage = Instance.new("ImageLabel")
	styleImage.Name = "StyleImage"
	styleImage.BackgroundTransparency = 1
	styleImage.Position = UDim2.new(0,5,0,15)
	if style == "error" or style == "Error" then
		styleImage.Size = UDim2.new(0, 71, 0, 71)
		styleImage.Image = "http://www.roblox.com/asset?id=42565285"
	elseif style == "notify" or style == "Notify" then
		styleImage.Size = UDim2.new(0, 71, 0, 71)
		styleImage.Image = "http://www.roblox.com/asset?id=42604978"
	elseif style == "confirm" or style == "Confirm" then
		styleImage.Size = UDim2.new(0, 74, 0, 76)
		styleImage.Image = "http://www.roblox.com/asset?id=42557901"
	else
		return t.CreateMessageDialog(title,message,buttons)
	end
	styleImage.Parent = frame
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Text = title
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.new(221/255,221/255,221/255)
	titleLabel.Position = UDim2.new(0, 80, 0, 0)
	titleLabel.Size = UDim2.new(1, -80, 0, 40)
	titleLabel.Font = Enum.Font.ArialBold
	titleLabel.FontSize = Enum.FontSize.Size36
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = frame

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Text = message
	messageLabel.TextColor3 = Color3.new(221/255,221/255,221/255)
	messageLabel.Position = UDim2.new(0.025, 80, 0, 45)
	messageLabel.Size = UDim2.new(0.95, -80, 0, 55)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Font = Enum.Font.Arial
	messageLabel.FontSize = Enum.FontSize.Size18
	messageLabel.TextWrap = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.Parent = frame

	CreateButtons(frame, buttons, UDim.new(0, 105), UDim.new(0, 40) )

	return frame
end

t.CreateMessageDialog = function(title, message, buttons)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.5, 0, 0.5, 0)
	frame.Position = UDim2.new(0.25, 0, 0.25, 0)
	frame.Name = "MessageDialog"
	frame.Active = true
	frame.Style = Enum.FrameStyle.RobloxRound

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Text = title
	titleLabel.BackgroundTransparency = 1
	titleLabel.TextColor3 = Color3.new(221/255,221/255,221/255)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
	titleLabel.Font = Enum.Font.ArialBold
	titleLabel.FontSize = Enum.FontSize.Size36
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = frame

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Text = message
	messageLabel.TextColor3 = Color3.new(221/255,221/255,221/255)
	messageLabel.Position = UDim2.new(0.025, 0, 0.175, 0)
	messageLabel.Size = UDim2.new(0.95, 0, .55, 0)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Font = Enum.Font.Arial
	messageLabel.FontSize = Enum.FontSize.Size18
	messageLabel.TextWrap = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.Parent = frame

	CreateButtons(frame, buttons, UDim.new(0.8,0), UDim.new(0.15, 0))

	return frame
end

t.CreateDropDownMenu = function(items, onSelect, forRoblox)
	local width = UDim.new(0, 100)
	local height = UDim.new(0, 32)

	local xPos = 0.055
	local frame = Instance.new("Frame")
	frame.Name = "DropDownMenu"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(width, height)

	local dropDownMenu = Instance.new("TextButton")
	dropDownMenu.Name = "DropDownMenuButton"
	dropDownMenu.TextWrap = true
	dropDownMenu.TextColor3 = Color3.new(1,1,1)
	dropDownMenu.Text = "Choose One"
	dropDownMenu.Font = Enum.Font.ArialBold
	dropDownMenu.FontSize = Enum.FontSize.Size18
	dropDownMenu.TextXAlignment = Enum.TextXAlignment.Left
	dropDownMenu.TextYAlignment = Enum.TextYAlignment.Center
	dropDownMenu.BackgroundTransparency = 1
	dropDownMenu.AutoButtonColor = true
	dropDownMenu.Style = Enum.ButtonStyle.RobloxButton
	dropDownMenu.Size = UDim2.new(1,0,1,0)
	dropDownMenu.Parent = frame
	dropDownMenu.ZIndex = 2

	local dropDownIcon = Instance.new("ImageLabel")
	dropDownIcon.Name = "Icon"
	dropDownIcon.Active = false
	dropDownIcon.Image = "http://www.roblox.com/asset/?id=45732894"
	dropDownIcon.BackgroundTransparency = 1
	dropDownIcon.Size = UDim2.new(0,11,0,6)
	dropDownIcon.Position = UDim2.new(1,-11,0.5, -2)
	dropDownIcon.Parent = dropDownMenu
	dropDownIcon.ZIndex = 2
	
	local itemCount = #items
	local dropDownItemCount = #items
	local useScrollButtons = false
	if dropDownItemCount > 6 then
		useScrollButtons = true
		dropDownItemCount = 6
	end
	
	local droppedDownMenu = Instance.new("TextButton")
	droppedDownMenu.Name = "List"
	droppedDownMenu.Text = ""
	droppedDownMenu.BackgroundTransparency = 1
	--droppedDownMenu.AutoButtonColor = true
	droppedDownMenu.Style = Enum.ButtonStyle.RobloxButton
	droppedDownMenu.Visible = false
	droppedDownMenu.Active = true	--Blocks clicks
	droppedDownMenu.Position = UDim2.new(0,0,0,0)
	droppedDownMenu.Size = UDim2.new(1,0, (1 + dropDownItemCount)*.8, 0)
	droppedDownMenu.Parent = frame
	droppedDownMenu.ZIndex = 2

	local choiceButton = Instance.new("TextButton")
	choiceButton.Name = "ChoiceButton"
	choiceButton.BackgroundTransparency = 1
	choiceButton.BorderSizePixel = 0
	choiceButton.Text = "ReplaceMe"
	choiceButton.TextColor3 = Color3.new(1,1,1)
	choiceButton.TextXAlignment = Enum.TextXAlignment.Left
	choiceButton.TextYAlignment = Enum.TextYAlignment.Center
	choiceButton.BackgroundColor3 = Color3.new(1, 1, 1)
	choiceButton.Font = Enum.Font.Arial
	choiceButton.FontSize = Enum.FontSize.Size18
	if useScrollButtons then
		choiceButton.Size = UDim2.new(1,-13, .8/((dropDownItemCount + 1)*.8),0) 
	else
		choiceButton.Size = UDim2.new(1, 0, .8/((dropDownItemCount + 1)*.8),0) 
	end
	choiceButton.TextWrap = true
	choiceButton.ZIndex = 2

	local dropDownSelected = false

	local scrollUpButton 
	local scrollDownButton
	local scrollMouseCount = 0

	local setZIndex = function(baseZIndex)
		droppedDownMenu.ZIndex = baseZIndex +1
		if scrollUpButton then
			scrollUpButton.ZIndex = baseZIndex + 3
		end
		if scrollDownButton then
			scrollDownButton.ZIndex = baseZIndex + 3
		end
		
		local children = droppedDownMenu:GetChildren()
		if children then
			for i, child in ipairs(children) do
				if child.Name == "ChoiceButton" then
					child.ZIndex = baseZIndex + 2
				elseif child.Name == "ClickCaptureButton" then
					child.ZIndex = baseZIndex
				end
			end
		end
	end

	local scrollBarPosition = 1
	local updateScroll = function()
		if scrollUpButton then
			scrollUpButton.Active = scrollBarPosition > 1 
		end
		if scrollDownButton then
			scrollDownButton.Active = scrollBarPosition + dropDownItemCount <= itemCount 
		end

		local children = droppedDownMenu:GetChildren()
		if not children then return end

		local childNum = 1			
		for i, obj in ipairs(children) do
			if obj.Name == "ChoiceButton" then
				if childNum < scrollBarPosition or childNum >= scrollBarPosition + dropDownItemCount then
					obj.Visible = false
				else
					obj.Position = UDim2.new(0,0,((childNum-scrollBarPosition+1)*.8)/((dropDownItemCount+1)*.8),0)
					obj.Visible = true
				end
				obj.TextColor3 = Color3.new(1,1,1)
				obj.BackgroundTransparency = 1

				childNum = childNum + 1
			end
		end
	end
	local toggleVisibility = function()
		dropDownSelected = not dropDownSelected

		dropDownMenu.Visible = not dropDownSelected
		droppedDownMenu.Visible = dropDownSelected
		if dropDownSelected then
			setZIndex(4)
		else
			setZIndex(2)
		end
		if useScrollButtons then
			updateScroll()
		end
	end
	droppedDownMenu.MouseButton1Click:connect(toggleVisibility)

	local updateSelection = function(text)
		local foundItem = false
		local children = droppedDownMenu:GetChildren()
		local childNum = 1
		if children then
			for i, obj in ipairs(children) do
				if obj.Name == "ChoiceButton" then
					if obj.Text == text then
						obj.Font = Enum.Font.ArialBold
						foundItem = true			
						scrollBarPosition = childNum
					else
						obj.Font = Enum.Font.Arial
					end
					childNum = childNum + 1
				end
			end
		end
		if not text then
			dropDownMenu.Text = "Choose One"
			scrollBarPosition = 1
		else
			if not foundItem then
				error("Invalid Selection Update -- " .. text)
			end

			if scrollBarPosition + dropDownItemCount > itemCount + 1 then
				scrollBarPosition = itemCount - dropDownItemCount + 1
			end

			dropDownMenu.Text = text
		end
	end
	
	local function scrollDown()
		if scrollBarPosition + dropDownItemCount <= itemCount then
			scrollBarPosition = scrollBarPosition + 1
			updateScroll()
			return true
		end
		return false
	end
	local function scrollUp()
		if scrollBarPosition > 1 then
			scrollBarPosition = scrollBarPosition - 1
			updateScroll()
			return true
		end
		return false
	end
	
	if useScrollButtons then
		--Make some scroll buttons
		scrollUpButton = Instance.new("ImageButton")
		scrollUpButton.Name = "ScrollUpButton"
		scrollUpButton.BackgroundTransparency = 1
		scrollUpButton.Image = "rbxasset://textures/ui/scrollbuttonUp.png"
		scrollUpButton.Size = UDim2.new(0,17,0,17) 
		scrollUpButton.Position = UDim2.new(1,-11,(1*.8)/((dropDownItemCount+1)*.8),0)
		scrollUpButton.MouseButton1Click:connect(
			function()
				scrollMouseCount = scrollMouseCount + 1
			end)
		scrollUpButton.MouseLeave:connect(
			function()
				scrollMouseCount = scrollMouseCount + 1
			end)
		scrollUpButton.MouseButton1Down:connect(
			function()
				scrollMouseCount = scrollMouseCount + 1
	
				scrollUp()
				local val = scrollMouseCount
				wait(0.5)
				while val == scrollMouseCount do
					if scrollUp() == false then
						break
					end
					wait(0.1)
				end				
			end)

		scrollUpButton.Parent = droppedDownMenu

		scrollDownButton = Instance.new("ImageButton")
		scrollDownButton.Name = "ScrollDownButton"
		scrollDownButton.BackgroundTransparency = 1
		scrollDownButton.Image = "rbxasset://textures/ui/scrollbuttonDown.png"
		scrollDownButton.Size = UDim2.new(0,17,0,17) 
		scrollDownButton.Position = UDim2.new(1,-11,1,-11)
		scrollDownButton.Parent = droppedDownMenu
		scrollDownButton.MouseButton1Click:connect(
			function()
				scrollMouseCount = scrollMouseCount + 1
			end)
		scrollDownButton.MouseLeave:connect(
			function()
				scrollMouseCount = scrollMouseCount + 1
			end)
		scrollDownButton.MouseButton1Down:connect(
			function()
				scrollMouseCount = scrollMouseCount + 1

				scrollDown()
				local val = scrollMouseCount
				wait(0.5)
				while val == scrollMouseCount do
					if scrollDown() == false then
						break
					end
					wait(0.1)
				end				
			end)	

		local scrollbar = Instance.new("ImageLabel")
		scrollbar.Name = "ScrollBar"
		scrollbar.Image = "rbxasset://textures/ui/scrollbar.png"
		scrollbar.BackgroundTransparency = 1
		scrollbar.Size = UDim2.new(0, 18, (dropDownItemCount*.8)/((dropDownItemCount+1)*.8), -(17) - 11 - 4)
		scrollbar.Position = UDim2.new(1,-11,(1*.8)/((dropDownItemCount+1)*.8),17+2)
		scrollbar.Parent = droppedDownMenu
	end

	for i,item in ipairs(items) do
		-- needed to maintain local scope for items in event listeners below
		local button = choiceButton:clone()
		if forRoblox then
			button.RobloxLocked = true
		end		
		button.Text = item
		button.Parent = droppedDownMenu
		button.MouseButton1Click:connect(function()
			--Remove Highlight
			button.TextColor3 = Color3.new(1,1,1)
			button.BackgroundTransparency = 1

			updateSelection(item)
			onSelect(item)

			toggleVisibility()
		end)
		button.MouseEnter:connect(function()
			--Add Highlight	
			button.TextColor3 = Color3.new(0,0,0)
			button.BackgroundTransparency = 0
		end)

		button.MouseLeave:connect(function()
			--Remove Highlight
			button.TextColor3 = Color3.new(1,1,1)
			button.BackgroundTransparency = 1
		end)
	end

	--This does the initial layout of the buttons	
	updateScroll()

	local bigFakeButton = Instance.new("TextButton")
	bigFakeButton.BackgroundTransparency = 1
	bigFakeButton.Name = "ClickCaptureButton"
	bigFakeButton.Size = UDim2.new(0, 4000, 0, 3000)
	bigFakeButton.Position = UDim2.new(0, -2000, 0, -1500)
	bigFakeButton.ZIndex = 1
	bigFakeButton.Text = ""
	bigFakeButton.Parent = droppedDownMenu
	bigFakeButton.MouseButton1Click:connect(toggleVisibility)

	dropDownMenu.MouseButton1Click:connect(toggleVisibility)
	return frame, updateSelection
end

t.CreatePropertyDropDownMenu = function(instance, property, enum)

	local items = enum:GetEnumItems()
	local names = {}
	local nameToItem = {}
	for i,obj in ipairs(items) do
		names[i] = obj.Name
		nameToItem[obj.Name] = obj
	end

	local frame
	local updateSelection
	frame, updateSelection = t.CreateDropDownMenu(names, function(text) instance[property] = nameToItem[text] end)

	ScopedConnect(frame, instance, "Changed", 
		function(prop)
			if prop == property then
				updateSelection(instance[property].Name)
			end
		end,
		function()
			updateSelection(instance[property].Name)
		end)

	return frame
end

t.GetFontHeight = function(font, fontSize)
	if font == nil or fontSize == nil then
		error("Font and FontSize must be non-nil")
	end

	if font == Enum.Font.Legacy then
		if fontSize == Enum.FontSize.Size8 then
			return 12
		elseif fontSize == Enum.FontSize.Size9 then
			return 14
		elseif fontSize == Enum.FontSize.Size10 then
			return 15
		elseif fontSize == Enum.FontSize.Size11 then
			return 17
		elseif fontSize == Enum.FontSize.Size12 then
			return 18
		elseif fontSize == Enum.FontSize.Size14 then
			return 21
		elseif fontSize == Enum.FontSize.Size18 then
			return 27
		elseif fontSize == Enum.FontSize.Size24 then
			return 36
		elseif fontSize == Enum.FontSize.Size36 then
			return 54
		elseif fontSize == Enum.FontSize.Size48 then
			return 72
		else
			error("Unknown FontSize")
		end
	elseif font == Enum.Font.Arial or font == Enum.Font.ArialBold then
		if fontSize == Enum.FontSize.Size8 then
			return 8
		elseif fontSize == Enum.FontSize.Size9 then
			return 9
		elseif fontSize == Enum.FontSize.Size10 then
			return 10
		elseif fontSize == Enum.FontSize.Size11 then
			return 11
		elseif fontSize == Enum.FontSize.Size12 then
			return 12
		elseif fontSize == Enum.FontSize.Size14 then
			return 14
		elseif fontSize == Enum.FontSize.Size18 then
			return 18
		elseif fontSize == Enum.FontSize.Size24 then
			return 24
		elseif fontSize == Enum.FontSize.Size36 then
			return 36
		elseif fontSize == Enum.FontSize.Size48 then
			return 48
		else
			error("Unknown FontSize")
		end
	else
		error("Unknown Font " .. font)
	end
end

local function layoutGuiObjectsHelper(frame, guiObjects, settingsTable)
	local totalPixels = frame.AbsoluteSize.Y
	local pixelsRemaining = frame.AbsoluteSize.Y
	for i, child in ipairs(guiObjects) do
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			local isLabel = child:IsA("TextLabel")
			if isLabel then
				pixelsRemaining = pixelsRemaining - settingsTable["TextLabelPositionPadY"]
			else
				pixelsRemaining = pixelsRemaining - settingsTable["TextButtonPositionPadY"]
			end
			child.Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, totalPixels - pixelsRemaining)
			child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, pixelsRemaining)

			if child.TextFits and child.TextBounds.Y < pixelsRemaining then
				child.Visible = true
				if isLabel then
					child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, child.TextBounds.Y + settingsTable["TextLabelSizePadY"])
				else 
					child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, child.TextBounds.Y + settingsTable["TextButtonSizePadY"])
				end

				while not child.TextFits do
					child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, child.AbsoluteSize.Y + 1)
				end
				pixelsRemaining = pixelsRemaining - child.AbsoluteSize.Y		

				if isLabel then
					pixelsRemaining = pixelsRemaining - settingsTable["TextLabelPositionPadY"]
				else
					pixelsRemaining = pixelsRemaining - settingsTable["TextButtonPositionPadY"]
				end
			else
				child.Visible = false
				pixelsRemaining = -1
			end			

		else
			--GuiObject
			child.Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, totalPixels - pixelsRemaining)
			pixelsRemaining = pixelsRemaining - child.AbsoluteSize.Y
			child.Visible = (pixelsRemaining >= 0)
		end
	end
end

t.LayoutGuiObjects = function(frame, guiObjects, settingsTable)
	if not frame:IsA("GuiObject") then
		error("Frame must be a GuiObject")
	end
	for i, child in ipairs(guiObjects) do
		if not child:IsA("GuiObject") then
			error("All elements that are layed out must be of type GuiObject")
		end
	end

	if not settingsTable then
		settingsTable = {}
	end

	if not settingsTable["TextLabelSizePadY"] then
		settingsTable["TextLabelSizePadY"] = 0
	end
	if not settingsTable["TextLabelPositionPadY"] then
		settingsTable["TextLabelPositionPadY"] = 0
	end
	if not settingsTable["TextButtonSizePadY"] then
		settingsTable["TextButtonSizePadY"] = 12
	end
	if not settingsTable["TextButtonPositionPadY"] then
		settingsTable["TextButtonPositionPadY"] = 2
	end

	--Wrapper frame takes care of styled objects
	local wrapperFrame = Instance.new("Frame")
	wrapperFrame.Name = "WrapperFrame"
	wrapperFrame.BackgroundTransparency = 1
	wrapperFrame.Size = UDim2.new(1,0,1,0)
	wrapperFrame.Parent = frame

	for i, child in ipairs(guiObjects) do
		child.Parent = wrapperFrame
	end

	local recalculate = function()
		wait()
		layoutGuiObjectsHelper(wrapperFrame, guiObjects, settingsTable)
	end
	
	frame.Changed:connect(
		function(prop)
			if prop == "AbsoluteSize" then
				--Wait a heartbeat for it to sync in
				recalculate(nil)
			end
		end)
	frame.AncestryChanged:connect(recalculate)

	layoutGuiObjectsHelper(wrapperFrame, guiObjects, settingsTable)
end


t.CreateSlider = function(steps,width,position)
	local sliderGui = Instance.new("Frame")
	sliderGui.Size = UDim2.new(1,0,1,0)
	sliderGui.BackgroundTransparency = 1
	sliderGui.Name = "SliderGui"
	
	local areaSoak = Instance.new("TextButton")
	areaSoak.Name = "AreaSoak"
	areaSoak.Text = ""
	areaSoak.BackgroundTransparency = 1
	areaSoak.Active = false
	areaSoak.Size = UDim2.new(1,0,1,0)
	areaSoak.Visible = false
	areaSoak.ZIndex = 4
	
	sliderGui.AncestryChanged:connect(function(child,parent)
		if parent == nil then
			areaSoak.Parent = nil
		else
			areaSoak.Parent = getScreenGuiAncestor(sliderGui)
		end
	end)
	
	local sliderPosition = Instance.new("IntValue")
	sliderPosition.Name = "SliderPosition"
	sliderPosition.Value = 0
	sliderPosition.Parent = sliderGui
	
	local id = math.random(1,100)
	
	local bar = Instance.new("TextButton")
	bar.Text = ""
	bar.AutoButtonColor = false
	bar.Name = "Bar"
	bar.BackgroundColor3 = Color3.new(0,0,0)
	if type(width) == "number" then
		bar.Size = UDim2.new(0,width,0,5)
	else
		bar.Size = UDim2.new(0,200,0,5)
	end
	bar.BorderColor3 = Color3.new(95/255,95/255,95/255)
	bar.ZIndex = 2
	bar.Parent = sliderGui
	
	if position["X"] and position["X"]["Scale"] and position["X"]["Offset"] and position["Y"] and position["Y"]["Scale"] and position["Y"]["Offset"] then
		bar.Position = position
	end
	
	local slider = Instance.new("ImageButton")
	slider.Name = "Slider"
	slider.BackgroundTransparency = 1
	slider.Image = "rbxasset://textures/ui/Slider.png"
	slider.Position = UDim2.new(0,0,0.5,-10)
	slider.Size = UDim2.new(0,20,0,20)
	slider.ZIndex = 3
	slider.Parent = bar
	
	local areaSoakMouseMoveCon = nil
	
	areaSoak.MouseLeave:connect(function()
		if areaSoak.Visible then
			cancelSlide(areaSoak)
		end
	end)
	areaSoak.MouseButton1Up:connect(function()
		if areaSoak.Visible then
			cancelSlide(areaSoak)
		end
	end)
	
	slider.MouseButton1Down:connect(function()
		areaSoak.Visible = true
		if areaSoakMouseMoveCon then areaSoakMouseMoveCon:disconnect() end
		areaSoakMouseMoveCon = areaSoak.MouseMoved:connect(function(x,y)
			setSliderPos(x,slider,sliderPosition,bar,steps)
		end)
	end)
	
	slider.MouseButton1Up:connect(function() cancelSlide(areaSoak) end)
	
	sliderPosition.Changed:connect(function(prop)
		sliderPosition.Value = math.min(steps, math.max(1,sliderPosition.Value))
		local relativePosX = (sliderPosition.Value - 1) / (steps - 1)
		slider.Position = UDim2.new(relativePosX,-slider.AbsoluteSize.X/2,slider.Position.Y.Scale,slider.Position.Y.Offset)
	end)
	
	bar.MouseButton1Down:connect(function(x,y)
		setSliderPos(x,slider,sliderPosition,bar,steps)
	end)
	
	return sliderGui, sliderPosition

end

t.CreateTrueScrollingFrame = function()
	local lowY = nil
	local highY = nil
	
	local dragCon = nil
	local upCon = nil
	
	local fixScrollingAreaCon = nil

	local scrollingFrame = Instance.new("Frame")
	scrollingFrame.Name = "ScrollingFrame"
	scrollingFrame.Active = true
	scrollingFrame.Size = UDim2.new(1,0,1,0)
	scrollingFrame.ClipsDescendants = true

	local controlFrame = Instance.new("Frame")
	controlFrame.Name = "ControlFrame"
	controlFrame.BackgroundTransparency = 1
	controlFrame.Size = UDim2.new(0,18,1,0)
	controlFrame.Position = UDim2.new(1,-20,0,0)
	controlFrame.Parent = scrollingFrame
	
	local scrollBottom = Instance.new("BoolValue")
	scrollBottom.Value = false
	scrollBottom.Name = "ScrollBottom"
	scrollBottom.Parent = controlFrame
	
	local scrollUp = Instance.new("BoolValue")
	scrollUp.Value = false
	scrollUp.Name = "scrollUp"
	scrollUp.Parent = controlFrame

	local scrollUpButton = Instance.new("TextButton")
	scrollUpButton.Name = "ScrollUpButton"
	scrollUpButton.Text = ""
	scrollUpButton.AutoButtonColor = false
	scrollUpButton.BackgroundColor3 = Color3.new(0,0,0)
	scrollUpButton.BorderColor3 = Color3.new(1,1,1)
	scrollUpButton.BackgroundTransparency = 0.5
	scrollUpButton.Size = UDim2.new(0,18,0,18)
	scrollUpButton.ZIndex = 2
	scrollUpButton.Parent = controlFrame
	for i = 1, 6 do
		local triFrame = Instance.new("Frame")
		triFrame.BorderColor3 = Color3.new(1,1,1)
		triFrame.Name = "tri" .. tostring(i)
		triFrame.ZIndex = 3
		triFrame.BackgroundTransparency = 0.5
		triFrame.Size = UDim2.new(0,12 - ((i -1) * 2),0,0)
		triFrame.Position = UDim2.new(0,3 + (i -1),0.5,2 - (i -1))
		triFrame.Parent = scrollUpButton
	end
	scrollUpButton.MouseEnter:connect(function()
		scrollUpButton.BackgroundTransparency = 0.1
		local upChildren = scrollUpButton:GetChildren()
		for i = 1, #upChildren do
			upChildren[i].BackgroundTransparency = 0.1
		end
	end)
	scrollUpButton.MouseLeave:connect(function()
		scrollUpButton.BackgroundTransparency = 0.5
		local upChildren = scrollUpButton:GetChildren()
		for i = 1, #upChildren do
			upChildren[i].BackgroundTransparency = 0.5
		end
	end)

	local scrollDownButton = scrollUpButton:clone()
	scrollDownButton.Name = "ScrollDownButton"
	scrollDownButton.Position = UDim2.new(0,0,1,-18)
	local downChildren = scrollDownButton:GetChildren()
	for i = 1, #downChildren do
		downChildren[i].Position = UDim2.new(0,3 + (i -1),0.5,-2 + (i - 1))
	end
	scrollDownButton.MouseEnter:connect(function()
		scrollDownButton.BackgroundTransparency = 0.1
		local downChildren = scrollDownButton:GetChildren()
		for i = 1, #downChildren do
			downChildren[i].BackgroundTransparency = 0.1
		end
	end)
	scrollDownButton.MouseLeave:connect(function()
		scrollDownButton.BackgroundTransparency = 0.5
		local downChildren = scrollDownButton:GetChildren()
		for i = 1, #downChildren do
			downChildren[i].BackgroundTransparency = 0.5
		end
	end)
	scrollDownButton.Parent = controlFrame
	
	local scrollTrack = Instance.new("Frame")
	scrollTrack.Name = "ScrollTrack"
	scrollTrack.BackgroundTransparency = 1
	scrollTrack.Size = UDim2.new(0,18,1,-38)
	scrollTrack.Position = UDim2.new(0,0,0,19)
	scrollTrack.Parent = controlFrame

	local scrollbar = Instance.new("TextButton")
	scrollbar.BackgroundColor3 = Color3.new(0,0,0)
	scrollbar.BorderColor3 = Color3.new(1,1,1)
	scrollbar.BackgroundTransparency = 0.5
	scrollbar.AutoButtonColor = false
	scrollbar.Text = ""
	scrollbar.Active = true
	scrollbar.Name = "ScrollBar"
	scrollbar.ZIndex = 2
	scrollbar.BackgroundTransparency = 0.5
	scrollbar.Size = UDim2.new(0, 18, 0.1, 0)
	scrollbar.Position = UDim2.new(0,0,0,0)
	scrollbar.Parent = scrollTrack

	local scrollNub = Instance.new("Frame")
	scrollNub.Name = "ScrollNub"
	scrollNub.BorderColor3 = Color3.new(1,1,1)
	scrollNub.Size = UDim2.new(0,10,0,0)
	scrollNub.Position = UDim2.new(0.5,-5,0.5,0)
	scrollNub.ZIndex = 2
	scrollNub.BackgroundTransparency = 0.5
	scrollNub.Parent = scrollbar

	local newNub = scrollNub:clone()
	newNub.Position = UDim2.new(0.5,-5,0.5,-2)
	newNub.Parent = scrollbar
	
	local lastNub = scrollNub:clone()
	lastNub.Position = UDim2.new(0.5,-5,0.5,2)
	lastNub.Parent = scrollbar

	scrollbar.MouseEnter:connect(function()
		scrollbar.BackgroundTransparency = 0.1
		scrollNub.BackgroundTransparency = 0.1
		newNub.BackgroundTransparency = 0.1
		lastNub.BackgroundTransparency = 0.1
	end)
	scrollbar.MouseLeave:connect(function()
		scrollbar.BackgroundTransparency = 0.5
		scrollNub.BackgroundTransparency = 0.5
		newNub.BackgroundTransparency = 0.5
		lastNub.BackgroundTransparency = 0.5
	end)

	local mouseDrag = Instance.new("ImageButton")
	mouseDrag.Active = false
	mouseDrag.Size = UDim2.new(1.5, 0, 1.5, 0)
	mouseDrag.AutoButtonColor = false
	mouseDrag.BackgroundTransparency = 1
	mouseDrag.Name = "mouseDrag"
	mouseDrag.Position = UDim2.new(-0.25, 0, -0.25, 0)
	mouseDrag.ZIndex = 10
	
	local function positionScrollBar(x,y,offset)
		if y < scrollTrack.AbsolutePosition.y then
			scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale,scrollbar.Position.X.Offset,0,0)
			return
		end
		
		local relativeSize = scrollbar.AbsoluteSize.Y/scrollTrack.AbsoluteSize.Y

		if y > (scrollTrack.AbsolutePosition.y + scrollTrack.AbsoluteSize.y) then
			scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale,scrollbar.Position.X.Offset,1 - relativeSize,0)
			return
		end
		local newScaleYPos = (y - scrollTrack.AbsolutePosition.y - offset)/scrollTrack.AbsoluteSize.y
		if newScaleYPos + relativeSize > 1 then
			newScaleYPos = 1 - relativeSize
			scrollBottom.Value = true
			scrollUp.Value = false
		elseif newScaleYPos <= 0 then
			newScaleYPos = 0
			scrollUp.Value = true
			scrollBottom.Value = false
		else
			scrollUp.Value = false
			scrollBottom.Value = false
		end
		scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale,scrollbar.Position.X.Offset,newScaleYPos,0)
	end

	local function drillDownSetHighLow(instance)
		if not instance or not instance:IsA("GuiObject") then return end
		if instance == controlFrame then return end

		if lowY and lowY > instance.AbsolutePosition.Y then
			lowY = instance.AbsolutePosition.Y
		elseif not lowY then
			lowY = instance.AbsolutePosition.Y
		end
		if highY and highY < (instance.AbsolutePosition.Y + instance.AbsoluteSize.Y) then
			highY = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
		elseif not highY then
			highY = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
		end
		local children = instance:GetChildren()
		for i = 1, #children do
			drillDownSetHighLow(children[i])
		end
	end

	local function resetHighLow()
		local firstChildren = scrollingFrame:GetChildren()

		for i = 1, #firstChildren do
			drillDownSetHighLow(firstChildren[i])
		end
	end

	local function setSliderSizeAndPosition()
		if highY and lowY then
			local totalYSpan = math.abs(highY - lowY)
			if totalYSpan == 0 then
				scrollbar.Visible = false
				scrollDownButton.Visible = false
				scrollUpButton.Visible = false

				if dragCon then dragCon:disconnect() dragCon = nil end
				if upCon then upCon:disconnect() upCon = nil end
				return
			end

			if fixScrollingAreaCon then fixScrollingAreaCon:disconnect() fixScrollingAreaCon = nil end

			local percentShown = scrollingFrame.AbsoluteSize.Y/totalYSpan
			if percentShown >= 1 then
				scrollbar.Visible = false
				scrollDownButton.Visible = false
				scrollUpButton.Visible = false
			else
				scrollbar.Visible = true
				scrollDownButton.Visible = true
				scrollUpButton.Visible = true

				scrollbar.Size = UDim2.new(scrollbar.Size.X.Scale,scrollbar.Size.X.Offset,percentShown,0)
			end
			local percentPosition = (scrollingFrame.AbsolutePosition.Y - lowY)/totalYSpan
			scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale,scrollbar.Position.X.Offset,percentPosition,-scrollbar.AbsoluteSize.X/2)
			if scrollbar.Position.Y.Offset < 0 then
				scrollbar.Position = UDim2.new(scrollbar.Position.X.Scale,scrollbar.Position.X.Offset,0,0)
			end
		end
	end

	local function recalculate()
		if reentrancyGuard then
			return
		end
		reentrancyGuard = true
			local percentFrame = 0
			if scrollbar.Position.Y.Scale > 0 then
				percentFrame = scrollbar.Position.Y.Scale/((scrollTrack.AbsoluteSize.Y - scrollbar.AbsoluteSize.Y)/scrollTrack.AbsoluteSize.Y)
			end
			if percentFrame > 0.99 then percentFrame = 1 end

			local hiddenYAmount = (scrollingFrame.AbsoluteSize.Y - (highY - lowY)) * percentFrame

			local guiChildren = scrollingFrame:GetChildren()
			for i = 1, #guiChildren do
				if guiChildren[i] ~= controlFrame then 
					guiChildren[i].Position = UDim2.new(guiChildren[i].Position.X.Scale,guiChildren[i].Position.X.Offset,
						0, (guiChildren[i].AbsolutePosition.Y - lowY) + hiddenYAmount)
				end
			end

			lowY = nil
			highY = nil
			resetHighLow()
		reentrancyGuard = false
	end
	
	local buttonScrollAmountPixels = 7
	local function doScrollUp()
		positionScrollBar(0,scrollbar.AbsolutePosition.Y - buttonScrollAmountPixels,0)
		recalculate()
	end
	
	local function doScrollDown()
		positionScrollBar(0,scrollbar.AbsolutePosition.Y + buttonScrollAmountPixels,0)
		recalculate()
	end

	local function scrollUp(mouseYPos)
		scrollStamp = tick()
		local current = scrollStamp
		local upCon
		upCon = mouseDrag.MouseButton1Up:connect(function()
			scrollStamp = tick()
			mouseDrag.Parent = nil
			upCon:disconnect()
		end)
		mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
		doScrollUp()
		wait(0.2)
		local t = tick()
		local w = 0.1
		while scrollStamp == current do
			doScrollUp()
			if mouseYPos and mouseYPos > scrollbar.AbsolutePosition.y then
				break
			end
			if not scrollUpButton.Active then break end
			if tick()-t > 5 then
				w = 0
			elseif tick()-t > 2 then
				w = 0.06
			end
			wait(w)
		end
	end

	local function scrollDown(mouseYPos)
		if scrollDownButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			local downCon
			downCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				downCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollDown()
			wait(0.2)
			local t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollDown()
				if mouseYPos and mouseYPos < (scrollbar.AbsolutePosition.y + scrollbar.AbsoluteSize.x) then
					break
				end
				if not scrollDownButton.Active then break end
				if tick()-t > 5 then
					w = 0
				elseif tick()-t > 2 then
					w = 0.06
				end
				wait(w)
			end
		end
	end
	
	scrollbar.MouseButton1Down:connect(function(x,y)
		if scrollbar.Active then
			scrollStamp = tick()
			local mouseOffset = y - scrollbar.AbsolutePosition.y
			if dragCon then dragCon:disconnect() dragCon = nil end
			if upCon then upCon:disconnect() upCon = nil end
			local prevY = y
			dragCon = mouseDrag.MouseMoved:connect(function(x,y)
				positionScrollBar(x,y,mouseOffset)
				recalculate()
			end)
			upCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				dragCon:disconnect(); dragCon = nil
				upCon:disconnect(); drag = nil
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
		end
	end)

	local scrollMouseCount = 0

	scrollUpButton.MouseButton1Down:connect(function()
		if not fixScrollingAreaCon then scrollUp() end
	end)
	scrollUpButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)


	scrollDownButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollDownButton.MouseButton1Down:connect(function()
		if not fixScrollingAreaCon then scrollDown() end
	end)
		
	scrollbar.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	
	local function heightCheck(instance)
		if highY and (instance.AbsolutePosition.Y + instance.AbsoluteSize.Y) > highY then
			highY = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
		elseif not highY then
			highY = instance.AbsolutePosition.Y + instance.AbsoluteSize.Y
		end
		setSliderSizeAndPosition()
	end
	
	local function highLowRecheck()
		lowY = nil
		highY = nil
		resetHighLow()
		setSliderSizeAndPosition()
	end

	scrollingFrame.DescendantAdded:connect(function(instance)
		if not instance:IsA("GuiObject") then return end
		wait() -- wait a heartbeat for sizes to reconfig
		setSliderSizeAndPosition()
		highLowRecheck()

		if instance.Visible then
			heightCheck(instance)
		end
	end)

	scrollingFrame.DescendantRemoving:connect(function(instance)
		if not instance:IsA("GuiObject") then return end
		wait() -- wait a heartbeat for sizes to reconfig
		highLowRecheck()
	end)

	return scrollingFrame, controlFrame
end

t.CreateScrollingFrame = function(orderList,scrollStyle)
	local frame = Instance.new("Frame")
	frame.Name = "ScrollingFrame"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(1,0,1,0)
	
	local scrollUpButton = Instance.new("ImageButton")
	scrollUpButton.Name = "ScrollUpButton"
	scrollUpButton.BackgroundTransparency = 1
	scrollUpButton.Image = "rbxasset://textures/ui/scrollbuttonUp.png"
	scrollUpButton.Size = UDim2.new(0,17,0,17) 

	
	local scrollDownButton = Instance.new("ImageButton")
	scrollDownButton.Name = "ScrollDownButton"
	scrollDownButton.BackgroundTransparency = 1
	scrollDownButton.Image = "rbxasset://textures/ui/scrollbuttonDown.png"
	scrollDownButton.Size = UDim2.new(0,17,0,17) 
	
	local scrollbar = Instance.new("ImageButton")
	scrollbar.Name = "ScrollBar"
	scrollbar.Image = "rbxasset://textures/ui/scrollbar.png"
	scrollbar.BackgroundTransparency = 1
	scrollbar.Size = UDim2.new(0, 18, 0, 150)

	local scrollStamp = 0
		
	local scrollDrag = Instance.new("ImageButton")
	scrollDrag.Image = "http://www.roblox.com/asset/?id=61367186"
	scrollDrag.Size = UDim2.new(1, 0, 0, 16)
	scrollDrag.BackgroundTransparency = 1
	scrollDrag.Name = "ScrollDrag"
	scrollDrag.Active = true
	scrollDrag.Parent = scrollbar
	
	local mouseDrag = Instance.new("ImageButton")
	mouseDrag.Active = false
	mouseDrag.Size = UDim2.new(1.5, 0, 1.5, 0)
	mouseDrag.AutoButtonColor = false
	mouseDrag.BackgroundTransparency = 1
	mouseDrag.Name = "mouseDrag"
	mouseDrag.Position = UDim2.new(-0.25, 0, -0.25, 0)
	mouseDrag.ZIndex = 10

	local style = "simple"
	if scrollStyle and tostring(scrollStyle) then
		style = scrollStyle
	end
	
	local scrollPosition = 1
	local rowSize = 0
	local howManyDisplayed = 0
		
	local layoutGridScrollBar = function()
		howManyDisplayed = 0
		local guiObjects = {}
		if orderList then
			for i, child in ipairs(orderList) do
				if child.Parent == frame then
					table.insert(guiObjects, child)
				end
			end
		else
			local children = frame:GetChildren()
			if children then
				for i, child in ipairs(children) do 
					if child:IsA("GuiObject") then
						table.insert(guiObjects, child)
					end
				end
			end
		end
		if #guiObjects == 0 then
			scrollUpButton.Active = false
			scrollDownButton.Active = false
			scrollDrag.Active = false
			scrollPosition = 1
			return
		end

		if scrollPosition > #guiObjects then
			scrollPosition = #guiObjects
		end
		
		local totalPixelsY = frame.AbsoluteSize.Y
		local pixelsRemainingY = frame.AbsoluteSize.Y
		
		local totalPixelsX  = frame.AbsoluteSize.X
		
		local xCounter = 0
		local rowSizeCounter = 0
		local setRowSize = true

		local pixelsBelowScrollbar = 0
		local pos = #guiObjects
		while pixelsBelowScrollbar < totalPixelsY and pos >= 1 do
			if pos >= scrollPosition then
				pixelsBelowScrollbar = pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y
			else
				xCounter = xCounter + guiObjects[pos].AbsoluteSize.X
				rowSizeCounter = rowSizeCounter + 1
				if xCounter >= totalPixelsX then
					if setRowSize then
						rowSize = rowSizeCounter - 1
						setRowSize = false
					end
					
					rowSizeCounter = 0
					xCounter = 0
					if pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y <= totalPixelsY then
						--It fits, so back up our scroll position
						pixelsBelowScrollbar = pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y
						if scrollPosition <= rowSize then
							scrollPosition = rowSize 
							break
						else
							scrollPosition = scrollPosition - rowSize 
						end
					else
						break
					end
				end
			end
			pos = pos - 1
		end

		xCounter = 0
		pos = scrollPosition
		rowSizeCounter = 0
		setRowSize = true
		local lastChildSize = 0
		
		local xOffset,yOffset = 0
		if guiObjects[1] then
			yOffset = math.ceil(math.floor(math.fmod(totalPixelsY,guiObjects[1].AbsoluteSize.X))/2)
			xOffset = math.ceil(math.floor(math.fmod(totalPixelsX,guiObjects[1].AbsoluteSize.Y))/2)
		end
		
		for i, child in ipairs(guiObjects) do
			if i < scrollPosition then
				--print("Hiding " .. child.Name)
				child.Visible = false
			else
				if pixelsRemainingY < 0 then
					--print("Out of Space " .. child.Name)
					child.Visible = false
				else
					--print("Laying out " .. child.Name)
					--GuiObject
					if setRowSize then rowSizeCounter = rowSizeCounter + 1 end
					if xCounter + child.AbsoluteSize.X >= totalPixelsX then
						if setRowSize then
							rowSize = rowSizeCounter - 1
							setRowSize = false
						end
						xCounter = 0
						pixelsRemainingY = pixelsRemainingY - child.AbsoluteSize.Y
					end
					child.Position = UDim2.new(child.Position.X.Scale,xCounter + xOffset, 0, totalPixelsY - pixelsRemainingY + yOffset)
					xCounter = xCounter + child.AbsoluteSize.X
					child.Visible = ((pixelsRemainingY - child.AbsoluteSize.Y) >= 0)
					if child.Visible then
						howManyDisplayed = howManyDisplayed + 1
					end
					lastChildSize = child.AbsoluteSize				
				end
			end
		end

		scrollUpButton.Active = (scrollPosition > 1)
		if lastChildSize == 0 then 
			scrollDownButton.Active = false
		else
			scrollDownButton.Active = ((pixelsRemainingY - lastChildSize.Y) < 0)
		end
		scrollDrag.Active = #guiObjects > howManyDisplayed
		scrollDrag.Visible = scrollDrag.Active
	end



	local layoutSimpleScrollBar = function()
		local guiObjects = {}	
		howManyDisplayed = 0
		
		if orderList then
			for i, child in ipairs(orderList) do
				if child.Parent == frame then
					table.insert(guiObjects, child)
				end
			end
		else
			local children = frame:GetChildren()
			if children then
				for i, child in ipairs(children) do 
					if child:IsA("GuiObject") then
						table.insert(guiObjects, child)
					end
				end
			end
		end
		if #guiObjects == 0 then
			scrollUpButton.Active = false
			scrollDownButton.Active = false
			scrollDrag.Active = false
			scrollPosition = 1
			return
		end

		if scrollPosition > #guiObjects then
			scrollPosition = #guiObjects
		end
		
		local totalPixels = frame.AbsoluteSize.Y
		local pixelsRemaining = frame.AbsoluteSize.Y

		local pixelsBelowScrollbar = 0
		local pos = #guiObjects
		while pixelsBelowScrollbar < totalPixels and pos >= 1 do
			if pos >= scrollPosition then
				pixelsBelowScrollbar = pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y
			else
				if pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y <= totalPixels then
					--It fits, so back up our scroll position
					pixelsBelowScrollbar = pixelsBelowScrollbar + guiObjects[pos].AbsoluteSize.Y
					if scrollPosition <= 1 then
						scrollPosition = 1
						break
					else
						--print("Backing up ScrollPosition from -- " ..scrollPosition)
						scrollPosition = scrollPosition - 1
					end
				else
					break
				end
			end
			pos = pos - 1
		end

		pos = scrollPosition
		for i, child in ipairs(guiObjects) do
			if i < scrollPosition then
				--print("Hiding " .. child.Name)
				child.Visible = false
			else
				if pixelsRemaining < 0 then
					--print("Out of Space " .. child.Name)
					child.Visible = false
				else
					--print("Laying out " .. child.Name)
					--GuiObject
					child.Position = UDim2.new(child.Position.X.Scale, child.Position.X.Offset, 0, totalPixels - pixelsRemaining)
					pixelsRemaining = pixelsRemaining - child.AbsoluteSize.Y
					if  (pixelsRemaining >= 0) then
						child.Visible = true
						howManyDisplayed = howManyDisplayed + 1
					else
						child.Visible = false
					end		
				end
			end
		end
		scrollUpButton.Active = (scrollPosition > 1)
		scrollDownButton.Active = (pixelsRemaining < 0)
		scrollDrag.Active = #guiObjects > howManyDisplayed
		scrollDrag.Visible = scrollDrag.Active
	end
	
		
	local moveDragger = function()	
		local guiObjects = 0
		local children = frame:GetChildren()
		if children then
			for i, child in ipairs(children) do 
				if child:IsA("GuiObject") then
					guiObjects = guiObjects + 1
				end
			end
		end
		
		if not scrollDrag.Parent then return end
		
		local dragSizeY = scrollDrag.Parent.AbsoluteSize.y * (1/(guiObjects - howManyDisplayed + 1))
		if dragSizeY < 16 then dragSizeY = 16 end
		scrollDrag.Size = UDim2.new(scrollDrag.Size.X.Scale,scrollDrag.Size.X.Offset,scrollDrag.Size.Y.Scale,dragSizeY)

		local relativeYPos = (scrollPosition - 1)/(guiObjects - (howManyDisplayed))
		if relativeYPos > 1 then relativeYPos = 1
		elseif relativeYPos < 0 then relativeYPos = 0 end
		local absYPos = 0
		
		if relativeYPos ~= 0 then
			absYPos = (relativeYPos * scrollbar.AbsoluteSize.y) - (relativeYPos * scrollDrag.AbsoluteSize.y)
		end
		
		scrollDrag.Position = UDim2.new(scrollDrag.Position.X.Scale,scrollDrag.Position.X.Offset,scrollDrag.Position.Y.Scale,absYPos)
	end

	local reentrancyGuard = false
	local recalculate = function()
		if reentrancyGuard then
			return
		end
		reentrancyGuard = true
		wait()
		local success, err = nil
		if style == "grid" then
			success, err = pcall(function() layoutGridScrollBar() end)
		elseif style == "simple" then
			success, err = pcall(function() layoutSimpleScrollBar() end)
		end
		if not success then print(err) end
		moveDragger()
		reentrancyGuard = false
	end
	
	local doScrollUp = function()
		scrollPosition = (scrollPosition - 1) - rowSize
		recalculate(nil)
	end
	
	local doScrollDown = function()
		scrollPosition = (scrollPosition + 1) + rowSize
		recalculate(nil)
	end

	local scrollUp = function(mouseYPos)
		scrollStamp = tick()
		local current = scrollStamp
		local upCon
		upCon = mouseDrag.MouseButton1Up:connect(function()
			scrollStamp = tick()
			mouseDrag.Parent = nil
			upCon:disconnect()
		end)
		mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
		doScrollUp()
		wait(0.2)
		local t = tick()
		local w = 0.1
		while scrollStamp == current do
			doScrollUp()
			if mouseYPos and mouseYPos > scrollDrag.AbsolutePosition.y then
				break
			end
			if not scrollUpButton.Active then break end
			if tick()-t > 5 then
				w = 0
			elseif tick()-t > 2 then
				w = 0.06
			end
			wait(w)
		end
	end

	local scrollDown = function(mouseYPos)
		if scrollDownButton.Active then
			scrollStamp = tick()
			local current = scrollStamp
			local downCon
			downCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				downCon:disconnect()
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
			doScrollDown()
			wait(0.2)
			local t = tick()
			local w = 0.1
			while scrollStamp == current do
				doScrollDown()
				if mouseYPos and mouseYPos < (scrollDrag.AbsolutePosition.y + scrollDrag.AbsoluteSize.x) then
					break
				end
				if not scrollDownButton.Active then break end
				if tick()-t > 5 then
					w = 0
				elseif tick()-t > 2 then
					w = 0.06
				end
				wait(w)
			end
		end
	end
	
	local y = 0
	scrollDrag.MouseButton1Down:connect(function(x,y)
		if scrollDrag.Active then
			scrollStamp = tick()
			local mouseOffset = y - scrollDrag.AbsolutePosition.y
			local dragCon
			local upCon
			dragCon = mouseDrag.MouseMoved:connect(function(x,y)
				local barAbsPos = scrollbar.AbsolutePosition.y
				local barAbsSize = scrollbar.AbsoluteSize.y
				
				local dragAbsSize = scrollDrag.AbsoluteSize.y
				local barAbsOne = barAbsPos + barAbsSize - dragAbsSize
				y = y - mouseOffset
				y = y < barAbsPos and barAbsPos or y > barAbsOne and barAbsOne or y
				y = y - barAbsPos
				
				local guiObjects = 0
				local children = frame:GetChildren()
				if children then
					for i, child in ipairs(children) do 
						if child:IsA("GuiObject") then
							guiObjects = guiObjects + 1
						end
					end
				end
				
				local doublePercent = y/(barAbsSize-dragAbsSize)
				local rowDiff = rowSize
				local totalScrollCount = guiObjects - (howManyDisplayed - 1)
				local newScrollPosition = math.floor((doublePercent * totalScrollCount) + 0.5) + rowDiff
				if newScrollPosition < scrollPosition then
					rowDiff = -rowDiff
				end
				
				if newScrollPosition < 1 then
					newScrollPosition = 1
				end
				
				scrollPosition = newScrollPosition
				recalculate(nil)
			end)
			upCon = mouseDrag.MouseButton1Up:connect(function()
				scrollStamp = tick()
				mouseDrag.Parent = nil
				dragCon:disconnect(); dragCon = nil
				upCon:disconnect(); drag = nil
			end)
			mouseDrag.Parent = getScreenGuiAncestor(scrollbar)
		end
	end)

	local scrollMouseCount = 0

	scrollUpButton.MouseButton1Down:connect(
		function()
			scrollUp()
		end)
	scrollUpButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)


	scrollDownButton.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollDownButton.MouseButton1Down:connect(
		function()
			scrollDown()	
		end)
		
	scrollbar.MouseButton1Up:connect(function()
		scrollStamp = tick()
	end)
	scrollbar.MouseButton1Down:connect(
		function(x,y)
			if y > (scrollDrag.AbsoluteSize.y + scrollDrag.AbsolutePosition.y) then
				scrollDown(y)
			elseif y < (scrollDrag.AbsolutePosition.y) then
				scrollUp(y)
			end
		end)


	frame.ChildAdded:connect(function()
		recalculate(nil)
	end)

	frame.ChildRemoved:connect(function()
		recalculate(nil)
	end)
	
	frame.Changed:connect(
		function(prop)
			if prop == "AbsoluteSize" then
				--Wait a heartbeat for it to sync in
				recalculate(nil)
			end
		end)
	frame.AncestryChanged:connect(function() recalculate(nil) end)

	return frame, scrollUpButton, scrollDownButton, recalculate, scrollbar
end
local function binaryGrow(min, max, fits)
	if min > max then
		return min
	end
	local biggestLegal = min

	while min <= max do
		local mid = min + math.floor((max - min) / 2)
		if fits(mid) and (biggestLegal == nil or biggestLegal < mid) then
			biggestLegal = mid
			
			--Try growing
			min = mid + 1
		else
			--Doesn't fit, shrink
			max = mid - 1
		end
	end
	return biggestLegal
end


local function binaryShrink(min, max, fits)
	if min > max then
		return min
	end
	local smallestLegal = max

	while min <= max do
		local mid = min + math.floor((max - min) / 2)
		if fits(mid) and (smallestLegal == nil or smallestLegal > mid) then
			smallestLegal = mid
			
			--It fits, shrink
			max = mid - 1			
		else
			--Doesn't fit, grow
			min = mid + 1
		end
	end
	return smallestLegal
end


local function getGuiOwner(instance)
	while instance ~= nil do
		if instance:IsA("ScreenGui") or instance:IsA("BillboardGui")  then
			return instance
		end
		instance = instance.Parent
	end
	return nil
end

t.AutoTruncateTextObject = function(textLabel)
	local text = textLabel.Text

	local fullLabel = textLabel:Clone()
	fullLabel.Name = "Full" .. textLabel.Name 
	fullLabel.BorderSizePixel = 0
	fullLabel.BackgroundTransparency = 0
	fullLabel.Text = text
	fullLabel.TextXAlignment = Enum.TextXAlignment.Center
	fullLabel.Position = UDim2.new(0,-3,0,0)
	fullLabel.Size = UDim2.new(0,100,1,0)
	fullLabel.Visible = false
	fullLabel.Parent = textLabel

	local shortText = nil
	local mouseEnterConnection = nil
	local mouseLeaveConnection= nil

	local checkForResize = function()
		if getGuiOwner(textLabel) == nil then
			return
		end
		textLabel.Text = text
		if textLabel.TextFits then 
			--Tear down the rollover if it is active
			if mouseEnterConnection then
				mouseEnterConnection:disconnect()
				mouseEnterConnection = nil
			end
			if mouseLeaveConnection then
				mouseLeaveConnection:disconnect()
				mouseLeaveConnection = nil
			end
		else
			local len = string.len(text)
			textLabel.Text = text .. "~"

			--Shrink the text
			local textSize = binaryGrow(0, len, 
				function(pos)
					if pos == 0 then
						textLabel.Text = "~"
					else
						textLabel.Text = string.sub(text, 1, pos) .. "~"
					end
					return textLabel.TextFits
				end)
			shortText = string.sub(text, 1, textSize) .. "~"
			textLabel.Text = shortText
			
			--Make sure the fullLabel fits
			if not fullLabel.TextFits then
				--Already too small, grow it really bit to start
				fullLabel.Size = UDim2.new(0, 10000, 1, 0)
			end
			
			--Okay, now try to binary shrink it back down
			local fullLabelSize = binaryShrink(textLabel.AbsoluteSize.X,fullLabel.AbsoluteSize.X, 
				function(size)
					fullLabel.Size = UDim2.new(0, size, 1, 0)
					return fullLabel.TextFits
				end)
			fullLabel.Size = UDim2.new(0,fullLabelSize+6,1,0)

			--Now setup the rollover effects, if they are currently off
			if mouseEnterConnection == nil then
				mouseEnterConnection = textLabel.MouseEnter:connect(
					function()
						fullLabel.ZIndex = textLabel.ZIndex + 1
						fullLabel.Visible = true
						--textLabel.Text = ""
					end)
			end
			if mouseLeaveConnection == nil then
				mouseLeaveConnection = textLabel.MouseLeave:connect(
					function()
						fullLabel.Visible = false
						--textLabel.Text = shortText
					end)
			end
		end
	end
	textLabel.AncestryChanged:connect(checkForResize)
	textLabel.Changed:connect(
		function(prop) 
			if prop == "AbsoluteSize" then 
				checkForResize() 	
			end 
		end)

	checkForResize()

	local function changeText(newText)
		text = newText
		fullLabel.Text = text
		checkForResize()
	end

	return textLabel, changeText
end

local function TransitionTutorialPages(fromPage, toPage, transitionFrame, currentPageValue)	
	if fromPage then
		fromPage.Visible = false
		if transitionFrame.Visible == false then
			transitionFrame.Size = fromPage.Size
			transitionFrame.Position = fromPage.Position
		end
	else
		if transitionFrame.Visible == false then
			transitionFrame.Size = UDim2.new(0.0,50,0.0,50)
			transitionFrame.Position = UDim2.new(0.5,-25,0.5,-25)
		end
	end
	transitionFrame.Visible = true
	currentPageValue.Value = nil

	local newsize, newPosition
	if toPage then
		--Make it visible so it resizes
		toPage.Visible = true

		newSize = toPage.Size
		newPosition = toPage.Position

		toPage.Visible = false
	else
		newSize = UDim2.new(0.0,50,0.0,50)
		newPosition = UDim2.new(0.5,-25,0.5,-25)
	end
	transitionFrame:TweenSizeAndPosition(newSize, newPosition, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true,
		function(state)
			if state == Enum.TweenStatus.Completed then
				transitionFrame.Visible = false
				if toPage then
					toPage.Visible = true
					currentPageValue.Value = toPage
				end
			end
		end)
end

t.CreateTutorial = function(name, tutorialKey, createButtons)
	local frame = Instance.new("Frame")
	frame.Name = "Tutorial-" .. name
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(0.6, 0, 0.6, 0)
	frame.Position = UDim2.new(0.2, 0, 0.2, 0)

	local transitionFrame = Instance.new("Frame")
	transitionFrame.Name = "TransitionFrame"
	transitionFrame.Style = Enum.FrameStyle.RobloxRound
	transitionFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
	transitionFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
	transitionFrame.Visible = false
	transitionFrame.Parent = frame

	local currentPageValue = Instance.new("ObjectValue")
	currentPageValue.Name = "CurrentTutorialPage"
	currentPageValue.Value = nil
	currentPageValue.Parent = frame

	local boolValue = Instance.new("BoolValue")
	boolValue.Name = "Buttons"
	boolValue.Value = createButtons
	boolValue.Parent = frame

	local pages = Instance.new("Frame")
	pages.Name = "Pages"
	pages.BackgroundTransparency = 1
	pages.Size = UDim2.new(1,0,1,0)
	pages.Parent = frame

	local function getVisiblePageAndHideOthers()
		local visiblePage = nil
		local children = pages:GetChildren()
		if children then
			for i,child in ipairs(children) do
				if child.Visible then
					if visiblePage then
						child.Visible = false
					else
						visiblePage = child
					end
				end
			end
		end
		return visiblePage
	end

	local showTutorial = function(alwaysShow)
		if alwaysShow or UserSettings().GameSettings:GetTutorialState(tutorialKey) == false then
			print("Showing tutorial-",tutorialKey)
			local currentTutorialPage = getVisiblePageAndHideOthers()

			local firstPage = pages:FindFirstChild("TutorialPage1")
			if firstPage then
				TransitionTutorialPages(currentTutorialPage, firstPage, transitionFrame, currentPageValue)	
			else
				error("Could not find TutorialPage1")
			end
		end
	end

	local dismissTutorial = function()
		local currentTutorialPage = getVisiblePageAndHideOthers()

		if currentTutorialPage then
			TransitionTutorialPages(currentTutorialPage, nil, transitionFrame, currentPageValue)
		end

		UserSettings().GameSettings:SetTutorialState(tutorialKey, true)
	end

	local gotoPage = function(pageNum)
		local page = pages:FindFirstChild("TutorialPage" .. pageNum)
		local currentTutorialPage = getVisiblePageAndHideOthers()
		TransitionTutorialPages(currentTutorialPage, page, transitionFrame, currentPageValue)
	end

	return frame, showTutorial, dismissTutorial, gotoPage
end 

local function CreateBasicTutorialPage(name, handleResize, skipTutorial, giveDoneButton)
	local frame = Instance.new("Frame")
	frame.Name = "TutorialPage"
	frame.Style = Enum.FrameStyle.RobloxRound
	frame.Size = UDim2.new(0.6, 0, 0.6, 0)
	frame.Position = UDim2.new(0.2, 0, 0.2, 0)
	frame.Visible = false
	
	local frameHeader = Instance.new("TextLabel")
	frameHeader.Name = "Header"
	frameHeader.Text = name
	frameHeader.BackgroundTransparency = 1
	frameHeader.FontSize = Enum.FontSize.Size24
	frameHeader.Font = Enum.Font.ArialBold
	frameHeader.TextColor3 = Color3.new(1,1,1)
	frameHeader.TextXAlignment = Enum.TextXAlignment.Center
	frameHeader.TextWrap = true
	frameHeader.Size = UDim2.new(1,-55, 0, 22)
	frameHeader.Position = UDim2.new(0,0,0,0)
	frameHeader.Parent = frame

	local skipButton = Instance.new("ImageButton")
	skipButton.Name = "SkipButton"
	skipButton.AutoButtonColor = false
	skipButton.BackgroundTransparency = 1
	skipButton.Image = "rbxasset://textures/ui/closeButton.png"
	skipButton.MouseButton1Click:connect(function()
		skipTutorial()
	end)
	skipButton.MouseEnter:connect(function()
		skipButton.Image = "rbxasset://textures/ui/closeButton_dn.png"
	end)
	skipButton.MouseLeave:connect(function()
		skipButton.Image = "rbxasset://textures/ui/closeButton.png"
	end)
	skipButton.Size = UDim2.new(0, 25, 0, 25)
	skipButton.Position = UDim2.new(1, -25, 0, 0)
	skipButton.Parent = frame
	
	
	if giveDoneButton then
		local doneButton = Instance.new("TextButton")
		doneButton.Name = "DoneButton"
		doneButton.Style = Enum.ButtonStyle.RobloxButtonDefault
		doneButton.Text = "Done"
		doneButton.TextColor3 = Color3.new(1,1,1)
		doneButton.Font = Enum.Font.ArialBold
		doneButton.FontSize = Enum.FontSize.Size18
		doneButton.Size = UDim2.new(0,100,0,50)
		doneButton.Position = UDim2.new(0.5,-50,1,-50)
		
		if skipTutorial then
			doneButton.MouseButton1Click:connect(function() skipTutorial() end)
		end
		
		doneButton.Parent = frame
	end

	local innerFrame = Instance.new("Frame")
	innerFrame.Name = "ContentFrame"
	innerFrame.BackgroundTransparency = 1
	innerFrame.Position = UDim2.new(0,0,0,25)
	innerFrame.Parent = frame

	local nextButton = Instance.new("TextButton")
	nextButton.Name = "NextButton"
	nextButton.Text = "Next"
	nextButton.TextColor3 = Color3.new(1,1,1)
	nextButton.Font = Enum.Font.Arial
	nextButton.FontSize = Enum.FontSize.Size18
	nextButton.Style = Enum.ButtonStyle.RobloxButtonDefault
	nextButton.Size = UDim2.new(0,80, 0, 32)
	nextButton.Position = UDim2.new(0.5, 5, 1, -32)
	nextButton.Active = false
	nextButton.Visible = false
	nextButton.Parent = frame

	local prevButton = Instance.new("TextButton")
	prevButton.Name = "PrevButton"
	prevButton.Text = "Previous"
	prevButton.TextColor3 = Color3.new(1,1,1)
	prevButton.Font = Enum.Font.Arial
	prevButton.FontSize = Enum.FontSize.Size18
	prevButton.Style = Enum.ButtonStyle.RobloxButton
	prevButton.Size = UDim2.new(0,80, 0, 32)
	prevButton.Position = UDim2.new(0.5, -85, 1, -32)
	prevButton.Active = false
	prevButton.Visible = false
	prevButton.Parent = frame

	if giveDoneButton then
		innerFrame.Size = UDim2.new(1,0,1,-75)
	else
		innerFrame.Size = UDim2.new(1,0,1,-22)
	end

	local parentConnection = nil

	local function basicHandleResize()
		if frame.Visible and frame.Parent then
			local maxSize = math.min(frame.Parent.AbsoluteSize.X, frame.Parent.AbsoluteSize.Y)
			handleResize(200,maxSize)
		end
	end

	frame.Changed:connect(
		function(prop)
			if prop == "Parent" then
				if parentConnection ~= nil then
					parentConnection:disconnect()
					parentConnection = nil
				end
				if frame.Parent and frame.Parent:IsA("GuiObject") then
					parentConnection = frame.Parent.Changed:connect(
						function(parentProp)
							if parentProp == "AbsoluteSize" then
								wait()
								basicHandleResize()
							end
						end)
					basicHandleResize()
				end
			end

			if prop == "Visible" then 
				basicHandleResize()
			end
		end)

	return frame, innerFrame
end

t.CreateTextTutorialPage = function(name, text, skipTutorialFunc)
	local frame = nil
	local contentFrame = nil

	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.new(1,1,1)
	textLabel.Text = text
	textLabel.TextWrap = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Font = Enum.Font.Arial
	textLabel.FontSize = Enum.FontSize.Size14
	textLabel.Size = UDim2.new(1,0,1,0)

	local function handleResize(minSize, maxSize)
		size = binaryShrink(minSize, maxSize,
			function(size)
				frame.Size = UDim2.new(0, size, 0, size)
				return textLabel.TextFits
			end)
		frame.Size = UDim2.new(0, size, 0, size)
		frame.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
	end

	frame, contentFrame = CreateBasicTutorialPage(name, handleResize, skipTutorialFunc)
	textLabel.Parent = contentFrame

	return frame
end

t.CreateImageTutorialPage = function(name, imageAsset, x, y, skipTutorialFunc, giveDoneButton)
	local frame = nil
	local contentFrame = nil

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = imageAsset
	imageLabel.Size = UDim2.new(0,x,0,y)
	imageLabel.Position = UDim2.new(0.5,-x/2,0.5,-y/2)

	local function handleResize(minSize, maxSize)
		size = binaryShrink(minSize, maxSize,
			function(size)
				return size >= x and size >= y
			end)
		if size >= x and size >= y then
			imageLabel.Size = UDim2.new(0,x, 0,y)
			imageLabel.Position = UDim2.new(0.5,-x/2, 0.5, -y/2)
		else
			if x > y then
				--X is limiter, so 
				imageLabel.Size = UDim2.new(1,0,y/x,0)
				imageLabel.Position = UDim2.new(0,0, 0.5 - (y/x)/2, 0)
			else
				--Y is limiter
				imageLabel.Size = UDim2.new(x/y,0,1, 0)
				imageLabel.Position = UDim2.new(0.5-(x/y)/2, 0, 0, 0)
			end
		end
		size = size + 50
		frame.Size = UDim2.new(0, size, 0, size)
		frame.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
	end

	frame, contentFrame = CreateBasicTutorialPage(name, handleResize, skipTutorialFunc, giveDoneButton)
	imageLabel.Parent = contentFrame

	return frame
end

t.AddTutorialPage = function(tutorial, tutorialPage)
	local transitionFrame = tutorial.TransitionFrame
	local currentPageValue = tutorial.CurrentTutorialPage

	if not tutorial.Buttons.Value then
		tutorialPage.NextButton.Parent = nil
		tutorialPage.PrevButton.Parent = nil
	end

	local children = tutorial.Pages:GetChildren()
	if children and #children > 0 then
		tutorialPage.Name = "TutorialPage" .. (#children+1)
		local previousPage = children[#children]
		if not previousPage:IsA("GuiObject") then
			error("All elements under Pages must be GuiObjects")
		end

		if tutorial.Buttons.Value then
			if previousPage.NextButton.Active then
				error("NextButton already Active on previousPage, please only add pages with RbxGui.AddTutorialPage function")
			end
			previousPage.NextButton.MouseButton1Click:connect(
				function()
					TransitionTutorialPages(previousPage, tutorialPage, transitionFrame, currentPageValue)
				end)
			previousPage.NextButton.Active = true
			previousPage.NextButton.Visible = true

			if tutorialPage.PrevButton.Active then
				error("PrevButton already Active on tutorialPage, please only add pages with RbxGui.AddTutorialPage function")
			end
			tutorialPage.PrevButton.MouseButton1Click:connect(
				function()
					TransitionTutorialPages(tutorialPage, previousPage, transitionFrame, currentPageValue)
				end)
			tutorialPage.PrevButton.Active = true
			tutorialPage.PrevButton.Visible = true
		end

		tutorialPage.Parent = tutorial.Pages
	else
		--First child
		tutorialPage.Name = "TutorialPage1"
		tutorialPage.Parent = tutorial.Pages
	end
end 

t.Help = 
	function(funcNameOrFunc) 
		--input argument can be a string or a function.  Should return a description (of arguments and expected side effects)
		if funcNameOrFunc == "CreatePropertyDropDownMenu" or funcNameOrFunc == t.CreatePropertyDropDownMenu then
			return "Function CreatePropertyDropDownMenu.  " ..
				   "Arguments: (instance, propertyName, enumType).  " .. 
				   "Side effect: returns a container with a drop-down-box that is linked to the 'property' field of 'instance' which is of type 'enumType'" 
		end 
		if funcNameOrFunc == "CreateDropDownMenu" or funcNameOrFunc == t.CreateDropDownMenu then
			return "Function CreateDropDownMenu.  " .. 
			       "Arguments: (items, onItemSelected).  " .. 
				   "Side effect: Returns 2 results, a container to the gui object and a 'updateSelection' function for external updating.  The container is a drop-down-box created around a list of items" 
		end 
		if funcNameOrFunc == "CreateMessageDialog" or funcNameOrFunc == t.CreateMessageDialog then
			return "Function CreateMessageDialog.  " .. 
			       "Arguments: (title, message, buttons). " .. 
			       "Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in.  'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button"
		end		
		if funcNameOrFunc == "CreateStyledMessageDialog" or funcNameOrFunc == t.CreateStyledMessageDialog then
			return "Function CreateStyledMessageDialog.  " .. 
			       "Arguments: (title, message, style, buttons). " .. 
			       "Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in.  'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button, 'style' is a string, either Error, Notify or Confirm"
		end
		if funcNameOrFunc == "GetFontHeight" or funcNameOrFunc == t.GetFontHeight then
			return "Function GetFontHeight.  " .. 
			       "Arguments: (font, fontSize). " .. 
			       "Side effect: returns the size in pixels of the given font + fontSize"
		end
		if funcNameOrFunc == "LayoutGuiObjects" or funcNameOrFunc == t.LayoutGuiObjects then
		
		end
		if funcNameOrFunc == "CreateScrollingFrame" or funcNameOrFunc == t.CreateScrollingFrame then
			return "Function CreateScrollingFrame.  " .. 
			   "Arguments: (orderList, style) " .. 
			   "Side effect: returns 4 objects, (scrollFrame, scrollUpButton, scrollDownButton, recalculateFunction).  'scrollFrame' can be filled with GuiObjects.  It will lay them out and allow scrollUpButton/scrollDownButton to interact with them.  Orderlist is optional (and specifies the order to layout the children.  Without orderlist, it uses the children order. style is also optional, and allows for a 'grid' styling if style is passed 'grid' as a string.  recalculateFunction can be called when a relayout is needed (when orderList changes)"
		end
		if funcNameOrFunc == "CreateTrueScrollingFrame" or funcNameOrFunc == t.CreateTrueScrollingFrame then
			return "Function CreateTrueScrollingFrame.  " .. 
			   "Arguments: (nil) " .. 
			   "Side effect: returns 2 objects, (scrollFrame, controlFrame).  'scrollFrame' can be filled with GuiObjects, and they will be clipped if not inside the frame's bounds. controlFrame has children scrollup and scrolldown, as well as a slider.  controlFrame can be parented to any guiobject and it will readjust itself to fit."
		end
		if funcNameOrFunc == "AutoTruncateTextObject" or funcNameOrFunc == t.AutoTruncateTextObject then
			return "Function AutoTruncateTextObject.  " .. 
			   "Arguments: (textLabel) " .. 
			   "Side effect: returns 2 objects, (textLabel, changeText).  The 'textLabel' input is modified to automatically truncate text (with ellipsis), if it gets too small to fit.  'changeText' is a function that can be used to change the text, it takes 1 string as an argument"
		end
		if funcNameOrFunc == "CreateSlider" or funcNameOrFunc == t.CreateSlider then
			return "Function CreateSlider.  " ..
				"Arguments: (steps, width, position) " ..
				"Side effect: returns 2 objects, (sliderGui, sliderPosition).  The 'steps' argument specifies how many different positions the slider can hold along the bar.  'width' specifies in pixels how wide the bar should be (modifiable afterwards if desired). 'position' argument should be a UDim2 for slider positioning. 'sliderPosition' is an IntValue whose current .Value specifies the specific step the slider is currently on."
		end
	end
	
return t