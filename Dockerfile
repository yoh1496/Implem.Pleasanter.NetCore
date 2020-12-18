FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:5000 \
    ASPNETCORE_ENVIRONMENT=Development \
    TZ=Asia/Tokyo
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

WORKDIR /src
COPY ["Implem.Pleasanter.NetCore.sln", "Implem.Pleasanter.NetCore.sln"]
COPY ["Implem.Pleasanter.NetCore/*.csproj", "Implem.Pleasanter.NetCore/"]
COPY ["Implem.CodeDefiner.NetCore/*.csproj", "Implem.CodeDefiner.NetCore/"]
COPY ["Implem.CodeDefiner/*.csproj", "Implem.CodeDefiner/"]
COPY ["Implem.Factory/*.csproj", "Implem.Factory/"]
COPY ["Implem.Pleasanter/*.csproj", "Implem.Pleasanter/"]
COPY ["Rds/Implem.IRds/*.csproj", "Rds/Implem.IRds/"]
COPY ["Rds/Implem.PostgreSql/*.csproj", "Rds/Implem.PostgreSql/"]
COPY ["Rds/Implem.SqlServer/*.csproj", "Rds/Implem.SqlServer/"]
COPY ["Implem.DefinitionAccessor/*.csproj", "Implem.DefinitionAccessor/"]
COPY ["Implem.DisplayAccessor/*.csproj", "Implem.DisplayAccessor/"]
COPY ["Implem.Libraries/*.csproj", "Implem.Libraries/"]
COPY ["Implem.ParameterAccessor/*.csproj", "Implem.ParameterAccessor/"]

RUN dotnet restore "Implem.Pleasanter.NetCore.sln"

COPY ["Implem.Pleasanter.NetCore/", "Implem.Pleasanter.NetCore/"]
COPY ["Implem.CodeDefiner.NetCore/", "Implem.CodeDefiner.NetCore/"]
COPY ["Implem.CodeDefiner/", "Implem.CodeDefiner/"]
COPY ["Implem.Factory/", "Implem.Factory/"]
COPY ["Implem.Pleasanter/", "Implem.Pleasanter/"]
COPY ["Rds/Implem.IRds/", "Rds/Implem.IRds/"]
COPY ["Rds/Implem.PostgreSql/", "Rds/Implem.PostgreSql/"]
COPY ["Rds/Implem.SqlServer/", "Rds/Implem.SqlServer/"]
COPY ["Implem.DefinitionAccessor/", "Implem.DefinitionAccessor/"]
COPY ["Implem.DisplayAccessor/", "Implem.DisplayAccessor/"]
COPY ["Implem.Libraries/", "Implem.Libraries/"]
COPY ["Implem.ParameterAccessor/", "Implem.ParameterAccessor/"]

RUN dotnet build "Implem.Pleasanter.NetCore.sln" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Implem.Pleasanter.NetCore.sln" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

CMD [ "dotnet", "Implem.Pleasanter.NetCore.dll" ]