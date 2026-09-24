<?php 

header("Content-Type: text/html; charset=utf-8");

define("DB_HOST","217.182.34.237"); 
define("DB_USER","gs7251");
define("DB_PASS","123456"); 
define("DB_BASE","gs7251");

$m_connect = mysql_connect(DB_HOST, DB_USER, DB_PASS);
mysql_select_db(DB_BASE);

if (0 == $m_connect) {
    echo 'Ошибка: Невозможно установить соединение с MySQL.';
    echo '<br>';
    echo "Код ошибки: " . mysql_errno();
    exit;
}

$confirmation_token = '2cc58da9'; 
$domain = 'https://rio-rp.ru/v_security.php';
$re = "/RRP(\w+)/m";

$data = json_decode(file_get_contents('php://input')); 

switch ($data->type) 
{ 

	case 'confirmation': 
		echo $confirmation_token; 
		break; 


	case 'message_new': 

		echo('ok'); 

		$user_message = $data->object->body;

		if(preg_match($re, $user_message))
		{

			$user_id = $data->object->user_id; 
			$token = '31ff7bbac088c6b63769392a95f75ba6ce57499fc2fe31d65d6c520d2cd74f2a3af1561188a90828beb50'; 
			$random_id = mt_rand(20, 99999999);
			$v = '5.63';


			$query = mysql_query("SELECT * FROM `vk_auth` WHERE `vCode` = '$user_message'");

			if(0 == mysql_num_rows($query))
				$message = 'Секретный код \''. $user_message .'\' не найден!<br>Для подключения \'VK Security\' используйте сайт:<br>'. $domain .'';

			else
			{
				$values = mysql_fetch_row($query);

				if($values[3] != $user_id)
				{
					$message = 'Данный секретный код не принадлежит вашей странице!';

					goto send_message;
				}
				
				if($values[1])
				{
					$message = 'Данный секретный код уже подключён!';

					goto send_message;
				}
				else
					mysql_query("UPDATE `vk_auth` SET `vStatus` = '1' WHERE `vCode` = '$user_message'");

					$message = 'Вы успешно подключили защиту к аккаунту \''. $values[2] .'\'!';
			}

			send_message:

			$message = urlencode($message);
			file_get_contents('https://api.vk.com/method/messages.send?message='. $message .'&user_id='. $user_id .'&access_token='. $token .'&random_id='. $random_id .'&v='. $v .'');

		}

		header('HTTP/1.1 200 OK');

		break; 	
} 
?>