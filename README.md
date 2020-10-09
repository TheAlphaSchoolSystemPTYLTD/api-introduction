# api-introduction
A basic introduction to the TASS APIs.

**Examples**

  * encryptDecrypt.cs - A basic C# Encrypt and Decrypt class example
  * POST.html - A HTML page with a form
  * GET.html - A HTML page with an anchor
  * DELPHI POST Example Function - A Delphi Example ([@filebound](https://github.com/filebound))
  * EncryptDecrypt.ps1 - PowerShell Encrypt and Decrypt ([@sam-fisher](https://github.com/sam-fisher))
  * encryptDecrypt.cfm - CFML Encrypt and Decrypt example ([@ajdyka](https://github.com/ajdyka))
  * encryptDecrypt.py - Python Encrypt and Decrypt example ([@liamstevens](https://github.com/liamstevens))
  * encryptDecrypt3.py - Python3 Encrypt and Decrypt example ([@liamstevens](https://github.com/liamstevens))
  * encryptDecrypt.php - PHP Encrypt and Decrypt example ([@liamstevens](https://github.com/liamstevens), [@jtc](https://github.com/jtc))
  * encryptDecrypt.js - Node.js Encrypt, Decrypt and HTTPS call example ([@ricardorusson](https://github.com/ricardorusson))
 
**Request URL Construction**

* **Overview**

	The request URL is constructed using several parts.

	```HTML
	{protocol}://{domain}/tassweb/api/?method={method}&appcode={appcode}&company={companycode}&v={version}&token={token}
	````

* **Protocol**

	The protocol is defined in the TASS API Setup in TASS.web. As of TASS v49, this is set to restrict requests to HTTPS only.

* **Domain**

	The domain of the TASS.web server you wish to make the request to.

* **Method**

	The API Method you wish to invoke.

* **App Code**

	The App Code as defined in the TASS.web TASS API Setup.

* **Company Code**

	The Company Code for which the TASS API App has been configured in TASS.web.
	

* **Version**

	**- Version 1** APIs utilise Query String Format for the parameter string.
	
	```JAVASCRIPT
	param1=value1&param2=value2
	```
	
	
	**- Version 2** APIs utilise JSON Format for the parameter string.
	
	```JAVASCRIPT
	{
		"param1":"value1"
		, "param2":"value2"
	}
	```
	
	
	**- Version 3** APIs also utilise JSON Format, and require a **Security Role** to be defined in the setup for the API that grantes the requisite permission point as defined in the assiciated documentation.
	
	E.g. The method **IdM > [addAdminUserRoles](https://github.com/TheAlphaSchoolSystemPTYLTD/IdM/blob/master/AddAdminUserRoles.md)** method requires a **Security Role** that is configured for the following permission:
	
	```JAVASCRIPT
	Administration > User Maintenance > Add
	```
	
	***IMPORTANT*** It is not possible to mix different versions of an API in the same configuration. Any API that is configured in TASS.web with a **Security Role** will only support Version 3 requests. Please confirm with the relevant API documentation that the API supports Version 3 before assigning a **Security Role** in the setup.
	
* **Token**

	The token is generated by encrypting the parameter string with your Token Key.

	```JAVASCRIPT
	Encrypt( '{"include_label":"true"}'
	, '+TG1ZTqy0hTu5h0KMhCP0A=='
	, 'AES/ECB/PKCS5Padding'
	, 'Base64')
	```

	Expected Token

	```HTML
	96yfUt3jgAIYx0o7i3tjprnBpotNO3Md/yv+eToJ8qo=
	```

	Expected Token (URL Encoded for GET)

	```HTML
	96yfUt3jgAIYx0o7i3tjprnBpotNO3Md%2Fyv%2BeToJ8qo%3D
	```

* **Error Codes**

	Please refer to HTTP response headers for correct error codes and messages as IIS may reformat or replace JSON responses with standard error templates.
