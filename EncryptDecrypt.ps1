# Author: Sam Fisher (Information Systems Officer, St Joseph's College Gregory Terrace)
# Date Created: 2018-07-11

# Based on a C# example by @ricardorusson 
# https://github.com/TheAlphaSchoolSystemPTYLTD/api-introduction/blob/master/encryptDecrypt.cs

# This script shows how to encrypt and decrypt the token, and generates a URL for a HTTPS GET request. 
# In this particular example, we are using the Student Details Public API and are retrieving all current students. 

# Set these as required.

# Generated in TASS API Gateway Maintenance program.
$tokenKey    = 'x8FWQUedjyiUGlTf5appPQ=='

# Specified upon API setup in TASS API Gateway Maintenance program.
$appCode     = 'DEMOAPP'

# TASS company to work with (see top right of TASS.web).
$companyCode = '10'

# TASS API version.
$apiVersion  = '2'

# TASS API method.
$method      = "getStudentsDetails"

# TASS API endpoint.
$endpoint    = "http://api.tasscloud.com.au/tassweb/api/"

# Parameters to pass through in API call.
$parameters  = '{"currentstatus":"current"}'


# Function to generate encrypted token to use in the API call.

function Get-TASSEncryptedToken($TokenKey, $Parameters)
{
    # Convert encryption token from Base64 encoding to byte array.
    $keyArray = [System.Convert]::FromBase64String($TokenKey)

    # Store the string to be encrypted as a byte array.
    $toEncryptArray = [System.Text.Encoding]::UTF8.GetBytes($Parameters)

    # Create a cryptography object with the necessary settings.
    $rDel = New-Object System.Security.Cryptography.RijndaelManaged
    $rDel.Key = $keyArray
    $rDel.Mode = [System.Security.Cryptography.CipherMode]::ECB
    $rDel.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $rDel.BlockSize = 128;

    # Encrypt, return as a byte array, and convert to a Base 64 encoded string. 
    $cTransform = $rDel.CreateEncryptor($keyArray, $null)
    [byte[]]$resultArray = $cTransform.TransformFinalBlock($toEncryptArray, 0, $toEncryptArray.Length)
    $resultBase64 = [System.Convert]::ToBase64String($resultArray, 0, $resultArray.Length)

    # Return as Base 64 encoded string. 
    return $resultBase64
}


# Function to decrypt and encrypted token used in the API call.

function Get-TASSDecryptedToken($TokenKey, $EncryptedToken)
{
    # Convert encryption token from Base64 encoding to byte array.
    $keyArray = [System.Convert]::FromBase64String($TokenKey)

    # Store the string to be decrypted as a byte array.
    $toDecryptArray = [System.Convert]::FromBase64String($EncryptedToken)

    # Create a cryptography object with the necessary settings.
    $rDel = new-Object System.Security.Cryptography.RijndaelManaged
    $rDel.Key = $keyArray
    $rDel.Mode = [System.Security.Cryptography.CipherMode]::ECB
    $rDel.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $rDel.BlockSize = 128;

    # Decrypt, return as a byte array, and convert to a UTF-8 encoded string. 
    $cTransform = $rDel.CreateDecryptor($keyArray, $null)
    [byte[]]$resultArray = $cTransform.TransformFinalBlock($toDecryptArray, 0, $toDecryptArray.Length)
    $resultString = [System.Text.Encoding]::UTF8.GetString($resultArray)
    
    # Return UTF-8 encoded string. 
    return $resultString
}


# Function to generate a HTTPS GET request URL. 

function Get-TASSUrlRequest ($Endpoint, $Method, $AppCode, $CompanyCode, $ApiVersion, $Parameters, $TokenKey)
{
    # Encrypt the token.
    $encryptedToken = Get-TASSEncryptedToken -tokenKey $TokenKey -parameters $Parameters
    
    # Import the System.Web assembly and use it to URL encode the encrypted token.
    Add-Type -AssemblyName System.Web
    $encryptedTokenUrlEncoded = [System.Web.HttpUtility]::UrlEncode($encryptedToken)
    
    # Build the URL.
    $requestURL = "{0}?method={1}&appcode={2}&company={3}&v={4}&token={5}" -f $Endpoint, $Method, $AppCode, $CompanyCode, $ApiVersion, $encryptedTokenUrlEncoded 
    
    # Return the generated URL.
    return $requestURL
}


# Demonstration output.

$demoEncrypted = Get-TASSEncryptedToken -TokenKey $tokenKey -Parameters $parameters
$demoDecrypted = Get-TASSDecryptedToken -TokenKey $tokenKey -EncryptedToken $demoEncrypted

Write-Output "Original String: $parameters"
Write-Output "Encrypted: $demoEncrypted"
Write-Output "Decrypted: $demoDecrypted"


# Generate a sample URL based on parameters above.

Get-TASSUrlRequest -Endpoint $endpoint -Method $method -AppCode $appCode -CompanyCode $companyCode -ApiVersion $apiVersion -Parameters $parameters -TokenKey $tokenKey

