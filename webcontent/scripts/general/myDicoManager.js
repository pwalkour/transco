function DoAction(aType,aDate,aNavigate,aAction) {
	//if(columnsName.length==0) {
	switch(aAction) {
		case 'select':
			document.getElementById(aType+'Action').value='select';
			getDailyData(aType,aDate,aNavigate,doTable);
			break;
		case 'modify':
			document.getElementById(aType+'Action').value='modify';
			modifyDailyData(aType,aDate,aNavigate,doTable);
			break;
		case 'update':
			document.getElementById(aType+'Action').value='update';
			upDate (aType,aDate,aNavigate);
			break;
		case 'write':
			tableAsXML=getTableAsXML(aType+'TableCRUD');
			break;
		case 'add':
			DoAction(aType,aDate,aNavigate,'write');
			a=1;
			break;
		case 'delete':
			break;
	}
}

function getDailyData(aType,aDate,aNavigate,callback) {
	var urlDailyData="./scripts/"+aType+"/get"+capitaliseFirstLetter(aType)+"DailyData.php?effdt='"+aDate+"'&nav='"+aNavigate+"'";
	document.getElementById('tutu').value=urlDailyData;
	requestServer(urlDailyData,"GET",false,callback,aType);
}

function modifyDailyData(aType) {
	var DivRefId=aType+'InfoTbl';
	var SelectTableId=aType+'Read';
	var div = document.getElementById(DivRefId);
	var tableRead = document.getElementById(SelectTableId);
	var tableModify // create the modify table for columns patternlist
	
	
	
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
function createModifyTable(aDivId,aTableId,aColumnsList,aColumnsTitle) {
    
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