function waitForProperty(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end
function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

waitForProperty(game.Players,"LocalPlayer")
waitForChild(script.Parent,"Popup")

local localPlayer = game.Players.LocalPlayer

local makePopupInvisible = function()
	if script.Parent.Popup then script.Parent.Popup.Visible = false end
end

function makeFriend(fromPlayer,toPlayer)
	
	local popup = script.Parent.Popup
	if popup == nil then return end -- there is no popup!
	if popup.Visible then return end -- currently popping something, abort!

	popup.PopupText.Text = "Accept Friend Request from " .. tostring(fromPlayer.Name) .. "?"
	popup.PopupImage.Image = "http://www.roblox.com/thumbs/avatar.ashx?userId="..tostring(fromPlayer.userId).."&x=352&y=352"
	
	popup.Visible = true
	popup:TweenSize(UDim2.new(0,330,0,350),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true)
	
	local yesCon, noCon

	yesCon = popup.AcceptButton.MouseButton1Click:connect(function()
		popup.Visible = false
		toPlayer:RequestFriendship(fromPlayer)
		if yesCon then yesCon:disconnect() end
		if noCon then noCon:disconnect() end
		popup:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true,makePopupInvisible())
	end)

	noCon = popup.DeclineButton.MouseButton1Click:connect(function()
		popup.Visible = false
		toPlayer:RevokeFriendship(fromPlayer)
		if yesCon then yesCon:disconnect() end
		if noCon then noCon:disconnect() end
		popup:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,1,true,makePopupInvisible())
	end)
end


game.Players.FriendRequestEvent:connect(function(fromPlayer,toPlayer,event)

	-- if this doesn't involve me, then do nothing
	if fromPlayer ~= localPlayer and toPlayer ~= localPlayer then return end

	if fromPlayer == localPlayer then
		if event == Enum.FriendRequestEvent.Accept then
			game:GetService("GuiService"):SendNotification("You are Friends",
			"With " .. toPlayer.Name .. "!",
			"http://www.roblox.com/thumbs/avatar.ashx?userId="..tostring(toPlayer.userId).."&x=48&y=48",
			5)
		end
	elseif toPlayer == localPlayer then
		if event == Enum.FriendRequestEvent.Issue then
			game:GetService("GuiService"):SendNotification("Friend Request",
				"From " .. fromPlayer.Name,
				"http://www.roblox.com/thumbs/avatar.ashx?userId="..tostring(fromPlayer.userId).."&x=48&y=48",
				8,
				function()
					makeFriend(fromPlayer,toPlayer)
				end)
		elseif event == Enum.FriendRequestEvent.Accept then
			game:GetService("GuiService"):SendNotification("You are Friends",
			"With " .. fromPlayer.Name .. "!",
			"http://www.roblox.com/thumbs/avatar.ashx?userId="..tostring(fromPlayer.userId).."&x=48&y=48",
			5)
		end
	end
end)