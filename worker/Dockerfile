FROM mcr.microsoft.com/dotnet/sdk:10.0 AS builder

WORKDIR /app

COPY Worker.csproj Worker.csproj
RUN dotnet restore

COPY Program.cs Program.cs

RUN dotnet publish -c release --self-contained false --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine AS runtime

WORKDIR /app

RUN addgroup -g 1001 -S appuser && adduser -S appuser -G appuser -u 1001

COPY --from=builder --chown=appuser:appuser /app/* .

USER appuser

ENTRYPOINT ["dotnet", "release/net10.0/Worker.dll"]
