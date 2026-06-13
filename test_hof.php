<?php
require 'autoloader.php';
require 'GameEngine/config.php';
require 'GameEngine/Database.php';
$db = new MYSQLi_DB(SQL_SERVER, SQL_USER, SQL_PASS, SQL_DB, SQL_PORT);
$res = mysqli_query($db->dblink, 'DESCRIBE '.TB_PREFIX.'hall_of_fame');
if(!$res) echo mysqli_error($db->dblink);
while($r=mysqli_fetch_assoc($res)) { echo print_r($r, true); }
