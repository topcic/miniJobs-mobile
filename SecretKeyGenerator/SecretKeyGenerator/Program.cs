// See https://aka.ms/new-console-template for more information
using System.Security.Cryptography;

Console.WriteLine("Hello, World!");

    // Generate a secure random key
    string randomKey = GenerateRandomKey();
   Console.WriteLine(randomKey);


static string GenerateRandomKey()
{
    // Define the length of the random key (in bytes)
    int keyLength = 32;

    // Create a byte array to store the random key
    byte[] randomBytes = new byte[keyLength];

    // Use RNGCryptoServiceProvider to generate secure random bytes
    using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
    {
        // Fill the byte array with random bytes
        rng.GetBytes(randomBytes);
    }

    // Convert the byte array to a base64 string
    string randomKey = Convert.ToBase64String(randomBytes);

    return randomKey;
}