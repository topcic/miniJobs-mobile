# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Kopiraj samo ConsumerService.csproj
COPY ["ConsumerService/ConsumerService.csproj", "ConsumerService/"]

# Restore dependencies
WORKDIR /src/ConsumerService
RUN dotnet restore "ConsumerService.csproj"

# Kopiraj ostatak koda, ali ograni?i na ConsumerService
COPY . .

# Build the application
RUN dotnet build "ConsumerService.csproj" -c Release -o /app/build

# Final stage
FROM mcr.microsoft.com/dotnet/runtime:9.0 AS final # Promijenjeno s aspnet na runtime za manju sliku
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "ConsumerService.dll"]