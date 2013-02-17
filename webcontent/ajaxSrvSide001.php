<?php
//include_once "connection.php";
function connect_db()
{
	$host="127.0.0.1";
	$user="myuser";
	$password="mypassword";
	$base="mydb";
	$port="9999";
	$mysqli= new mysqli($host,$user,$password,$base,$port);
	return $mysqli;
}

	$effdt="";
	$effdt=$_GET["effdt"];
	
	$mysqli=connect_db();
	
	if ($mysqli->connect_errno) {
	    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
	}
	
	$request= "call getSlaHistoData(".$effdt.");";
	if (!($res=$mysqli->query($request, MYSQLI_STORE_RESULT))) {
	    echo "call procedure failed: (" . $mysqli->errno . ") " . $mysqli->error;
	}
	
	//create the xml document
	$slaXmlDoc = new DOMDocument();
	
	//create the root element
	$slaXmlRoot = $slaXmlDoc->appendChild(
			$slaXmlDoc->createElement("slas"));
	$couter_check=0;
	
	// populate XML
	while($a_row = $res->fetch_array(MYSQLI_ASSOC)) {
	
		$couter_check++;
		//create a sla element
		$slaDataElement = $slaXmlRoot->appendChild($slaXmlDoc->createElement("sla"));
		$slaDataElement->appendChild($slaXmlDoc->createElement("id_sla",(0+$a_row['id_sla'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("effdt",$a_row['effdt']));
		$slaDataElement->appendChild($slaXmlDoc->createElement("serial",(0+$a_row['serial'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("is_used",(0+$a_row['is_used'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("sla_name_fr",("".$a_row['sla_name_fr'])));
		$slaDataElement->appendChild($slaXmlDoc->createElement("sla_name_uk",("".$a_row['sla_name_uk'])));	
	}
	// default sla if no records in table
	if ($couter_check==0) {
		$slaDataElement = $slaXmlRoot->appendChild($slaXmlDoc->createElement("sla"));
		$slaDataElement->appendChild($slaXmlDoc->createElement("id_sla",1));
		$slaDataElement->appendChild($slaXmlDoc->createElement("effdt","1900-01-01"));
		$slaDataElement->appendChild($slaXmlDoc->createElement("serial",1));
		$slaDataElement->appendChild($slaXmlDoc->createElement("is_used",0));
		$slaDataElement->appendChild($slaXmlDoc->createElement("sla_name_fr",""));
		$slaDataElement->appendChild($slaXmlDoc->createElement("sla_name_uk",""));
	}
	// print response to stdout
	header('Content-Type: text/xml');
	$slaXmlDoc->formatOutput = true;
	echo $slaXmlDoc->saveXML();
?>

