<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Save</title>
		<style>
			body { background-color: window; padding-right:10px; }
			*
			{
				font-size: 13px;
				font-family: Arial, Helvetica, sans-serif;
			}
			H1
			{
				font-weight: bold;
				font-size: larger;
			}
			a:hover
			{
				color: purple;
			}

		</style>
		<script type="text/javascript" src="./upload_files/jquery-1.7.2.min.js"></script>
	</head>
	<body scroll="no">
		<script type="text/javascript">				
			function newPlace()
			{
				document.getElementById("Default").style.display = 'none';
				document.getElementById("NewPlace").style.display = 'block';
			}

			function updatePlace()
			{
				document.getElementById("Default").style.display = 'none';
				document.getElementById("ExistingPlace").style.display = 'block';
			}

			function cancel()
			{
				document.getElementById("NewPlace").style.display = 'none';
				document.getElementById("ExistingPlace").style.display = 'none';
				document.getElementById("Default").style.display = 'block';
			}

			function publish(PlaceID)
			{
				if(PlaceID == undefined) PlaceID = 0;
				var name = $.trim($("#Name").val());
				var desc = $.trim($("#Description").val());
				var free = $("#PublicDomain").is(":checked");
				
				if(!PlaceID)
				{
					if(!name.length){ alert("Place Name cannot be empty"); return false; }
					if(name.length > 50){ alert("Place Name cannot longer than 50 characters"); return false; }
					//if(!desc.length){ alert("Place Description cannot be empty"); return false; }
					if(desc.length > 1000){ alert("Place Description cannot longer than 1000 characters"); return false; }
				}

				$("#NewPlace").hide();
				$("#ExistingPlace").hide();
				$("#Uploading").show();

				try 
				{
                    window.external.Write().Upload('https://rclient.cf/IDE/Upload.aspx?PlaceID='+PlaceID+'&Name='+encodeURI(name)+'&Description='+encodeURI(desc)+'&PublicDomain='+free);
                    $("#Uploading").hide();
                    $("#Uploaded").show();
               	}
                catch(e) 
                {
                	if (e.message == "ud")
                	{
                		$("#Uploading").hide();
                    	$("#Uploaded").show();
                	}
                	else
                	{
                		$("#Uploading").hide();
                		$("#Error").show();
                		$("#ErrorLabel").text(e.message);
                		if(!PlaceID)
                		{
                			$("NewPublishError").show();
                		}
                		else
                		{
                			$("UpdatePublishError").show();
                		}
                	}
                }
			}
		</script>
		<div id="Default" style="display: block;">
			<table height="100%" cellpadding="12" width="100%">
				<tbody><tr valign="top">
					<td colspan="2">
						<p>You are about to publish this Place to RClient. Please choose how you would like to save your work:</p>
					</td>
				</tr>
								<tr valign="top">
					<td width="120"><input class="OKCancelButton" style="WIDTH: 100%" type="button" value="Update" onclick="updatePlace();"></td>
					<td><strong>Update an existing Place on RClient.</strong> <br> Choose this to make changes to a Place you have previously created. You will have the opportunity to select which Place you wish to update.</td>
				</tr>
								<tr valign="top">
					<td width="120"><input class="OKCancelButton" style="WIDTH: 100%" onclick="window.close(); return false" type="button" value="Cancel"></td>
					<td><strong>Keep playing and exit later.</strong></td>
				</tr>
			</tbody></table>
		</div>
		<div id="NewPlace" style="display:none">
			<table height="100%" width="100%" style="padding-top:12px">
				<tbody><tr valign="top">
					<td width="70" align="right">Name:</td>
					<td><input type="text" style="width:100%" id="Name" value="Upload&#39;s Place Number: 6"></td>
				</tr>
				<tr valign="top">
					<td width="70" align="right">Description:</td>
					<td><textarea rows="13" style="width:100%" id="Description"></textarea></td>
				</tr>
				<tr valign="top">
					<td width="70"></td>
					<td>
						<input type="checkbox" id="PublicDomain">
						<label for="PublicDomain">Publish for free public use.</label>
					</td>
				</tr>
				<tr valign="top" align="right">
					<td width="70"></td>
					<td>
						<input type="button" value="Publish" id="Publish" onclick="publish()">
						<input type="button" value="Cancel" id="Cancel" onclick="cancel()">
					</td>
				</tr>
			</tbody></table>
		</div>
		<div id="ExistingPlace" style="margin-top: 4%; display: none;">
			<!--span>To scroll down, press the TAB key.</span><br/-->
			<span>Select the Place you wish to update: <a href="https://rclient.cf/IDE/Upload.aspx#" onclick="cancel()">Cancel</a></span><br><br>
						<span><a href="https://rclient.cf/IDE/Upload.aspx#" onclick="publish(10613)">Select</a> Place 1</span><br>
						<span><a href="https://rclient.cf/IDE/Upload.aspx#" onclick="publish(10608)">Select</a> Place 2</span><br>
						<span><a href="https://rclient.cf/IDE/Upload.aspx#" onclick="publish(10607)">Select</a> Place 3</span><br>
						<span><a href="https://rclient.cf/IDE/Upload.aspx#" onclick="publish(10606)">Select</a> Place 4</span><br>
						<span><a href="https://rclient.cf/IDE/Upload.aspx#" onclick="publish(10605)">Select</a> Place 5</span><br>
					</div>
		<div id="Uploading" style="font-weight: bold; color: royalblue; margin-top: 5%; display:none;">Uploading. Please wait...</div>
		<div id="Error" style="display:none">
			<table height="100%" width="100%">
				<tbody><tr valign="top">
					<td colspan="2" height="270">
						<p style="color: red; margin-top: 5%;">Upload Failed!  - <span id="ErrorLabel"></span></p>
						<p style="color: red; margin-top: 5%; display:none;" id="NewPublishError">Happened multiple times? Try saving to file and uploading on the website at Develop -&gt; Create New Place</p>
						<p style="color: red; margin-top: 5%; display:none;" id="UpdatePublishError">Happened multiple times? Try saving to file and uploading on the website in your place settings at Configure -&gt; Templates</p>
					</td>
				</tr>
				<tr valign="bottom" align="right">
					<td width="70"></td>
					<td>
						<input type="button" value="Close" onclick="window.close(); return false">
					</td>
				</tr>
			</tbody></table>
		</div>
		<div id="Uploaded" style="display:none">
			<table height="100%" width="100%">
				<tbody><tr valign="top">
					<td colspan="2" height="270">
						<p>The upload has completed!</p>
					</td>
				</tr>
				<tr valign="bottom" align="right">
					<td width="70"></td>
					<td>
						<input type="button" value="Close" onclick="window.close(); return false">
					</td>
				</tr>
			</tbody></table>
		</div>
	
</body></html>