FROM mcr.microsoft.com/dotnet/sdk:6.0 AS test
WORKDIR /app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Run unit tests (if the tests fail the build process is stopped)
RUN dotnet test
# Build and publish a release
RUN dotnet publish -r linux-x64 --self-contained true -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=test /app/out .
ENTRYPOINT ["./hello-world"]