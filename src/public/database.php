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

	// Connecting, selecting database
	$dbconn = pg_connect("host=acid-photoready dbname=photoready user=photoready password=k3YAhKUWHi4TZtzfiv55PwPvwI2FPVfV8uSnIOSxwuUzmigERaMCaP5ZhJv550TR sslmode=require")
	    or die('Could not connect: ' . pg_last_error());
}
catch (Exception $e) {
	die($e->getMessage());
}

// Performing SQL query
$query = 'SELECT * FROM photoready.people';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

// Printing results in HTML
echo "<table>\n";
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

// Free resultset
pg_free_result($result);

// Closing connection
pg_close($dbconn);


// sets message to contian "Hello world"
(!$redis->exists('message')) ? $redis->set('message', 'Hello world') : "";

// gets the value of message
$value = $redis->get('message');

// Hello world
print($value); 
print("    ");

echo ($redis->exists('message')) ? "Oui" : "please populate the message key";

?>