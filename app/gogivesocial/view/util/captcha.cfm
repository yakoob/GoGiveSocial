<plait:use layout="none" />
<body>
	<div id="captchaDisplay">
		<div class="form_control">	
			<label for="userCaptcha">Captcha Text:</label>
			<input type="text" name="np:captcha[userCaptcha]" id="userCaptcha" value=""/><br>			
			<cfimage
				action="captcha"
				width="150"
				text="#session.captcha.systemCaptcha()#"
				difficulty="low" 
				fonts="verdana,arial,times new roman,courier"
				fontsize="18"/>
			<span style="padding:5px;"><img src="/public/images/icons/refresh_48.png" onclick="loadCaptcha();" width="30px" title="refresh captcha"></span>
		</div>			
	</div>		
</body>
