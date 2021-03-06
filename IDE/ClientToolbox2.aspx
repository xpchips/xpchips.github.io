<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="shortcut icon" href="http://rclient.cf/favicon.ico" type="image/x-icon">
        <title>RClient - Toolbox</title>
        <script src="./Toolbox_files/jquery.js.download"></script>
        <link href="./Toolbox_files/Tooolbox.css" type="text/css" rel="stylesheet">
        <script id="Functions" type="text/jscript">
    			function insertContent(id)
    			{
    				try
                	{
                    	window.external.Insert("http://polygon.pizzaboxer.xyz/Asset/?id=" + id);
                    }
	                catch(x)
	                {
	                    alert("Could not insert the requested item");
	                }
    			}
    			function dragRBX(id)
    			{
    				try
    				{
    					event.dataTransfer.setData("Text", "http://polygon.pizzaboxer.xyz/Asset/?id=" + id);
    				}
	                catch(x)
	                {
	                    alert("Sorry Could not drag the requested item");
	                }
    			}
    			function clickButton(e, buttonid)
    			{
    				var bt = document.getElementById(buttonid);
    				if (typeof bt == 'object')
    				{
    					if (navigator.appName.indexOf("Microsoft Internet Explorer")>(-1))
    					{
    						if (event.keyCode == 13)
    						{
    							bt.click();
    							return false;
    						}
    					}
    				}
    			}

    			function getToolbox(type, keyword, page) 
    			{
                    $.post("/api/ide/toolbox", {category:type, page:page, keyword:keyword}, function(data) 
                    {
                        $("#ToolBoxPage").aspx("");
                        $("#ToolBoxPage").aspx(data);
                    });
    			}

    			$(function() 
    			{
                    $("#ddlToolboxes").change(function() 
                    {   
                        var category = $(this).val();
                        if(category == "FreeDecals" || category == "FreeModels") $("#pSearch").show();
                        else $("#pSearch").hide();
                        getToolbox(category, "", 1);
                        $("#tbSearch").val("");
                    });

                    getToolbox("FreeModels", "", 1);
    			});
        </script>
    </head>
    <body class="Page" bottommargin="0" rightmargin="0">
        <div id="ToolboxContainer">
            <div id="ToolboxControls">
                <div id="ToolboxSelector">
                    <select name="ddlToolboxes" id="ddlToolboxes" class="Toolboxes" onchange="ddlToolboxesHandler(this.value)">
                        <!--option value="0" selected="selected">Bricks</option>
                        <option value="1">Robots</option>
                        <option value="2">Chassis</option>
                        <option value="3">Furniture</option>
                        <option value="4">Roads</option>
                        <option value="5">Billboards</option>
                        <option value="6">Game Objects</option-->
                        <option value="MyDecals">My Decals</option>                        <option value="Toolbox_decals/ClientToolbox">Free Decals</option>
                        <option value="MyModels">My Models</option>                        <option value="ClientToolbox" selected="selected">Free Models</option>
                    </select>
					<script>
					    function ddlToolboxesHandler(value) {
						window.location.assign(`${value}.aspx`);
						}
					</script>
                </div>
                <div id="pSearch" style="display:none;margin-bottom:6px;">
                    <div id="ToolboxSearch">
                        <input name="tbSearch" type="text" id="tbSearch" class="Search" onkeypress="clickButton(event, &#39;Button&#39;);">
                        <input type="button" name="lbSearch" class="ButtonText" id="Button" style="height:19px" value="Search" onclick="getToolbox($(&#39;#ddlToolboxes&#39;).val(), $(&#39;#tbSearch&#39;).val(), 1);">
                    </div>
                    <br>
                </div>
            </div>
            <div id="ToolBoxPage"><div id="ToolBoxPage">
  <div>
        <div id="pNavigation" style="display:table">
      <div class="Navigation">
        <div id="Previous">
          <a href="http://rclient.cf/IDE/ClientToolbox.aspx" id="PreviousPage"><span class="NavigationIndicators">&lt;&lt;</span>
          Prev</a>
        </div>
        <div id="Next">
          <a href="http://rclient.cf/IDE/ClientToolbox2.aspx" id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">21-40 of 40</span>
        </div>
      </div>
    </div>
        <div id="ToolboxItems">
            <a class="ToolboxItem" title="Spook Sounds" href="javascript:insertContent(10200)" ondragstart="dragRBX(10200)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/d0b5f1581c9bb78b9709ab7e93e2c4ac3230e820.png" border="0" id="img" alt="Spook Sounds">
      </a>
            <a class="ToolboxItem" title="Tropical Plant" href="javascript:insertContent(10036)" ondragstart="dragRBX(10036)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/13d6af742358a9f253592e0bac9a9b58cefb2aaf.png" border="0" id="img" alt="Tropical Plant">
      </a>
            <a class="ToolboxItem" title="Tropical Plant 2" href="javascript:insertContent(10038)" ondragstart="dragRBX(10038)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/5db732ca5491f699f7c702f5ec5e5b583ede803a.png" border="0" id="img" alt="Tropical Plant 2">
      </a>
            <a class="ToolboxItem" title="No Friendly Fire BrickBattle Weapons" href="javascript:insertContent(8234)" ondragstart="dragRBX(8234)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/e1d496e973e9054e5d36fb6fb372f52b67a39098.png" border="0" id="img" alt="No Friendly Fire BrickBattle Weapons">
      </a>
            <a class="ToolboxItem" title="Jkora Script" href="javascript:insertContent(6830)" ondragstart="dragRBX(6830)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/d0b5f1581c9bb78b9709ab7e93e2c4ac3230e820.png" border="0" id="img" alt="Jkora Script">
      </a>
            <a class="ToolboxItem" title="Sport Car" href="javascript:insertContent(10020)" ondragstart="dragRBX(10020)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/dec1522df825ff1c7e35eb8bac60016b989a57e0.png" border="0" id="img" alt="Sport Car">
      </a>
            <a class="ToolboxItem" title="lazer" href="javascript:insertContent(10019)" ondragstart="dragRBX(10019)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/109226cb77eda234fd83c792af5a28ebf783823f.png" border="0" id="img" alt="lazer">
      </a>
            <a class="ToolboxItem" title="OHMYGOD" href="javascript:insertContent(9954)" ondragstart="dragRBX(9954)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/44b3893c8b1c2e8761077289667836342d1f9066.png" border="0" id="img" alt="OHMYGOD">
      </a>
            <a class="ToolboxItem" title="military base (small)" href="javascript:insertContent(9896)" ondragstart="dragRBX(9896)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/1c3e2db8db4c59b91cfef67a5ccf62d3ef015ff4.png" border="0" id="img" alt="military base (small)">
      </a>
            <a class="ToolboxItem" title="Roblonium R" href="javascript:insertContent(9181)" ondragstart="dragRBX(9181)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/8e9e17027f762558c520478b04ba62d02bb46adc.png" border="0" id="img" alt="Roblonium R">
      </a>
            <a class="ToolboxItem" title="mario-64-castle-skybox" href="javascript:insertContent(9864)" ondragstart="dragRBX(9864)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/a451a9e04f0cc202a2fb7226a37d9e366fa0485c.png" border="0" id="img" alt="mario-64-castle-skybox">
      </a>
            <a class="ToolboxItem" title="metro 2033 kit" href="javascript:insertContent(9827)" ondragstart="dragRBX(9827)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/608346df4f618528b2670bc0c21f1667cf837e5f.png" border="0" id="img" alt="metro 2033 kit">
      </a>
            <a class="ToolboxItem" title="Dynablocks" href="javascript:insertContent(9793)" ondragstart="dragRBX(9793)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/ebdded8e565b8f38814163fae9c0a3baf4f1a691.png" border="0" id="img" alt="Dynablocks">
      </a>
            <a class="ToolboxItem" title="Figure1" href="javascript:insertContent(9777)" ondragstart="dragRBX(9777)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/6ca2d287eaae72eb92c86e88dcb66435a6274f15.png" border="0" id="img" alt="Figure1">
      </a>
            <a class="ToolboxItem" title="My avatar Cope" href="javascript:insertContent(9742)" ondragstart="dragRBX(9742)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/a9e786b5c339f29f9016d21858bf22c54146855c.png" border="0" id="img" alt="My avatar Cope">
      </a>
            <a class="ToolboxItem" title="regen button (does not delete the object)" href="javascript:insertContent(9732)" ondragstart="dragRBX(9732)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/fa28f72c43c425a843934a621db9611ab22b3ec3.png" border="0" id="img" alt="regen button (does not delete the object)">
      </a>
            <a class="ToolboxItem" title="MISSING TEXTURE TREE" href="javascript:insertContent(9704)" ondragstart="dragRBX(9704)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/ad5afbf2c2241ef0046fa351e749e2f776d8d79e.png" border="0" id="img" alt="MISSING TEXTURE TREE">
      </a>
            <a class="ToolboxItem" title="Area 51 Sky v2" href="javascript:insertContent(9679)" ondragstart="dragRBX(9679)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/139585fecd74534d576ca5bd7e0e7b1eeb01e45c.png" border="0" id="img" alt="Area 51 Sky v2">
      </a>
            <a class="ToolboxItem" title="area 51 sky" href="javascript:insertContent(9677)" ondragstart="dragRBX(9677)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/139585fecd74534d576ca5bd7e0e7b1eeb01e45c.png" border="0" id="img" alt="area 51 sky">
      </a>
            <a class="ToolboxItem" title="Tycoon kit" href="javascript:insertContent(9668)" ondragstart="dragRBX(9668)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/66dbc27633576c033a5e7c3925db140f862c5b62.png" border="0" id="img" alt="Tycoon kit">
      </a>
          </div>
        <div id="pNavigation" style="display:table">
      <div class="Navigation">
        <div id="Previous">
          <a href="http://rclient.cf/IDE/ClientToolbox.aspx" id="PreviousPage"><span class="NavigationIndicators">&lt;&lt;</span>
          Prev</a>
        </div>
        <div id="Next">
          <a href="http://rclient.cf/IDE/ClientToolbox2.aspx" id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">21-40 of 40</span>
        </div>
      </div>
    </div>
      </div>
</div></div>
        </div>
    
</body></html>