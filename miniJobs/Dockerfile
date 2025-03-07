FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 7126

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY "./WebAPI.csproj" "./"
RUN dotnet restore "./WebAPI.csproj"
COPY . . 
WORKDIR "/src/WebAPI"
RUN dotnet build "./WebAPI.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
RUN dotnet publish "./WebAPI.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ConnectionStrings__DefaultConnection="Server=db,1433;Database=miniJobs;User=sa;Password=Word5678?;TrustServerCertificate=True;Encrypt=False;"
ENV ConnectionStrings__DefaultConnectionHangfire="Server=db,1433;Database=miniJobs_hangfire;User=sa;Password=Word5678?;TrustServerCertificate=True;Encrypt=False;"
ENV RABBITMQ_HOST=rabbitmq
ENV RABBITMQ_USERNAME=guest
ENV RABBITMQ_PASSWORD=guest
ENV RABBITMQ_VIRTUALHOST=/

ENTRYPOINT ["dotnet", "WebAPI.dll"]
