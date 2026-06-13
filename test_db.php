<?php
$c = @new mysqli('db', 'root', 'rootpassword', 'travian', 3306);
if ($c->connect_error) {
    echo 'FAIL: ' . $c->connect_error;
} else {
    echo 'SUCCESS! Server: ' . $c->server_info;
}
