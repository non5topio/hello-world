# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app


FROM build AS test
# Copy project file(s) and restore as distinct layers
COPY hello-world.csproj ./
RUN dotnet restore

# add
#build
#run

FROM test AS publish
# Copy the remaining files and publish the app as a self-contained Linux binary
COPY . ./
RUN dotnet publish -r linux-x64 --self-contained true -c Release -o out

# Use the ASP.NET runtime image (lightweight) for running the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/out .

# Set the entrypoint to run the published binary
ENTRYPOINT ["./hello-world"]
