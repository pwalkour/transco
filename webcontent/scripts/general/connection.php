<?php
function connect_db()
{
	$host="127.0.0.1";
	$user="root";
	$password="pwalkour12";
	$base="transco";
	$port="8889";
	$mysqli= new mysqli($host,$user,$password,$base,$port);
	return $mysqli;
}
?>