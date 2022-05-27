<?php
header("content-type:text/plain");
?>
%bDfo5KGxqDy+fqnv6GTk0D8veuVGz7EInBqiW+jKwgdicMQfFoFO0G4oBCNS0dgppsuFhw8ztIL0NVYADGA5AiKQWo75TuiU4WkVBq2ongHhnqNfCWuviMpN9KD7AEajxowZrAAtW22JAFZcSSoTDre89OZCIu7D5N177h03Sxc=%-- Server script by EnergyCell
-- This is a short version, and simple
-- Use Tools > Execute script to run a server
local Port = ...
Server = game:GetService("NetworkServer")
RunService = game:GetService("RunService")
Server:start(Port, 20)
game:GetService("Visit")
RunService:run()
function onJoined(newPlayer)
print ("An new connection was accepted.")
newPlayer:LoadCharacter()
while true do 
wait(0.001) 
if newPlayer.Character.Humanoid.Health == 0
then print ("Player died") wait(5) newPlayer:LoadCharacter() print("Player respawned")
elseif newPlayer.Character.Parent == nil then wait(5) newPlayer:LoadCharacter() -- to make sure nobody is deleted.
end
end
end

game.Players.PlayerAdded:connect(onJoined)
-- You can adjust SendRate in the Studio settings to make the server run faster.