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

function requestServer(aURL,aMode,aSync,callback,callbackParam1,callbackParam2,callbackParam3) {
	var nbrParams=0;
	nbrParams += typeof callbackParam1 !== 'undefined' ? 1 : 0;
	nbrParams += typeof callbackParam2 !== 'undefined' ? 1 : 0;
	nbrParams += typeof callbackParam3 !== 'undefined' ? 1 : 0;
	var XMLHTTPObject;
	if (window.XMLHttpRequest) { XMLHTTPObject=new XMLHttpRequest(); }// code for IE7+, Firefox, Chrome, Opera, Safari 
	else { XMLHTTPObject=new ActiveXObject('Microsoft.XMLHTTP'); } // code for IE6, IE5 	
	
	XMLHTTPObject.onreadystatechange=function() {
		if (XMLHTTPObject.readyState==4 && XMLHTTPObject.status==200) { 
			switch (nbrParams) {
			case 1:
				callback(XMLHTTPObject.responseXML,callbackParam1);
				break;
			case 2:
				callback(XMLHTTPObject.responseXML,callbackParam1,callbackParam2);
				break;
			case 3:
				callback(XMLHTTPObject.responseXML,callbackParam1,callbackParam2,callbackParam3);
				break;
			}
			
		}
	}
	XMLHTTPObject.open(aMode,aURL,aSync);
	XMLHTTPObject.send();
}