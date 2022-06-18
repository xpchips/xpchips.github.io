<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
	<Item class="Tool" referent="RBX0">
		<Properties>
			<bool name="Enabled">true</bool>
			<CoordinateFrame name="Grip">
				<X>0</X>
				<Y>0</Y>
				<Z>0</Z>
				<R00>1</R00>
				<R01>0</R01>
				<R02>0</R02>
				<R10>0</R10>
				<R11>1</R11>
				<R12>0</R12>
				<R20>0</R20>
				<R21>0</R21>
				<R22>1</R22>
			</CoordinateFrame>
			<string name="Name">BuildCloneTest</string>
			<Content name="TextureId"><null></null></Content>
			<bool name="archivable">true</bool>
		</Properties>
		<Item class="Part" referent="RBX1">
			<Properties>
				<bool name="Anchored">false</bool>
				<float name="BackParamA">-0.5</float>
				<float name="BackParamB">0.5</float>
				<token name="BackSurface">0</token>
				<token name="BackSurfaceInput">0</token>
				<float name="BottomParamA">-0.5</float>
				<float name="BottomParamB">0.5</float>
				<token name="BottomSurface">4</token>
				<token name="BottomSurfaceInput">0</token>
				<int name="BrickColor">194</int>
				<CoordinateFrame name="CFrame">
					<X>0</X>
					<Y>0</Y>
					<Z>0</Z>
					<R00>1</R00>
					<R01>0</R01>
					<R02>0</R02>
					<R10>0</R10>
					<R11>1</R11>
					<R12>0</R12>
					<R20>0</R20>
					<R21>0</R21>
					<R22>1</R22>
				</CoordinateFrame>
				<bool name="CanCollide">true</bool>
				<bool name="DraggingV1">false</bool>
				<float name="Elasticity">0.5</float>
				<token name="FormFactor">1</token>
				<float name="Friction">0.300000012</float>
				<float name="FrontParamA">-0.5</float>
				<float name="FrontParamB">0.5</float>
				<token name="FrontSurface">0</token>
				<token name="FrontSurfaceInput">0</token>
				<float name="LeftParamA">-0.5</float>
				<float name="LeftParamB">0.5</float>
				<token name="LeftSurface">0</token>
				<token name="LeftSurfaceInput">0</token>
				<bool name="Locked">true</bool>
				<token name="Material">256</token>
				<string name="Name">Handle</string>
				<float name="Reflectance">0</float>
				<float name="RightParamA">-0.5</float>
				<float name="RightParamB">0.5</float>
				<token name="RightSurface">0</token>
				<token name="RightSurfaceInput">0</token>
				<Vector3 name="RotVelocity">
					<X>0</X>
					<Y>0</Y>
					<Z>0</Z>
				</Vector3>
				<float name="TopParamA">-0.5</float>
				<float name="TopParamB">0.5</float>
				<token name="TopSurface">3</token>
				<token name="TopSurfaceInput">0</token>
				<float name="Transparency">0</float>
				<Vector3 name="Velocity">
					<X>0</X>
					<Y>0</Y>
					<Z>0</Z>
				</Vector3>
				<bool name="archivable">true</bool>
				<token name="shape">1</token>
				<Vector3 name="size">
					<X>4</X>
					<Y>1.20000005</Y>
					<Z>2</Z>
				</Vector3>
			</Properties>
			<Item class="SpecialMesh" referent="RBX2">
				<Properties>
					<token name="LODX">2</token>
					<token name="LODY">2</token>
					<Content name="MeshId"><null></null></Content>
					<token name="MeshType">0</token>
					<string name="Name">Mesh</string>
					<Vector3 name="Offset">
						<X>0</X>
						<Y>0</Y>
						<Z>0</Z>
					</Vector3>
					<Vector3 name="Scale">
						<X>1</X>
						<Y>1</Y>
						<Z>1</Z>
					</Vector3>
					<Content name="TextureId"><null></null></Content>
					<Vector3 name="VertexColor">
						<X>1</X>
						<Y>1</Y>
						<Z>1</Z>
					</Vector3>
					<bool name="archivable">true</bool>
				</Properties>
			</Item>
		</Item>
		<Item class="LocalScript" referent="RBX3">
			<Properties>
				<bool name="Disabled">false</bool>
				<Content name="LinkedSource"><null></null></Content>
				<string name="Name">LocalScript</string>
				<ProtectedString name="Source">local Tool = script.Parent

local origColor = nil

local clonePart = nil
local downPart = nil
local downCon = nil
local changeCon = nil
local upCon = nil
local localMouse = nil
local newPart = nil
local touch = nil

local glowScript = script.Parent:FindFirstChild(&quot;SelectionScript&quot;)

local sparkles = Instance.new(&quot;Sparkles&quot;)

function onEquipped(mouse)

	localMouse = mouse
	localMouse.Icon = &quot;rbxasset://textures\\CloneCursor.png&quot;
	downCon = mouse.Button1Down:connect(mouseDown)
	upCon = mouse.Button1Up:connect(mouseUp)
	changeCon = mouse.Move:connect(targetSelection)

end
Tool.Equipped:connect(onEquipped)

function onUnequipped(mouse)

	if origColor ~= nil and glowScript.Parent:IsA(&quot;Part&quot;) then
		glowScript.Disabled = true
		glowScript.Parent.BrickColor = origColor
		glowScript.Parent = script.Parent
	end
	localMouse = nil
	clonePart = nil
	downPart = nil
	if downCon then downCon:disconnect() end
	if upCon then upCon:disconnect() end
	if changeCong then changeCon:disconnect() end

end
Tool.Unequipped:connect(onUnequipped)


function targetSelection()

	if localMouse.Target ~= nil and canSelect(localMouse.Target) then
		if localMouse.Target ~= glowScript.Parent then
			glowScript.Disabled = true
			if origColor ~= nil and glowScript.Parent:IsA(&quot;Part&quot;) then 
				glowScript.Parent.BrickColor = origColor
			end
			glowScript.Parent = localMouse.Target
			origColor = localMouse.Target.BrickColor
			glowScript.Disabled = false
		end
	else
		glowScript.Disabled = true
		if origColor ~= nil and glowScript.Parent:IsA(&quot;Part&quot;) then 
			glowScript.Parent.BrickColor = origColor
		end
		glowScript.Parent = script.Parent
	end

end

function canSelect(part)
	if part.Anchored == true or part.Locked == true then
		return false
	end
	return true
end

function mouseDown()
	if canSelect(localMouse.Target) then
		downPart = localMouse.Target
	end
end

function mouseUp()

	clonePart = localMouse.Target
	if clonePart and clonePart == downPart then
		newPart = clonePart:clone()
		if newPart:FindFirstChild(&quot;SelectionScript&quot;) then newPart.SelectionScript:remove() end
		if origColor then newPart.BrickColor = origColor end
		newPart.Transparency = 1
		newPart.Position = Vector3.new(clonePart.Position.x,clonePart.Position.y + clonePart.Size.y, clonePart.Position.z)
		touch = newPart.Touched:connect(movePartUp)
		delay(0.1,disconnectTouch)
		newPart.Parent = clonePart.Parent
		fadeIntoWorld(newPart)
	end
end

function fadeIntoWorld(part)
	local transStep = 0.07
	while part.Transparency &gt; 0 do
		part.Transparency = part.Transparency - transStep
		wait()
	end
	part.Transparency = 0
end

function movePartUp(part)
	newPart.CanCollide = false
	newPart.Position = Vector3.new(newPart.Position.x,part.Position.y + part.Size.y,newPart.Position.z)
	newPart.CanCollide = true
end

function disconnectTouch()
	if touch then touch:disconnect() end
end


</ProtectedString>
				<bool name="archivable">true</bool>
			</Properties>
		</Item>
		<Item class="Script" referent="RBX4">
			<Properties>
				<bool name="Disabled">true</bool>
				<Content name="LinkedSource"><null></null></Content>
				<string name="Name">SelectionScript</string>
				<ProtectedString name="Source">local origColor = script.Parent.BrickColor
local brick = script.Parent

local step = 0.1
local green = 0
local sub = false
brick.BrickColor = BrickColor.new(0,0,0)
while true do

	if green + step &gt; 1 then sub = true
	elseif  green - step &lt; 0 then sub = false end
	if sub then brick.BrickColor = BrickColor.new(0,green - step,0) green = green  - step
	else brick.BrickColor = BrickColor.new(0,green + step,0) green = green + step end

	wait()

end
</ProtectedString>
				<bool name="archivable">true</bool>
			</Properties>
		</Item>
	</Item>
</roblox>