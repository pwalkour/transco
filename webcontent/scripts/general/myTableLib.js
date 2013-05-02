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

function getColumnsTitles(aTableName,callback) {
	var urlData="/transco/webcontent/scripts/general/getColumnsTitles.php?aTable='"+aTableName+"'";
	requestServer(urlData,"GET",true,callback);
}
 
function makeTitleList(aResponseXML,aColumnsTitle) {
	var aNode=aResponseXML.getElementsByTagName('columnsName');
	for (i=0;i<aNode.length;i++) {
		aKey=getOneElementTable(aNode[i],'filedName','');
		aColumnsTitle[aKey]=getOneElementTable(aNode[i],'titleName','');
	}
};