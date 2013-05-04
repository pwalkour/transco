function DoAction(aType,aDate,aNavigate,aAction) {
	//if(columnsName.length==0) {
	switch(aAction) {
		case 'select':
			document.getElementById(aType+'Action').value='select';
			getDailyData(aType,aDate,aNavigate,doTable);
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
	requestServer(urlDailyData,"GET",true,callback,aType);
}

