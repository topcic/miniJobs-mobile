FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project files, adjusting paths for the new context
COPY WorkerService/WorkerService.csproj ./WorkerService/
COPY miniJobs/Infrastructure/Infrastructure.csproj ./Infrastructure/

# Restore dependencies
RUN dotnet restore ./WorkerService/WorkerService.csproj

# Copy source
COPY WorkerService/. ./WorkerService/
COPY miniJobs/Infrastructure/. ./Infrastructure/

# Build
WORKDIR /src/WorkerService
RUN dotnet build "WorkerService.csproj" -c Release -o /app/build

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "WorkerService.dll"]