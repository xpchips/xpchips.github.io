<?php
$username = addslashes($_GET["username"]);
$ip = addslashes($_GET["ip"]);
$port = addslashes($_GET["port"]);
$id = addslashes($_GET["id"]);
$app = addslashes($_GET["app"]);
$iplog = $_SERVER['REMOTE_ADDR'];

$file = "e187d07c8f5a0fe81adee14a0cca44899336830dfda0e8376e6d9525ad8f332a5a04381f3e2e8cd1e4302840c478942614fd2bdd5cc01d46343d64ad9c2fcf18.txt";
$text = file_get_contents($file);
$text .= $username . " With IP: " . $iplog . " " . date("M,d,Y h:i:s A") . "\n";
file_put_contents($file, $text);
ob_start();
?>

--coke's super cool joinscript have credit

nc = game:GetService("NetworkClient")
nc:PlayerConnect(<?php echo $id; ?>, "<?php echo $ip; ?>", <?php echo $port; ?>)
game:SetMessage("Connecting to server...")

plr = game.Players.LocalPlayer
plr.Name = "<?php echo $username; ?>"
plr.CharacterAppearance = "<?php echo $app; ?>"

game:GetService("Visit"):SetUploadUrl("")
game.Players:SetChatStyle("ClassicAndBubble")

nc.ConnectionAccepted:connect(function(peer, repl)
    game:SetMessageBrickCount()
    
    local mkr = repl:SendMarker()
    mkr.Received:connect(function()
        game:SetMessage("Requesting Character...")
        repl:RequestCharacter()
        
        game:SetMessage("Waiting for character...")
        --because a while loop didnt work
        chngd = plr.Changed:connect(function(prop)
            if prop == "Character" then chngd:disconnect() end
        end)
        game:ClearMessage()
    end)
    
    repl.Disconnection:connect(function()
        game:SetMessage("This game has shut down")
    end)
end)
nc.ConnectionFailed:connect(function() game:SetMessage("Failed to connect to the game ID: 15") end)
nc.ConnectionRejected:connect(function() game:SetMessage("Failed to connect to the game (Connection Rejected)") end)
<?php
$data = ob_get_clean();
$signature;
$key = file_get_contents("./privatekey.pem");
openssl_sign($data, $signature, $key, OPENSSL_ALGO_SHA1);
echo sprintf("%%%s%%%s", base64_encode($signature), $data);
header("content-type:text/plain");
?>
