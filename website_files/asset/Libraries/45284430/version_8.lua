local t = {}

local function ScopedConnect(parentInstance, instance, event, signalFunc, syncFunc)
	local eventConnection = nil

	--Connection on parentInstance is scoped by parentInstance (when destroyed, it goes away)
	parentInstance.AncestryChanged:connect(function(child,parent)
		if game:IsAncestorOf(parentInstance) then
			--Entering the world, make sure we are connected/synced
			if not eventConnection then
				eventConnection = instance[event]:connect(signalFunc)
				syncFunc()
			end
		else
			--Probably leaving the world, so disconnect for now
			if eventConnection then
				eventConnection:disconnect()
			end
		end
	end)
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
		button.Style = Enum.ButtonStyle.RobloxButtonDefault 
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
					if not scrollUp() then
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
		scrollDownButton.MouseButton1Click:connect(scrollDown)
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
					if not scrollDown() then
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

t.Help = 
	function(funcNameOrFunc) 
		--input argument can be a string or a function.  Should return a description (of arguments and expected side effects)
		if funcNameOrFunc == "CreatePropertyDropDownMenu" or funcNameOrFunc == t.CreatePropertyDropDownMenu then
			return "Function CreatePropertyDropDownMenu.  Arguments: (instance, propertyName, enumType).  Side effect: returns a container with a drop-down-box that is linked to the 'property' field of 'instance' which is of type 'enumType'" 
		end 
		if funcNameOrFunc == "CreateDropDownMenu" or funcNameOrFunc == t.CreateDropDownMenu then
			return "Function CreateDropDownMenu.  Arguments: (items, onItemSelected).  Side effect: Returns 2 results, a container to the gui object and a 'updateSelection' function for external updating.  The container is a drop-down-box created around a list of items" 
		end 
		if funcNameOrFunc == "CreateMessageDialog" or funcNameOrFunc == t.CreateMessageDialog then
			return "Function CreateMessageDialog.  Arguments: (title, message, buttons). Side effect: Returns a gui object of a message box with 'title' and 'message' as passed in.  'buttons' input is an array of Tables contains a 'Text' and 'Function' field for the text/callback of each button"
		end		
	end
return t