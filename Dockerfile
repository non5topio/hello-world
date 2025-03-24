# Stage 1: Build and Test
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS test
WORKDIR /app

# Copy everything
COPY . ./

# Restore dependencies
RUN dotnet restore

# Run unit tests (if the tests fail, the build process stops)
RUN dotnet test --no-restore

# Build and publish a release
RUN dotnet publish -r linux-x64 --self-contained true -c Release -o out --no-restore

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

# Copy built files from the previous stage
COPY --from=test /app/out .

# Set entrypoint
ENTRYPOINT ["./hello-world"]
