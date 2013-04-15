<?php
    include "../general/sqlTools.php";
	$effdt="";
	$nav="";
	$effdt=$_GET["effdt"];
	$nav=$_GET["nav"];
	$request= "call slaGetHistoData(".$effdt.",".$nav.");";
	$xmlMainChild="sla";
	
	buildXML($xmlMainChild,$request);
	
?>

