<?php
/*Author: Liam Stevens (ICT Analyst, St Joseph's College Gregory Terrace)
Created on: 21/8/2018

Based on a C# example by @ricardorusson and PS example by @sam-fisher:
https://github.com/TheAlphaSchoolSystemPTYLTD/api-introduction/blob/master/encryptDecrypt.cs
https://github.com/TheAlphaSchoolSystemPTYLTD/api-introduction/blob/master/EncryptDecrypt.ps1

An example of encrypting and decrypting your Token and accessing the API using PHP; specifically the getStudentsDetails method.*/

//Constants to use when generating API requests - change these as per your TASS API Gateway
	$tokenKey = 'x8FWQUedjyiUGlTf5appPQ==';
	$appCode = 'DEMOAPP';
	$companyCode = '10';
	$apiVersion = '2';
	$method = 'GetStudentsDetails';
	$endPoint = 'http://api.tasscloud.com.au/tassweb/api/';
	$parameters = "{\"currentstatus\":\"current\"}";

	function Decrypt($s){
		global $tokenKey;

		if ($s == "") { return $s; }
		// Turn the cipherText into a ByteArray from Base64
		try {
		$decodedKey = base64_decode($tokenKey);
		$s = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $decodedKey, $s, MCRYPT_MODE_ECB);
		} catch(Exception $e) {
		// There is a problem with the string, perhaps it has bad base64 padding
		// Do Nothing
		}
		return $s;
	}

	function Encrypt($s){
		global $tokenKey;

		$decodedKey = base64_decode($tokenKey);
		// Have to pad if it is too small
		$block = mcrypt_get_block_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_ECB);
		$pad = $block - (strlen($s) % $block);
		$s .= str_repeat(chr($pad), $pad);
		$encrypted = mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $decodedKey, $s, MCRYPT_MODE_ECB);
		$encoded = base64_encode($encrypted);
		return $encoded;
	}

	function getURLRequest($endPoint, $method, $appCode, $companyCode, $apiVersion, $parameters, $tokenKey) {
		$encryptedkey = Encrypt($parameters);
		$dict = array('method'=>$method, 'appcode'=>$appCode, 'company'=>$companyCode, 'v'=>$apiVersion, 'token'=>$encryptedkey);
		$keys = array_keys($dict);
		$URLString = $endPoint . '?';
		foreach($keys as $value) {
			$URLString .= $value;
			$URLString .= '=';
			$URLString .= urlencode($dict[$value]);
			$URLString .= '&';
		}
		#Trim the last ampersand because it's not necessary
		$URLString = substr($URLString, 0, -1);
		#Echo for example purposes, remove this in production
		echo $URLString;
		return $URLString;
	}

?>