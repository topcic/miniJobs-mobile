# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy the project files for ConsumerService and Infrastructure
COPY ["ConsumerService/ConsumerService.csproj", "ConsumerService/"]
COPY ["Infrastructure/Infrastructure.csproj", "Infrastructure/"]
COPY ["Application/Application.csproj", "Application/"]

# Restore dependencies for ConsumerService (which may reference Infrastructure)
WORKDIR /src/ConsumerService
RUN dotnet restore "ConsumerService.csproj"

# Copy the rest of the source code
COPY . .

# Build the application
RUN dotnet build "ConsumerService.csproj" -c Release -o /app/build

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "ConsumerService.dll"]