<?php
// An example of encrypting and decrypting your Token and accessing the API using PHP; specifically the getStudentsDetails method.

	// Constants to use when generating API requests - change these as per your TASS API Gateway
	$tokenKey = 'x8FWQUedjyiUGlTf5appPQ==';
	$appCode = 'DEMOAPP';
	$companyCode = '10';
	$apiVersion = '2';
	$method = 'getStudentsDetails';
	$endPoint = 'https://api.tasscloud.com.au/tassweb/api/';
	$parameters =  '{"currentstatus":"current"}';

	function Encrypt($tokenKey, $parameters) {
		$decodedKey = base64_decode($tokenKey);
		$encrypted = openssl_encrypt($parameters, 'aes-128-ecb', $decodedKey, OPENSSL_RAW_DATA);
		$encoded = base64_encode($encrypted);
		return $encoded;
	}

	function Decrypt($tokenKey, $s) {
		$decodedKey = base64_decode($tokenKey);
		$s = base64_decode($s);
		$s = openssl_decrypt($s, 'aes-128-ecb', $decodedKey, OPENSSL_RAW_DATA);
		return $s;
	}

	function getURLRequest($endPoint, $method, $appCode, $companyCode, $apiVersion, $parameters, $tokenKey) {
		$encryptedToken = Encrypt($tokenKey, $parameters);
		$dict = array('method' => $method, 'appcode' => $appCode, 'company' => $companyCode, 'v' => $apiVersion, 'token' => $encryptedToken);
		$URLString = $endPoint . '?';
		foreach($dict as $key => $value) {
			$URLString .= $key;
			$URLString .= '=';
			$URLString .= urlencode($value);
			$URLString .= '&';
		}
		// Trim the last ampersand because it's not necessary
		$URLString = substr($URLString, 0, -1);
		return $URLString;
	}
	
	echo 'Original:   ', $parameters, PHP_EOL;
	echo 'Encrypted:  ', Encrypt($tokenKey, $parameters), PHP_EOL;
	echo 'Decrypted:  ', Decrypt($tokenKey, Encrypt($tokenKey, $parameters)), PHP_EOL;
	echo 'URL:        ', getURLRequest($endPoint, $method, $appCode, $companyCode, $apiVersion, $parameters, $tokenKey), PHP_EOL;
?>