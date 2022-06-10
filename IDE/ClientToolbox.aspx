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
                    	window.external.Insert("http://rclient.cf/Asset/" + id);
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
						window.location.href=(`${value}.aspx`);
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
          <a href="http://rclient.cf/IDE/ClientToolbox2.aspx" " id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">1-20 of 40</span>
        </div>
      </div>
    </div>
        <div id="ToolboxItems">
            <a class="ToolboxItem" title="★★  SAMMY&#39;S BOUNCY HOUSE  ★★" href="javascript:insertContent(11137)" ondragstart="dragRBX(11137)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/323d041e9f509970c90bd7bcaf6c25029cb004ff.png" border="0" id="img" alt="★★  SAMMY&#39;S BOUNCY HOUSE  ★★">
      </a>
            <a class="ToolboxItem" title="3954 stone grey bricks" href="javascript:insertContent(11010)" ondragstart="dragRBX(11010)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/22e7ab1d6fe88314090051b581987dc68aae5ed5.png" border="0" id="img" alt="3954 stone grey bricks">
      </a>
            <a class="ToolboxItem" title="BGR" href="javascript:insertContent(10564)" ondragstart="dragRBX(10564)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/0690385fd6022839ca50ec66857b2ce55712f937.png" border="0" id="img" alt="BGR">
      </a>
            <a class="ToolboxItem" title="VR headset" href="javascript:insertContent(10877)" ondragstart="dragRBX(10877)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/c23157bdb291e23502f5f874a83f81bb63778d81.png" border="0" id="img" alt="VR headset">
      </a>
            <a class="ToolboxItem" title="noob" href="javascript:insertContent(10876)" ondragstart="dragRBX(10876)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/54a8b825de6dbcd36b9e3949f6bab71113b88aae.png" border="0" id="img" alt="noob">
      </a>
            <a class="ToolboxItem" title="ROBLOX Battle: Superball" href="javascript:insertContent(10812)" ondragstart="dragRBX(10812)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/5ed9422bf2a92a0185fd2ba43c8e74e3ca6aa918.png" border="0" id="img" alt="ROBLOX Battle: Superball">
      </a>
            <a class="ToolboxItem" title="roblox battle gears" href="javascript:insertContent(10781)" ondragstart="dragRBX(10781)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/92c363735dd971cfb8819f50ce3c124685a895c4.png" border="0" id="img" alt="roblox battle gears">
      </a>
            <a class="ToolboxItem" title="Welcome to POLYGON" href="javascript:insertContent(10573)" ondragstart="dragRBX(10573)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/22e7ab1d6fe88314090051b581987dc68aae5ed5.png" border="0" id="img" alt="Welcome to POLYGON">
      </a>
            <a class="ToolboxItem" title="sedan" href="javascript:insertContent(10534)" ondragstart="dragRBX(10534)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/0732c6bf8e27e4f851950a64c85726db1a984aaa.png" border="0" id="img" alt="sedan">
      </a>
            <a class="ToolboxItem" title="japaneese car" href="javascript:insertContent(10533)" ondragstart="dragRBX(10533)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/ee10b889db79a6fb5743ba5929d2476393aeca3e.png" border="0" id="img" alt="japaneese car">
      </a>
            <a class="ToolboxItem" title="car" href="javascript:insertContent(10531)" ondragstart="dragRBX(10531)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/824c6681bfc8cf503f57cfef87ee639bd3f02dd1.png" border="0" id="img" alt="car">
      </a>
            <a class="ToolboxItem" title="Mjolnir" href="javascript:insertContent(10501)" ondragstart="dragRBX(10501)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/1b13a7e22a5438491391a7d7ff764e3555ac9e96.png" border="0" id="img" alt="Mjolnir">
      </a>
            <a class="ToolboxItem" title="skkatepark" href="javascript:insertContent(10482)" ondragstart="dragRBX(10482)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/6f21c0024884a79e7dea6cb41f5559aa6bb6c1a0.png" border="0" id="img" alt="skkatepark">
      </a>
            <a class="ToolboxItem" title="cool hoverboard" href="javascript:insertContent(10480)" ondragstart="dragRBX(10480)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/8947a46c7c7542824eb73cdb0c73dc9b0833f30d.png" border="0" id="img" alt="cool hoverboard">
      </a>
            <a class="ToolboxItem" title="water park" href="javascript:insertContent(10486)" ondragstart="dragRBX(10486)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/ea5820da935540712937f528702c83da893a702e.png" border="0" id="img" alt="water park">
      </a>
            <a class="ToolboxItem" title="88592693" href="javascript:insertContent(10484)" ondragstart="dragRBX(10484)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/57ab0bb36822197ddbfc944406c46ef704893b29.png" border="0" id="img" alt="88592693">
      </a>
            <a class="ToolboxItem" title="garage" href="javascript:insertContent(10386)" ondragstart="dragRBX(10386)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/a45cadef117e7610ec2e95882b430f1f15647802.png" border="0" id="img" alt="garage">
      </a>
            <a class="ToolboxItem" title="House" href="javascript:insertContent(10374)" ondragstart="dragRBX(10374)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/1c970398d86ad92b109f1f4cbe2e02f722d6405e.png" border="0" id="img" alt="House">
      </a>
            <a class="ToolboxItem" title="Mr North Pole" href="javascript:insertContent(10370)" ondragstart="dragRBX(10370)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/a9e786b5c339f29f9016d21858bf22c54146855c.png" border="0" id="img" alt="Mr North Pole">
      </a>
            <a class="ToolboxItem" title="Ultimate Bunker" href="javascript:insertContent(10289)" ondragstart="dragRBX(10289)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/a9c41eee81e41fe8e75abc0ced458cc9749f121e.png" border="0" id="img" alt="Ultimate Bunker">
      </a>
          </div>
        <div id="pNavigation" style="display:table">
      <div class="Navigation">
        <div id="Previous">
          <a href="http://rclient.cf/IDE/ClientToolbox.aspx" onclick="getToolbox(&#39;FreeModels&#39;, &#39;&#39;, 0)" id="PreviousPage" style="visibility:hidden"><span class="NavigationIndicators">&lt;&lt;</span>
          Prev</a>
        </div>
        <div id="Next">
          <a href="http://rclient.cf/IDE/ClientToolbox2.aspx" onclick="getToolbox(&#39;FreeModels&#39;, &#39;&#39;, 2)" id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">1-20 of 40</span>
        </div>
      </div>
    </div>
      </div>
</div></div>
        </div>
    
</body></html>