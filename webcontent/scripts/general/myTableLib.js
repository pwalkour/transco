function CleanTable(tableID) {
    try {
	    var table = document.getElementById(tableID);
	    var rowCount = table.rows.length;
	
	    for(var i=0; i<rowCount; i++) { table.deleteRow(i);
	    }
    }catch(e) { alert(e);
    }
}

function createTable(aDivId,aTableId,aColumnsList,aColumnsTitle) {
    
    var myTableDiv = document.getElementById(aDivId);
     
    var table = document.createElement('table');
    table.border='1';
    table.id=aTableId;
    
    var tableHead = document.createElement('thead');
    table.appendChild(tableHead);
      
    var tr = document.createElement('tr');
    tableHead.appendChild(tr);
       
    for (var i=0; i<aColumnsList.length; i++){
		var th = document.createElement('th');
        th.appendChild(document.createTextNode(aColumnsTitle[aColumnsList[i]]));
        tr.appendChild(th);
       }
    myTableDiv.appendChild(table);  
}

function getColumnsTitles(aTableName,callback,aArray) {
	var urlData="/transco/webcontent/scripts/general/getColumnsTitles.php?aTable='"+aTableName+"'";
	requestServer(urlData,"GET",true,callback,aArray);
}
 
function makeTitleList(aResponseXML,aColumnsTitle) {
	var aNode=aResponseXML.getElementsByTagName('columnsName');
	for (i=0;i<aNode.length;i++) {
		aKey=getOneElementTable(aNode[i],'filedName','');
		aColumnsTitle[aKey]=getOneElementTable(aNode[i],'titleName','');
	}
}

function makeReadTable(XMLData,divId,tableId) {
	if(columnsList.length==0) {
		getXMLColumnNode(XMLData,'columns',columnsList,columnsType,columnsOrder); 
		createTable(divId,tableId,columnsList,columnsTitle);        
    }
}

function doTable(responseXMLData,aType) {
	var DivRefId=aType+'InfoTbl';
	var SelectTableId=aType+'Read';
	var div = document.getElementById(DivRefId);

	makeReadTable(responseXMLData,DivRefId,SelectTableId);
	var tableRead = document.getElementById(SelectTableId);
	var rowCount = tableRead.rows.length -1;
	for (h=rowCount;h>0;h--){
		tableRead.deleteRow(h);
	}
	xDailyData=responseXMLData.documentElement.getElementsByTagName(aType);
	for (i=0;i<xDailyData.length;i++) {
	    var rowCount = tableRead.rows.length;
	    var row = tableRead.insertRow(rowCount);
	    var colCount = tableRead.rows[0].cells.length;
	    for(var j=0; j<colCount; j++) {
	        var newcell = row.insertCell(j);
	        newcell.innerHTML=getOneElementTable(xDailyData[i],columnsList[j],'');;
	    }
	}
	document.getElementById('effdt').value=getOneElementTable(xDailyData[0],'effdt','');
}