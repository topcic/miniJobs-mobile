namespace Application.Common.Methods;

public static class GenerateCode
{
    public static string Generate()
    {
        Random random = new Random();
        return random.Next(1000, 10000).ToString();
    }
}
