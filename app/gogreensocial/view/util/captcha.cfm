<plait:use layout="none" />
<html>
	<body>
	<div id="captchaDisplay">
	<div class="form_control">	
		<label for="userCaptcha">Captcha Text:</label>
		<input type="text" name="np:captcha[userCaptcha]" id="userCaptcha" value=""/><br>		
		<label>&nbsp;</label>
		<cfimage
			action="captcha"
			width="150"
			text="#session.captcha.systemCaptcha()#"
			difficulty="low" 
			fonts="verdana,arial,times new roman,courier"
			fontsize="18"/>
		<img src="/public/images/icons/refresh_48.png" onclick="loadCaptcha();" width="30px" title="refresh captcha">		
	</div>	
	</div>		
	</body>
</html>