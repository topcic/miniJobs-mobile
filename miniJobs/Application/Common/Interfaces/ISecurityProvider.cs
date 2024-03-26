namespace Application.Common.Interfaces;

public interface ISecurityProvider
{
    string EncodePassword(string password);
}
