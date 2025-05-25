FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["WorkerService.csproj", "."]
COPY ["../miniJobs/Infrastructure/Infrastructure.csproj", "Infrastructure/"]
RUN dotnet restore "WorkerService.csproj"
COPY . .
COPY ["../miniJobs/Infrastructure", "Infrastructure/"]
WORKDIR "/src"
RUN dotnet build "WorkerService.csproj" -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "WorkerService.dll"]