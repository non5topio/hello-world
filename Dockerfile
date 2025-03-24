# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS test
WORKDIR /app

# Copy everything and restore dependencies
COPY . ./
RUN dotnet restore
RUN dotnet test --no-restore

# Build and publish a framework-dependent release (do not include --self-contained true)
RUN dotnet publish -c Release -o out --no-restore

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS runtime
WORKDIR /app

# Copy the published output from the build stage
COPY --from=test /app/out .

# For a console app, use:
ENTRYPOINT ["dotnet", "hello-world.dll"]

# For a self-contained executable, if required and you have an image that supports GLIBC 2.36, 
# you would need to switch to an appropriate base image.
