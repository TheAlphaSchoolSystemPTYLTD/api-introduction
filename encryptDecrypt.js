'use strict';
const https = require('https');
const crypto = require('crypto');

/* 

    Special thansk to Ben Nadel
    https://www.bennadel.com/blog/3118-using-aes-ecb-pkcs5padding-encryption-in-coldfusion-and-decrypting-values-in-node-js.htm

*/

const tokenKey      = "x8FWQUedjyiUGlTf5appPQ==";
const appCode       = "DEMOAPP";
const companyCode   = "10";
const version       = "2";
const method        = "getStudents";
const endPoint      = "https://api.tassweb.com.au/tassweb/api/index.cfm";
let parameterString = '{"currentstatus":"current"}';


var encrypt = function( parameterString , tokenKey ) {

    var binaryEncryptionKey = new Buffer.from( tokenKey, "base64" );

    var cipher = crypto.createCipheriv( "AES-128-ECB", binaryEncryptionKey, Buffer.alloc(0) );

    var encryptedString = (
        cipher.update( parameterString, "utf8", "base64" ) +
        cipher.final( "base64" )
    );

    return encryptedString;
};

var decrypt = function( encryptedInput , tokenKey ) {

    var binaryEncryptionKey = new Buffer.from( tokenKey, "base64" );
    var binaryIV = new Buffer.from( '' );

    var decipher = crypto.createDecipheriv( "AES-128-ECB", binaryEncryptionKey, binaryIV );

    // When decrypting we're converting the Base64 input to UTF-8 output.
    var decryptedString = (
        decipher.update( encryptedInput, "base64", "utf8" ) +
        decipher.final( "utf8" )
    );

    return decryptedString;
};

var constructRequest = function() {

    var token = encodeURIComponent( encrypt ( parameterString , tokenKey ) );

    return endPoint + '?appcode=' + appCode +'&v=' + version + '&method=' + method + '&company=' + companyCode + '&token=' + token; 

};

var makeAPIRequest = function(){

    var requestURL = constructRequest();

    https.get( requestURL , (resp) => {

        if ( resp.statusCode === 200 ) {
        
            let data = '';

            resp.on('data', (chunk) => {
                data += chunk;
            });

            resp.on('end', () => {

                let searchResponse = JSON.parse(data);

                console.log( searchResponse );

            });

        } else {

            console.log( "Error: " + resp.statusCode );

        }

    }).on("error", (err) => {

        console.log("Error: " + err.message);

    });

}
console.log( 'Original Paramater String : ' + parameterString );
console.log( 'Encrypted Paramater String : ' + encrypt ( parameterString , tokenKey ) );
console.log( 'Decrypted Paramater String : ' + decrypt ( encrypt ( parameterString , tokenKey ) , tokenKey ) );
console.log( 'Request URL : ' + constructRequest() );

makeAPIRequest();

