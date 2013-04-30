
function createTable(aDivId,aTableId,aColumnsList) {
    
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
        th.appendChild(document.createTextNode(aColumnsList[i]));
        tr.appendChild(th);
       }
    myTableDiv.appendChild(table);  
}
