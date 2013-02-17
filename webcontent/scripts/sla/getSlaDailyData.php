<?php
	include "../general/connection.php";
	$effdt="";
	$nav="";
	$effdt=$_GET["effdt"];
	$nav=$_GET["nav"];
	
	
	$mysqli=connect_db();
	
	if ($mysqli->connect_errno) {
	    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
	}
	
	$request= "call getSlaHistoData(".$effdt.",".$nav.");";
	if (!($res=$mysqli->query($request, MYSQLI_STORE_RESULT))) {
	    echo "call procedure failed: (" . $mysqli->errno . ") " . $mysqli->error;
	}
	
	//create the xml document
	$slaXmlDoc = new DOMDocument();
	
	//create the root element
	$slaXmlRoot = $slaXmlDoc->appendChild(
			$slaXmlDoc->createElement("slas"));
	
	// populate XML
	while($a_row = $res->fetch_array(MYSQLI_ASSOC)) {
		//create a sla element
		$slaDataElement = $slaXmlRoot->appendChild($slaXmlDoc->createElement("sla"));
		$slaDataElement->appendChild($slaXmlDoc->createElement("id_sla",(0+$a_row['id_sla'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("effdt",$a_row['effdt']));
		$slaDataElement->appendChild($slaXmlDoc->createElement("serial",(0+$a_row['serial'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("is_used",(0+$a_row['is_used'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("sla_name_fr",("".$a_row['sla_name_fr'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("sla_name_uk",("".$a_row['sla_name_uk'])));	
	}
	// print response to stdout
	header('Content-Type: text/xml');
	$slaXmlDoc->formatOutput = true;
	echo $slaXmlDoc->saveXML();
?>

