%p1+XyRalmFxIdB38QzlaEIWe67z5TqOfyH0nrhP4k4Qhp8Ul7bM3IdutjeZc2sViXYk5PGNajcf572eytYmzxTv1cfEPMUVXVkKKHCQGbib8WH1YauR6QzdJG2Pc7gGZrdrTgy+YwY58oZZ+C3RersGDF21a9r0hJG1DCimwPaw=%
-- Setup studio cmd bar & load core scripts

pcall(function() game:GetService("InsertService"):SetFreeModelUrl("http://polygon.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx?type=fm&q=%s&pg=%d&rs=%d") end)
pcall(function() game:GetService("InsertService"):SetFreeDecalUrl("http://polygon.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx?type=fd&q=%s&pg=%d&rs=%d") end)

game:GetService("ScriptInformationProvider"):SetAssetUrl("http://polygon.pizzaboxer.xyz/asset/")
game:GetService("InsertService"):SetBaseSetsUrl("http://polygon.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
game:GetService("InsertService"):SetUserSetsUrl("http://polygon.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d&t=2")
game:GetService("InsertService"):SetCollectionUrl("http://polygon.pizzaboxer.xyz/Game/Tools/InsertAsset.ashx?sid=%d")
game:GetService("InsertService"):SetAssetUrl("http://polygon.pizzaboxer.xyz/asset/%d")
game:GetService("InsertService"):SetAssetVersionUrl("http://polygon.pizzaboxer.xyz/asset/%d")
game:GetService("InsertService"):SetTrustLevel(0)

pcall(function() game:GetService("SocialService"):SetFriendUrl("http://polygon.pizzaboxer.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetBestFriendUrl("http://polygon.pizzaboxer.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupUrl("http://polygon.pizzaboxer.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRankUrl("http://polygon.pizzaboxer.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRoleUrl("http://polygon.pizzaboxer.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d") end)

local starterScriptID = -1
if game.CoreGui.Version == 1 or game.CoreGui.Version == 2 then starterScriptID = 1036 --2011
elseif game.CoreGui.Version == 7 then starterScriptID = 1083 end --2012

local result = pcall(function() game:GetService("ScriptContext"):AddStarterScript(starterScriptID) end)
if not result then
  pcall(function() game:GetService("ScriptContext"):AddCoreScript(starterScriptID,game:GetService("ScriptContext"),"StarterScript") end)
end

-- loadfile("http://chef.pizzaboxer.xyz/game/visit.ashx")()
