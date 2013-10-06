
function getOneElement(aReference,aKey,aType) {
	$returnStr='';
	// xx=aReference.getElementsByTagName(aKey);
     {
     try {
         if (aType=="") { $returnStr= aReference.firstChild.nodeValue ; }
         else { $returnStr= '<'+aType+'>' + aReference.firstChild.nodeValue + '</'+aType+'>'; }
     }catch (er) { $returnStr = '<td>&nbsp;</td>'; }
     }
     return $returnStr;
}

function getXMLColumnNode(aXML,aKey,aColumnList,aColumnsType,aColumnsOrder){
	var aNode=aXML.getElementsByTagName(aKey);
	var c = aNode[0].firstChild;
	j=0;
	while (c) {
		if ( c.nodeType == 1) { // 1 = ELEMENT_NODE
			aColumnList[j]=c.nodeName;
			aSubNode=aXML.getElementsByTagName(c.nodeName);
			d=c.firstChild;
			while (d){
				if(d.nodeType==1){
					if(d.nodeName=='type'){ aColumnsType[c.nodeName]=d.firstChild.nodeValue; }
					if(d.nodeName=='position'){ aColumnsOrder[c.nodeName]=d.firstChild.nodeValue; }
				}
				d=d.nextSibling;
			}
			j++;
		}
	    c = c.nextSibling;
	}
}