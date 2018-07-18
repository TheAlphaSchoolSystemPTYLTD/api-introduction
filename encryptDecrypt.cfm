<cfset endPoint        = "http://api.tasscloud.com.au/tassweb/api/">
<cfset method          = "getStudents">
<cfset appCode         = "DEMOAPP">
<cfset companyCode     = "10">
<cfset version         = "2">

<cfset tokenKey        = "x8FWQUedjyiUGlTf5appPQ==">

<cfset parameterString = '{"include_label":"true"}'>

<cfset encryptedString = letsEncrypt(stringToEncrypt=parameterString,tokenKey=tokenKey)>

<cfoutput>

	<p>Original:	#parameterString#</p>
	<p>Encrypted:	#letsEncrypt(stringToEncrypt=parameterString,tokenKey=tokenKey)#</p>
	<p>Decrypted:	#letsDecrypt(stringToDecrypt=encryptedString,tokenKey=tokenKey)#</p>
	<p>URL:			#endpoint#?method=#method#&appcode=#appCode#&company=#companyCode#&v=#version#&token=#urlEncodedFormat(encryptedString)#</p>

</cfoutput>




<cffunction name="letsEncrypt">

	<cfargument name="stringToEncrypt" required="true">
	<cfargument name="tokenKey"        required="true">
	<cfargument name="algorithm"       required="false" default="AES">
	<cfargument name="encoding"        required="false" default="Base64">

	<cfset var encryptedString = Encrypt(
									arguments.stringToEncrypt,
									arguments.tokenKey,
									arguments.algorithm,
									arguments.encoding
								)>

	<cfreturn encryptedString>

</cffunction>

<cffunction name="letsDecrypt">

	<cfargument name="stringToDecrypt" required="true">
	<cfargument name="tokenKey"        required="true">
	<cfargument name="algorithm"       required="false" default="AES">
	<cfargument name="encoding"        required="false" default="Base64">

	<cfset var decryptedString = Decrypt(
									arguments.stringToDecrypt,
									arguments.tokenKey,
									arguments.algorithm,
									arguments.encoding
								)>

	<cfreturn decryptedString>

</cffunction>