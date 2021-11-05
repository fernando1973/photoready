<?php
require "predis/autoload.php";
Predis\Autoloader::register();

try {
	// This connection is for a remote server
	$redis = new Predis\Client(array(
	    "scheme" => "tcp",
	    "host" => "redis-leader",
	    "port" => 6379
	));
}
catch (Exception $e) {
	die($e->getMessage());
}

// sets message to contian "Hello world"
(!$redis->exists('message')) ? $redis->set('message', 'Hello world') : "";

// gets the value of message
$value = $redis->get('message');

// Hello world
print($value); 
print("    ");

echo ($redis->exists('message')) ? "Oui" : "please populate the message key";