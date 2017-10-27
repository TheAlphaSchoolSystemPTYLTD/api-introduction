using System;
using System.Security.Cryptography;

public class TestEncrypt
{
	
	const String tokenKey = "+TG1ZTqy0hTu5h0KMhCP0A==";
	
	public static void Main()
	{
		string original = "{\"include_label\":\"true\"}";
		string expectedOutput = "96yfUt3jgAIYx0o7i3tjprnBpotNO3Md/yv+eToJ8qo=";
		
		var UTF8 = new System.Text.UTF8Encoding();
		var encString = Encrypt( original );
		
		Console.WriteLine("Original:   {0}", original );
		Console.WriteLine("Expected:   {0}", expectedOutput);
		Console.WriteLine("Encrypted:  {0}", encString );
		Console.WriteLine("Decrypted:  {0}", Decrypt( encString ) );
		
	}

 	public static string Encrypt (string toEncrypt)
    {
        var UTF8 = new System.Text.UTF8Encoding();
		
		// The Token Key is already Base64.
		byte[] keyArray   	  = Convert.FromBase64String(tokenKey);
		
		// The Paramater String is UTF8.
        byte[] toEncryptArray = UTF8.GetBytes(toEncrypt);

        RijndaelManaged rDel  = new RijndaelManaged();
        rDel.Key              = keyArray;
        rDel.Mode             = CipherMode.ECB;
        rDel.BlockSize        = 128;
        rDel.Padding   		  = PaddingMode.PKCS7;

        ICryptoTransform cTransform  = rDel.CreateEncryptor( keyArray , null );

        byte[] resultArray    = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
		
		return Convert.ToBase64String(resultArray, 0, resultArray.Length);
    }

    public static string Decrypt (string toDecrypt)
    {
        var UTF8 = new System.Text.UTF8Encoding();
		
		// The Token Key is already Base64.
		byte[] keyArray  	  = Convert.FromBase64String(tokenKey);
		
		// The encrypted string is already Base64.
        byte[] toEncryptArray = Convert.FromBase64String(toDecrypt);

        RijndaelManaged rDel  = new RijndaelManaged();
        rDel.Key              = keyArray;
        rDel.Mode             = CipherMode.ECB;
        rDel.BlockSize        = 128;
        rDel.Padding    	  = PaddingMode.PKCS7;
	
        ICryptoTransform cTransform = rDel.CreateDecryptor( keyArray , null );

        byte[] resultArray    = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

        return UTF8.GetString(resultArray);
    }	
}