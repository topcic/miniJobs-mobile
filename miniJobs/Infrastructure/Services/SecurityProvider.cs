using Application.Common.Interfaces;
using System.Security.Cryptography;
using System.Text;

namespace Infrastructure.Services;

public class SecurityProvider : ISecurityProvider
{
    public string EncodePassword(string password)
    {
        using MD5 md5 = MD5.Create();
        byte[] inputBytes = Encoding.ASCII.GetBytes(password);
        byte[] hashBytes = md5.ComputeHash(inputBytes);

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < hashBytes.Length; i++)
        {
            sb.Append(hashBytes[i].ToString("X2"));
        }
        return sb.ToString();
    }
}
