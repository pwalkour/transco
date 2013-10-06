function CleanTable(tableID) {
    try {
	    var table = document.getElementById(tableID);
	    var rowCount = table.rows.length;
	
	    for(var i=0; i<rowCount; i++) { table.deleteRow(i);
	    }
    }catch(e) { alert(e);
    }
}

function createReadTable(aDivId,aTableId,aColumnsList,aColumnsTitle,aColumnsType,aPaternList) {
    
    var myTableDiv = document.getElementById(aDivId);
     
    var refTable=document.getElementById(aTableId);
    var UpdTable = document.createElement('table');
    UpdTable.border='1';
   
    
    var tableHead = document.createElement('thead');
    UpdTable.appendChild(tableHead);
      
    var tr = document.createElement('tr');
    tableHead.appendChild(tr);

    
    
    for (var i=-1; i<aColumnsList.length; i++){
		var th = document.createElement('th');
		if (i==-1) {
			var aCheckbox = document.createElement('input');
			aCheckbox.type = "checkbox";
			aCheckbox.name = "Action";
			aCheckbox.value = "value";
			aCheckbox.id = "id";

			var aLabel = document.createElement('label')
			aLabel.htmlFor = "id";
			aLabel.appendChild(document.createTextNode('label'));
			
			var aNode=document.createTextNode('Action');
			aNode.type='checkbox';
			th.appendChild(document.createTextNode('Action'));
			
		}else{
			th.appendChild(document.createTextNode(aColumnsTitle[aColumnsList[i]]));
		}
        tr.appendChild(th);
       }
    
   // UpdTable.id=aTableId;
    myTableDiv.appendChild(table);  
}

function createWriteTable(aDivId,aTableId,aColumnsList,aColumnsTitle,aColumnsType,aPaternList) {
    
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

function getColumnsTitles(aTableName,callback,aArray1,aArray2,aArray3) {
	var urlData="/transco/webcontent/scripts/general/getColumnsTitles.php?aTable='"+aTableName+"'";
	requestServer(urlData,"GET",true,callback,aArray1,aArray2,aArray3);
}
 
function makeTitleList(aResponseXML,aColumnsTitle,aColumnsSelectType,aColumnsUpdateType) {
	var aNode=aResponseXML.getElementsByTagName('columnsName');
	for (i=0;i<aNode.length;i++) {
		aKey=getOneElementTable(aNode[i],'filedName','');
		aColumnsTitle[aKey]=getOneElementTable(aNode[i],'titleName','');
		aColumnsSelectType[aKey]=getOneElementTable(aNode[i],'selectType','');
		aColumnsUpdateType[aKey]=getOneElementTable(aNode[i],'insertType','');
	}
}

function makeReadTable(XMLData,divId,tableId) {
	var columnsPattern="";
	if(columnsList.length==0) {
		getXMLColumnNode(XMLData,'columns',columnsList,columnsType,columnsOrder);
		for (i=0;i<columnsList.length;i++) {
			
		}
		createReadTable(divId,tableId,columnsList,columnsTitle,columnsSelectType,columnsPattern);        
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

