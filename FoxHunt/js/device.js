var cameraAvailable = false;
var logEvents = false;
var logElement = "#msg";

window.addEventListener('message', function (event) {
	if(logEvents) 
		logevent(logElement,event);
	if (event.data.cameraEnabled) {
      cameraAvailable = true;
    }	
	if(event.data.name){
		jQuery(document).trigger(event.data.name.split(",")[0], event.data.data);
	}
	
  //if (event.origin == "file://") {

	if (event.data.image) {
	  if($("#msg").length > 0){
		  image = $("<img/>");
		  $("#msg").prepend(image);
		  image.attr("src", "data:image/jpg;base64," + event.data.image);
	  }
	  
	  if($("#upload").length > 0){
		sendBlob(event.data.image);
	  }
    } else if (event.error) {
      alert("Error! " + event.error);
    }
	
  //}

}, false);


function device(funcName,options,callback){
	var funcOptions = funcName;
	if(options)
		funcOptions = funcName + "," + options;
	window.parent.postMessage(funcOptions,'file://'); 
	if(callback)
		$(document).one(funcName,callback);
	return false;
}

function logevent(logElement,event){
	if($(logElement).length > 0){
		$(logElement).show();
		var txt = $(logElement).text();
		$(logElement).html(txt + ", " + replaceAll(JSON.stringify(event),"{","{"));
	}
}

function deviceBind(funcName,options,callback){
	device(funcName,options);
	if(callback)
		$(document).off(funcName).on(funcName,callback);
	return false;
}

function sendBlob(myblob){
	var fileAry = [];
	fileAry[0]=dataURItoBlob( 'data:image/jpg;base64,'+myblob);
	fileAry[0].name = ""+Math.floor((Math.random() * 10000000000) + 1)+".jpg";
	fileAry[0].lastModifiedDate = new Date();
	
	$("#upload").fileupload('add', {files: fileAry});
	setTimeout(function(){
		  image = $("<img/>");
		  image.css("top", "15px");
		  image.css("height", "48px");
		  image.css("left", "32px");
		  image.css("position", "absolute");
		  image.css("z-index", "100");
		  
		  $("#upload").find("canvas").last().before(image);
		  image.attr("src", 'data:image/jpg;base64,' + myblob);
		  $("#upload").find("canvas").last().hide();
	},500);
}

function blob2canvas(canvas,blob){
    var img = $("<img/>")[0];
    var ctx = canvas.getContext('2d');
	img.onload = function () {
        ctx.drawImage(img,0,0);
    }
    img.src = blob;
}

function takepic(){
	if (cameraAvailable){
		device("camera.getPicture",
			"destinationType:0,quality:75,targetWidth:2000,targetHeight:2000",
			function(e,imageData){
				if (imageData) {
				  if($("#msg").length > 0){
					  image = $("<img/>");
					  $("#msg").prepend(image);
					  image.attr("src", "data:image/jpg;base64," + imageData);
				  }
				  
				  if($("#upload").length > 0){
					sendBlob(imageData);
				  }
				} else if (d.error) {
				  alert("Error! " + d.error);
				}			
			}
		);
		return true;
	}
	return false;
}

function getPosition(){
    device("gps");
}

function dataURItoBlob(dataURI) {
    var binary = atob(dataURI.split(',')[1]);
    var array = [];
    for(var i = 0; i < binary.length; i++) {
        array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], {type: 'image/jpeg'});
}

function escapeRegExp(string) {
    return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function replaceAll(string, find, replace) {
  return string.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}