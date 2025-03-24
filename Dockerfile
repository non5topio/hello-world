# Stage 1: Build and Test
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS test
WORKDIR /app

# Copy everything
COPY . ./

# Restore dependencies with runtime identifier
RUN dotnet restore -r linux-x64

# Run unit tests
RUN dotnet test --no-restore

# Build and publish a release
RUN dotnet publish -r linux-x64 --self-contained true -c Release -o out --no-restore

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS runtime
WORKDIR /app

# Copy built files from the previous stage
COPY --from=test /app/out .

# Set entrypoint
ENTRYPOINT ["./hello-world"]