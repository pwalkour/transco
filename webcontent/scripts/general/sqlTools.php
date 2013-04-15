<?php 
function initConnection()
{
	$host="127.0.0.1";
	$user="root";
	$password="pwalkour12";
	$base="transco";
	$port="8889";
	$connection= new mysqli($host,$user,$password,$base,$port);
	return $connection;
}

function getColumnsArray($result) {
	$columnsList=array();

	/* Get field information for all columns */
	$finfo = $result->fetch_fields();
	foreach ($finfo as $val) {
		$columnsList[$val->name]=$val->type;
	}
	return $columnsList;
}

function buildXML($xmlMainChild,$request) {
	$columnsArrayNames=array();
	$columnList="";
	$separator="";
	
	$mysqli=initConnection();
	if ($mysqli->connect_errno) {
		echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
	}

	if (!($res=$mysqli->query($request, MYSQLI_STORE_RESULT))) {
		echo "call procedure failed: (" . $mysqli->errno . ") " . $mysqli->error;
	}
	
	// get column metadata
	$columnsArrayNames=getColumnsArray($res) ;
	foreach ($columnsArrayNames as $aKey=>$aVal) {
		$columnList.=$separator.$aKey;
		$separator=",";
	}
	//create the root element
	//create the xml document
	$aXMLDoc = new DOMDocument();
	$aXMLRoot = $aXMLDoc->appendChild($aXMLDoc->createElement($xmlMainChild."s"));
	$aXMLDataElement = $aXMLRoot->appendChild($aXMLDoc->createElement("columns"));
	$aXMLDataElement->appendChild($aXMLDoc->createElement("columnlist",$columnList));
	
	// populate XML
	while($a_row = $res->fetch_array(MYSQLI_ASSOC)) {
		//create a sla element
		$aXMLDataElement = $aXMLRoot->appendChild($aXMLDoc->createElement($xmlMainChild));
	
		foreach($columnsArrayNames as $aKey=>$aVal) {
			switch ($aVal) {
				case 3: // int
					$aXMLDataElement->appendChild($aXMLDoc->createElement($aKey,(0+$a_row[$aKey])));
					break;
				default : // all other
					$aXMLDataElement->appendChild($aXMLDoc->createElement($aKey,$a_row[$aKey]));
					break;
			}
		}
	}
	// print response to stdout
	header('Content-Type: text/xml');
	$aXMLDoc->formatOutput = true;
	echo $aXMLDoc->saveXML();
}
?>