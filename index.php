<?php
require "vendor/autoload.php";
Predis\Autoloader::register();

try {
	// This connection is for a remote server
	$redis = new Predis\Client(array(
	    "scheme" => "tcp",
	    "host" => "redis-leader",
	    "port" => 6379
	));

	// Connecting, selecting database
	$flyway_pass = $_ENV["FLYWAY_PASSWORD"];
}
catch (Exception $e) {
	die($e->getMessage());
}

echo "<!DOCTYPE html>\n";
echo "<html>\n";
echo "<head>\n";
echo "<link rel='stylesheet' href='css/tables.css'>\n";
echo "</head>\n";
echo "<body>\n";

if (!$redis->exists('persons')) {
	echo "Getting from postgres</br></br>";

    // TODO: Changing hostmane, user and dbname by ENV vars
	$dbconn = pg_connect("host=acid-photoready dbname=photoready user=photoready password=$flyway_pass sslmode=require")
	    or die('Could not connect: ' . pg_last_error());

	try {
		// Performing SQL query
		$query = 'SELECT * FROM photoready.people';
		$result = pg_query($query) or die('Query failed: ' . pg_last_error());

		while ($data = pg_fetch_object($result)) {
			$redis->hmset("person_$data->code", [
				'name' => $data->name,
				'role' => $data->role
			]);
			$redis->sadd("persons", "person_$data->code");
		}

		// Free resultset
		pg_free_result($result);
	} finally {
		// Closing connection
		pg_close($dbconn);
	}

}

// Printing results in HTML
echo "<table>\n";
$persons = $redis->smembers("persons");
foreach ($persons as $person) {
	$data = $redis->hgetall($person);
    echo "\t<tr>\n";
    echo "\t\t<td>$data[name]</td><td>$data[role]</td>\n";
    echo "\t</tr>\n";
}
echo "</table>\n";

echo "</body>\n";
echo "</html>\n";

?>
