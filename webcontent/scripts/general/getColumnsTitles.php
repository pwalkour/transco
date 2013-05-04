<?php
    include "../general/mySqlTools.php";
	$aTable="";
	$aTable=$_GET["aTable"];
	$request= "call getColumnsTitles(".$aTable.");";
	$xmlMainChild="columnsName";
	$reponse=doSqlQuery($request);
	buildXMLOutput($xmlMainChild,$reponse);

?>
