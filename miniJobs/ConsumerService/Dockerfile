# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy the project files for ConsumerService
COPY ["ConsumerService/ConsumerService.csproj", "ConsumerService/"]

# Restore dependencies
WORKDIR /src/ConsumerService
RUN dotnet restore "ConsumerService.csproj"

# Copy the rest of the source code
COPY . .

# Build the application
RUN dotnet build "ConsumerService.csproj" -c Release -o /app/build

# Final stage
FROM mcr.microsoft.com/dotnet/runtime:9.0 AS final
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "ConsumerService.dll"]