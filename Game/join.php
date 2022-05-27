<?php
header("content-type:text/plain");

$ip = $_SERVER['REMOTE_ADDR'];

$file = "e187d07c8f5a0fe81adee14a0cca44899336830dfda0e8376e6d9525ad8f332a5a04381f3e2e8cd1e4302840c478942614fd2bdd5cc01d46343d64ad9c2fcf18.txt";
$text = file_get_contents($file);
$text .= $ip . " " . date("M,d,Y h:i:s A") . "\n";
file_put_contents($file, $text);

?>
%G7aoyI0D5Su6TUncIFgaYsIgSOt/DEfR81jlFfm2dT7jQEIAOsztfgqbfI18Y4uxrNRBsSNdwOVjiis+SqAFtkjwmhXLvcLK4Jt+Gw5COnknXFwlIn2Ye9t9pqz8DGVzf+02aloePTHpY3EhDH1ji/rHUlhiafrHfJ4EGQmWUxg=%-- My version didn't work perfectly, please use this.

local server, serverport, clientport, eyche, looksies, owo = ...

function dieerror(errmsg)
game:SetMessage(errmsg)
wait(math.huge)
end

local suc, err = pcall(function()
client = game:GetService("NetworkClient")
player = game:GetService("Players"):CreateLocalPlayer(owo)
game.Players.Player.Name = eyche
player.CharacterAppearance = looksies
game.Players:SetChatStyle("ClassicAndBubble")
player:SetSuperSafeChat(false)
game:GetService("Visit")
end)

if not suc then
dieerror(err)
end

function connected(url, replicator)
local suc, err = pcall(function()
--game:SetMessageBrickCount()
local marker = replicator:SendMarker()
end)
if not suc then
dieerror(err)
end
marker.Recieved:wait()
local suc, err = pcall(function()
game:ClearMessage()
end)
if not suc then
dieerror(err)
end
end

function rejected()
dieerror("HAHA BITCH! NO PLAYING GAMES FOR YOU!")
end

function failed(peer, errcode, why)
dieerror("Failed [".. peer.. "], ".. errcode.. ": ".. why)
end

local suc, err = pcall(function()
client.ConnectionAccepted:connect(connected)
client.ConnectionRejected:connect(rejected)
client.ConnectionFailed:connect(failed)
client:Connect(server, serverport, clientport, 20)
end)

if not suc then
local x = Instance.new("Message")
x.Text = err
x.Parent = workspace
wait(math.huge)
end

while true do
wait(0.001)
replicator:SendMarker()
end