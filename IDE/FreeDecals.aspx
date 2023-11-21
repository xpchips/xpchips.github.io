<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="shortcut icon" href="../favicon.ico" type="image/x-icon">
        <title>RClient - Toolbox</title>
        <script src="./Toolbox_files/jquery-1.4.4.min.js"></script> <!-- <script src="./Toolbox_files/jquery.js.download"></script> !!!!! ("http://rclient.cf/asset/?id=" + id); -->
        <link href="./Toolbox_files/Toolbox.css" type="text/css" rel="stylesheet">
        <script id="Functions" type="text/jscript">
    			function insertContent(id)
    			{
    				try
                	{
                    	window.external.Insert("http://rclient.cf/asset/toolbox/decals/" + id);
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
    					event.dataTransfer.setData("Text", "http://rclient.cf/asset/toolbox/decals/" + id);
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
                        $("#ToolBoxPage").html("");
                        $("#ToolBoxPage").html(data);
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
                        <option value="ClientToolbox">Bricks</option> <!-- 0 -->
                        <option value="Robots">Robots</option> <!-- 1 -->
                        <option value="Chassis">Chassis</option> <!-- 2 -->
                        <option value="Furniture">Furniture</option> <!-- 3 -->
                        <option value="Roads">Roads</option> <!-- 4 -->
                        <option value="Billboards">Billboards</option> <!-- 5 -->
                        <option value="GameObjects">Game Objects</option> <!-- 6 -->
                        <!-- <option value="MyDecals">My Decals</option>  -->                      <option value="FreeDecals" selected="selected">Free Decals</option>
                        <!-- <option value="MyModels">My Models</option>  -->                      <option value="FreeModels">Free Models</option>
                    </select>
					<script>
					function ddlToolboxesHandler(value) {
						window.location.href = value + ".aspx";
						}
					</script>
                </div>
                <div id="pSearch" style="margin-bottom: 6px;">
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
          <a href="https://http://rclient.cf/IDE/FreeDecals.aspx" onclick="getToolbox(&#39;FreeDecals&#39;, &#39;&#39;, 0)" id="PreviousPage" style="visibility:hidden"><span class="NavigationIndicators">&lt;&lt;</span>
          Prev</a>
        </div>
        <div id="Next">
          <a href="https://http://rclient.cf/IDE/FreeDecals.aspx" onclick="getToolbox(&#39;FreeDecals&#39;, &#39;&#39;, 2)" id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">1-20 of 20</span>
        </div>
      </div>
    </div>
        <div id="ToolboxItems">
            <a class="ToolboxItem" title="Logotipo_de_Televisa_(2001-2016) (1)" href="javascript:insertContent(11257)" ondragstart="dragRBX(11257)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/16165545a3be64a55666bc199e226462a0f872a8.png" border="0" id="img" alt="Logotipo_de_Televisa_(2001-2016) (1)">
      </a>
            <a class="ToolboxItem" title="Oxxo" href="javascript:insertContent(11255)" ondragstart="dragRBX(11255)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/89ced71b16b3eeb0836d78731ace622ef0b699ee.png" border="0" id="img" alt="Oxxo">
      </a>
            <a class="ToolboxItem" title="Tanobe huawei back" href="javascript:insertContent(11253)" ondragstart="dragRBX(11253)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/e0607c768a7ddabf8524718ec854525410da5b94.png" border="0" id="img" alt="Tanobe huawei back">
      </a>
            <a class="ToolboxItem" title="Tanobe huawei" href="javascript:insertContent(11251)" ondragstart="dragRBX(11251)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/0fa2dca6083b6c2a7e1acddcd4d37f3327c4f43c.png" border="0" id="img" alt="Tanobe huawei">
      </a>
            <a class="ToolboxItem" title="Tadah newspaper" href="javascript:insertContent(11249)" ondragstart="dragRBX(11249)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/e2eaeb4b09d18cd2f93a0a63b43d91e555848f36.png" border="0" id="img" alt="Tadah newspaper">
      </a>
            <a class="ToolboxItem" title="Skyshutdownxd" href="javascript:insertContent(11247)" ondragstart="dragRBX(11247)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/46790ce4c079f5c49e7ba137544744051a8f3a81.png" border="0" id="img" alt="Skyshutdownxd">
      </a>
            <a class="ToolboxItem" title="Kinerylikestaco" href="javascript:insertContent(11245)" ondragstart="dragRBX(11245)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/592718dad7ff8b008ba919d1f4142b1edd1cb1c7.png" border="0" id="img" alt="Kinerylikestaco">
      </a>
            <a class="ToolboxItem" title="Oshatacostand" href="javascript:insertContent(11243)" ondragstart="dragRBX(11243)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/0cbd9c692754b3bae1469d0c0639a3d840cf091a.png" border="0" id="img" alt="Oshatacostand">
      </a>
            <a class="ToolboxItem" title="Oshatacostand" href="javascript:insertContent(11241)" ondragstart="dragRBX(11241)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/0cbd9c692754b3bae1469d0c0639a3d840cf091a.png" border="0" id="img" alt="Oshatacostand">
      </a>
            <a class="ToolboxItem" title="Kyle wagness" href="javascript:insertContent(11239)" ondragstart="dragRBX(11239)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/afda172d34f345bf6d454b4476de845114d5973a.png" border="0" id="img" alt="Kyle wagness">
      </a>
            <a class="ToolboxItem" title="OshaCola" href="javascript:insertContent(11237)" ondragstart="dragRBX(11237)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/a2e9cd12c41d90f628669299bd31234854a92561.png" border="0" id="img" alt="OshaCola">
      </a>
            <a class="ToolboxItem" title="tadahforthewii" href="javascript:insertContent(11235)" ondragstart="dragRBX(11235)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/75fde38ea503440d1706a2dc7b04d851b0d52fcb.png" border="0" id="img" alt="tadahforthewii">
      </a>
            <a class="ToolboxItem" title="Shrek scary" href="javascript:insertContent(11233)" ondragstart="dragRBX(11233)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/9b685195f41fdfacde553f63be641ce96e9a91b1.png" border="0" id="img" alt="Shrek scary">
      </a>
            <a class="ToolboxItem" title="pink dominus texture" href="javascript:insertContent(11229)" ondragstart="dragRBX(11229)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/e5e7817e98b45136ae0da554bf2c15eaf7ce6640.png" border="0" id="img" alt="pink dominus texture">
      </a>
            <a class="ToolboxItem" title="wiiFront" href="javascript:insertContent(11135)" ondragstart="dragRBX(11135)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/93e3bd59f2e362a5aa5e30f43a691d4d0f611888.png" border="0" id="img" alt="wiiFront">
      </a>
            <a class="ToolboxItem" title="clubsambanner" href="javascript:insertContent(11105)" ondragstart="dragRBX(11105)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/c6b80bb9e6bb08992564bd645bf5e2cb81e17c09.png" border="0" id="img" alt="clubsambanner">
      </a>
            <a class="ToolboxItem" title="wall texture 2" href="javascript:insertContent(10940)" ondragstart="dragRBX(10940)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/0e07babef76f56712abb8842cdc9cdbf976167f3.png" border="0" id="img" alt="wall texture 2">
      </a>
            <a class="ToolboxItem" title="tv news" href="javascript:insertContent(10938)" ondragstart="dragRBX(10938)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/5d0b57805146718c88933814ee1ed6ac60654f8e.png" border="0" id="img" alt="tv news">
      </a>
            <a class="ToolboxItem" title="door texture" href="javascript:insertContent(10936)" ondragstart="dragRBX(10936)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/d1fc32c15902d90e68d65ce49457b9cbd9668f18.png" border="0" id="img" alt="door texture">
      </a>
            <a class="ToolboxItem" title="wall texture 1" href="javascript:insertContent(10934)" ondragstart="dragRBX(10934)" onmouseover="this.style.borderStyle=&#39;outset&#39;" onmouseout="this.style.borderStyle=&#39;solid&#39;" style="border-style: solid;display:inline-block;height:60px;width:60px;cursor:pointer;">
      <img width="60" src="./Toolbox_files/2e277947d18f89fb798688a60628ba336628edbf.png" border="0" id="img" alt="wall texture 1">
      </a>
          </div>
        <div id="pNavigation" style="display:table">
      <div class="Navigation">
        <div id="Previous">
          <a href="https://http://rclient.cf/IDE/FreeDecals.aspx" onclick="getToolbox(&#39;FreeDecals&#39;, &#39;&#39;, 0)" id="PreviousPage" style="visibility:hidden"><span class="NavigationIndicators">&lt;&lt;</span>
          Prev</a>
        </div>
        <div id="Next">
          <a href="https://http://rclient.cf/IDE/FreeDecals.aspx" onclick="getToolbox(&#39;FreeDecals&#39;, &#39;&#39;, 2)" id="NextPage">Next <span class="NavigationIndicators">&gt;&gt;</span></a>
        </div>
        <div id="Location">
          <span id="PagerLocation">1-20 of 20</span>
        </div>
      </div>
    </div>
      </div>
</div></div>
        </div>
    
</body></html>