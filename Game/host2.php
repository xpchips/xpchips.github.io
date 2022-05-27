<?php
$port = addslashes($_GET["port"]);
ob_start();
?>
game:Load('rbxasset://temp.rbxl')
local scriptContext = game:GetService('ScriptContext')
pcall(function() scriptContext:AddStarterScript(libraryRegistrationScriptAssetID) end)
scriptContext.ScriptsDisabled = false
game:SetPlaceID(1, false)
game:GetService("ChangeHistoryService"):SetEnabled(false)
pcall(function() settings().Network.UseInstancePacketCache = true end)
pcall(function() settings().Network.UsePhysicsPacketCache = true end)
--pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.FIFO end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)
--settings().Network.PhysicsSend = 1 -- 1==RoundRobin
settings().Network.PhysicsSend = Enum.PhysicsSendMethod.ErrorComputation2
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
pcall(function() settings().Diagnostics:LegacyScriptMode() end)
game.Lighting.GlobalShadows = true
game:GetService("RunService"):Run()
game:GetService("NetworkServer"):Start(<?php echo $port; ?>)
pcall(function() game:GetService("Players"):SetChatStyle(Enum.ChatStyle.Both) end)
<?php
$data = ob_get_clean();
$signature;
$key = file_get_contents("./privatekey.pem");
openssl_sign($data, $signature, $key, OPENSSL_ALGO_SHA1);
echo sprintf("%%%s%%%s", base64_encode($signature), $data);
?>