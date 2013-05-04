<html>
<head>
</head>
<body>
<?php
    include "../general/mySqlTools.php";
	$request= "insert into fieldsTitles (tableName,filedName,titleName,selectType,insertType) values('sla','slaNameUK','Nom Anglais','text','text')";
echo $request;
	doSqlInsUpd($request);
?>
</body>
</html>
