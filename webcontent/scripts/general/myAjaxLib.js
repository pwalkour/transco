function loadXMLString(txt2xml) 
{
if (window.DOMParser)
  {
  parser=new DOMParser();
  xmlDoc=parser.parseFromString(txt2xml,"text/xml");
  }
else // Internet Explorer
  {
  xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
  xmlDoc.async=false;
  xmlDoc.loadXML(txt2xml); 
  }
return xmlDoc;
}

function requestServer(aURL,aMode,aSync,callback) {
	var XMLHTTPObject;
	if (window.XMLHttpRequest) { XMLHTTPObject=new XMLHttpRequest(); }// code for IE7+, Firefox, Chrome, Opera, Safari 
	else { XMLHTTPObject=new ActiveXObject('Microsoft.XMLHTTP'); } // code for IE6, IE5 	
	
	XMLHTTPObject.onreadystatechange=function() {
		if (XMLHTTPObject.readyState==4 && XMLHTTPObject.status==200) { callback(XMLHTTPObject.responseXML); }
	}
	XMLHTTPObject.open(aMode,aURL,aSync);
	XMLHTTPObject.send();
}