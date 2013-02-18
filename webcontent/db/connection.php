<?php 
# FileName="Connection_php_mysql.htm" 
# Type="MYSQL" 
# HTTP="true" 
$hostname_ruine = "localhost:8889"; 
$database_ruine = "transco"; 
$username_ruine = "root"; 
$password_ruine = "pwalkour12"; 
$con = mysql_pconnect($hostname_ruine, $username_ruine, $password_ruine) or die(mysql_error()); 
?>