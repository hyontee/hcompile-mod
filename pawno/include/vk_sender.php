<?



$message = $_GET['message'];
$user_id = $_GET['to'];

$token = '31ff7bbac088c6b63769392a95f75ba6ce57499fc2fe31d65d6c520d2cd74f2a3af1561188a90828beb50';

$message = iconv("cp1251", "utf-8", $message);
$message = urlencode($message);

$curl = curl_init();
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($curl, CURLOPT_URL, 'https://api.vk.com/method/messages.send?user_id='. $user_id .'&message='. $message .'&access_token='. $token .'&v=5.63');
$response = curl_exec($curl);
curl_close($curl);

echo $response;

