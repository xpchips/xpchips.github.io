<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
        <title>RClient - Toolbox</title>
        <script src="./Toolbox_files/jquery.js.download"></script>
        <link href="./Toolbox_files/Tooolbox.css" type="text/css" rel="stylesheet">
        <script id="Functions" type="text/jscript">
    			function insertContent(id)
    			{
    				try
                	{
                    	window.external.Insert("http://rclient.cf/asset/toolbox/bricks/" + id);
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
    					event.dataTransfer.setData("Text", "http://rclient.cf/asset/toolbox/bricks/" + id);
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
                        <option value="ClientToolbox.aspx" selected="selected">Bricks</option> <!-- 0 -->
                        <option value="Robots">Robots</option> <!-- 1 -->
                        <option value="Chassis">Chassis</option> <!-- 2 -->
                        <option value="Furniture">Furniture</option> <!-- 3 -->
                        <option value="Roads">Roads</option> <!-- 4 -->
                        <option value="Billboards">Billboards</option> <!-- 5 -->
                        <option value="GameObjects">Game Objects</option> <!-- 6 -->
                        <!-- <option value="MyDecals">My Decals</option>  -->                      <option value="FreeDecals">Free Decals</option>
                        <!-- <option value="MyModels">My Models</option>  -->                      <option value="FreeModels">Free Models</option>
                    </select>
					<script>
					function ddlToolboxesHandler(value) {
						window.location.href = value + ".aspx";
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
          <a href="https://http://rclient.cf/IDE/ClientToolbox.aspx" id="PreviousPage" style="visibility:hidden"><span class="NavigationIndicators">&lt;&lt;</span>
          Prev</a>
        </div>
        <div id="Next">
          <a href="http://rclient.cf/IDE/ClientToolbox.aspx" id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">1-16 of 16</span>
        </div>
      </div>
    </div>
        <div id="ToolboxItems">
            <a class="ToolboxItem" title="Reddish brown 2x4" href="javascript:insertContent(1)" ondragstart="dragRBX(1)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/ReddishbrownBrick.png" border="0" id="img" alt="Reddish brown 2x4">
      </a>
            <a class="ToolboxItem" title="Bright orange 2x4" href="javascript:insertContent(2)" ondragstart="dragRBX(2)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/BrightorangeBrick.png" border="0" id="img" alt="Bright orange 2x4">
      </a>
            <a class="ToolboxItem" title="Sand green 2x4" href="javascript:insertContent(3)" ondragstart="dragRBX(3)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/SandgreenBrick.png" border="0" id="img" alt="Sand green 2x4">
      </a>
            <a class="ToolboxItem" title="Reddish brown 2x4" href="javascript:insertContent(1)" ondragstart="dragRBX(1)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/ReddishbrownBrick.png" border="0" id="img" alt="Reddish brown 2x4">
      </a>
            <a class="ToolboxItem" title="Darkstone grey 2x4" href="javascript:insertContent(4)" ondragstart="dragRBX(4)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/DarkstonegreyBrick.png" border="0" id="img" alt="Darkstone grey 2x4">
      </a>
            <a class="ToolboxItem" title="Medium stone grey 2x4" href="javascript:insertContent(5)" ondragstart="dragRBX(5)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/MediumstonegreyBrick.png" border="0" id="img" alt="Medium stone grey 2x4">
      </a>
            <a class="ToolboxItem" title="Brick yellow 2x4" href="javascript:insertContent(6)" ondragstart="dragRBX(6)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/BrickyellowBrick.png" border="0" id="img" alt="Brick yellow 2x4">
      </a>
            <a class="ToolboxItem" title="Cool yellow 2x4" href="javascript:insertContent(7)" ondragstart="dragRBX(7)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/CoolyellowBrick.png" border="0" id="img" alt="Cool yellow 2x4">
      </a>
            <a class="ToolboxItem" title="Bright blue 2x4" href="javascript:insertContent(8)" ondragstart="dragRBX(8)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/BrightblueBrick.png" border="0" id="img" alt="Bright blue 2x4">
      </a>
            <a class="ToolboxItem" title="Dark green 2x4" href="javascript:insertContent(9)" ondragstart="dragRBX(9)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/DarkgreenBrick.png" border="0" id="img" alt="Dark green 2x4">
      </a>
            <a class="ToolboxItem" title="Bright yellow 2x4" href="javascript:insertContent(6)" ondragstart="dragRBX(6)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/BrightyellowBrick.png" border="0" id="img" alt="Bright yellow 2x4">
      </a>
            <a class="ToolboxItem" title="Bright red 2x4" href="javascript:insertContent(10)" ondragstart="dragRBX(10)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/BrightredBrick.png" border="0" id="img" alt="Bright red 2x4">
      </a>
            <a class="ToolboxItem" title="Black 2x4" href="javascript:insertContent(11)" ondragstart="dragRBX(11)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/BlackBrick.png" border="0" id="img" alt="Black 2x4">
      </a>
            <a class="ToolboxItem" title="Dark stone grey 2x4" href="javascript:insertContent(4)" ondragstart="dragRBX(4)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/DarkstonegreyBrick.png" border="0" id="img" alt="Dark stone grey 2x4">
      </a>
            <a class="ToolboxItem" title="Medium stone grey 2x4" href="javascript:insertContent(5)" ondragstart="dragRBX(5)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/MediumstonegreyBrick.png" border="0" id="img" alt="Medium stone grey 2x4">
      </a>
            <a class="ToolboxItem" title="White 2x4" href="javascript:insertContent(12)" ondragstart="dragRBX(12)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./bricks/WhiteBrick.png" border="0" id="img" alt="White 2x4">
      </a>
          </div>
        <div id="pNavigation" style="display:table">
      <div class="Navigation">
        <div id="Previous">
          <a href="http://rclient.cf/IDE/ClientToolbox.aspx" id="PreviousPage" style="visibility:hidden"><span class="NavigationIndicators">&lt;&lt;</span>
          Prev</a>
        </div>
        <div id="Next">
          <a href="http://rclient.cf/IDE/ClientToolbox.aspx" id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">1-16 of 16</span>
        </div>
      </div>
    </div>
      </div>
</div></div>
        </div>
    
</body></html>