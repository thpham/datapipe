<?php
 require_once('plugins/login-servers.php');
 
 /** Set supported servers
  * @param array array($description => array("server" => , "driver" => "server|pgsql|sqlite|..."))
  */
 return new AdminerLoginServers(
 	$servers = array(
     "PostgreSQL" => array("server" => "postgres", "driver" => "pgsql"),
     "MongoDB" => array("server" => "mongodb", "driver" => "mongo")
  )
 );