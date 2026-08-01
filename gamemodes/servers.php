<?
include ('SampQueryAPI.php');  // Сам инклуд, и инфа внутри
$query = new SampQueryAPI('94.198.51.12', '2559'); // Ип, и порт для соединения
$aInformation = $query->getInfo(); // Переменная как в PAWN, чуть отличается от PAWN
$aServerRules = $query->getRules(); 
?>


[
    {
      "color": "FF2B3B",
      "dopname": "",
      "maxonline": <?= $aInformation['maxplayers'] ?>,
      "firstname": "MOSCOW",
      "online": <?= $aInformation['players'] ?>
    }
]