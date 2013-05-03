<?php
    include "../general/mySqlTools.php";
	$effdt="";
	$nav="";
	$effdt=$_GET["effdt"];
	$nav=$_GET["nav"];
	$request= "call slaGetHistoData(".$effdt.",".$nav.");";
	$xmlMainChild="sla";
	
	$reponse=doSqlQuery($request);
	buildXMLOutput($xmlMainChild,$reponse);
?>

