/**
* @output false
* @accessors true
* @extends shared.controller.Abstract
*/
component {

	public Upload function init(){
		super.init();		
		return this;
	}

	/**
	* @output false
	* @returnformat JSON
	*/
	remote any function upload(required string qqfile, string location="initiative") {		
		var tmpDir = request.app.asset & arguments.location & "\";		
		createDirectory(location=tmpDir);		
		var x = getHTTPRequestData();	
		if (len(x.content))
			return UploadFileXhr(arguments.qqfile,x.content,arguments.location);	
		var fu = fileUpload(tmpDir,arguments.field, "makeUnique");
		storeImage(file=qqfile, location=arguments.location);
		var msgStruct = {};
		msgStruct['success']= true;
		msgStruct['type']= 'form';
		return serializeJSON(msgStruct);
	}
	
	/**
	* @output false	
	*/
	private any function UploadFileXhr(required string qqfile, required any content, string location="initiative"){
		var tmpDir = request.app.asset & arguments.location & "\";	
		createDirectory(location=tmpDir);
		
		var myFile = tmpDir & qqfile;
		
		if (FileExists(myFile)) {
			qqfile = createUUID() & "_" & qqfile;
			myFile = tmpDir &  qqfile;
		}		
		FileWrite(myFile, content);
		
		storeImage(file=qqfile, location=arguments.location);
					
		var msgStruct = {};
		msgStruct['success']= true;
		msgStruct['type']= 'xhr';
		msgStruct['file']=qqfile;
		return serializeJSON(msgStruct);
	}
	
	private void function storeImage(required string file, required string location){
		var fullPath = request.app.asset & arguments.location & "\" & arguments.file;			
		if(isImageFile(fullPath)) {

			var img = imageRead(fullPath);
			imageScaleToFit(img, 550, 500);			
			
			var watermark = ImageNew("",200,40,"rgb", "##F0F0F0");
			ImageSetDrawingColor(watermark,"##000000");
			ImageDrawRect(watermark, 0, 0, (watermark.GetWidth()-1), (watermark.GetHeight()-1));
			ImageSetAntialiasing(watermark, "on");
			var watermarkAttributes = {font="Arial",Size="20", Style="Italic"};
			ImageDrawtext(watermark,"#request.app.name#.com",15,25,watermarkAttributes);
			ImageSetDrawingTransparency(img,50);
			ImagePaste(img,watermark, (img.getWidth()-watermark.getWidth()-3),(img.getHeight()-watermark.getHeight()-3));	
				
			
			var fullImage = "#request.app.asset##arguments.location#\full_#arguments.file#";
			imageWrite(img,fullImage);	
			
			imageScaleToFit(img, 80, 80);			
			var thumbImage = "#request.app.asset##arguments.location#\thumb_#arguments.file#";
			imageWrite(img,thumbImage);		
			
			fileDelete(fullPath);
									
		}
			
	}

	public void function createDirectory(required string location){
		if (!directoryExists(arguments.location))
    		DirectoryCreate(arguments.location);
    }	
    
    
}