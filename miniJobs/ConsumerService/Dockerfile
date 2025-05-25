FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["ConsumerService/ConsumerService.csproj", "."]
COPY ["/Infrastructure/Infrastructure.csproj", "Infrastructure/"]
RUN dotnet restore "ConsumerService/ConsumerService.csproj"
COPY . .
COPY ["/Infrastructure", "Infrastructure/"]
WORKDIR "/src"
RUN dotnet restore "Infrastructure/Infrastructure.csproj"
RUN dotnet build "ConsumerService/ConsumerService.csproj" -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "ConsumerService/ConsumerService.dll"]