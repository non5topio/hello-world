#
# Build this image with
#
#   docker build -t dotnet-dev:0.0.1 -f Dockerfile .
#
# Create the container with
#
#   docker create --name dotnet-dev dotnet-dev:0.0.1
#
# Run the container with 
#
#   docker start dotnet-dev
#
# To run the image in a throw-away container execute
#
#    docker run --rm --name dotnet-dev -it dotnet-dev:0.0.1
#
# In this case you don't have to create the container.
#
# If you want to overwrite the entrypoint do something like
#
#    docker run --rm --name dotnet-dev -it --entrypoint /bin/bash dotnet-dev:0.0.1
#

# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
# WORKDIR /app

# # Copy everything
# COPY . ./
# # Restore as distinct layers
# RUN dotnet restore
# # Run unit tests (if the tests fail the build process is stopped)
# RUN dotnet test
# # Build and publish a release
# RUN dotnet publish -r linux-x64 --self-contained true -c Release -o out

# # Build runtime image
# FROM mcr.microsoft.com/dotnet/aspnet:6.0
# WORKDIR /app
# COPY --from=build-env /app/out .
# ENTRYPOINT ["./hello-world"]


# FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS base
# WORKDIR /app

# # Copy everything
# COPY . ./
# # Restore as distinct layers
# RUN dotnet restore

# FROM base AS test
# # Expose port (adjust as needed)
# EXPOSE 80

# # Run tests
# CMD dotnet test


## Done

FROM ubuntu:23.04 AS base
WORKDIR /app

# Install prerequisites and Microsoft package signing key
RUN apt-get update && apt-get install -y wget apt-transport-https ca-certificates gnupg2 && \
    wget https://packages.microsoft.com/config/ubuntu/23.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

# Install the .NET SDK 6.0
RUN apt-get update && apt-get install -y dotnet-sdk-6.0

# Copy all files into the container
COPY . ./

# Restore NuGet packages
RUN dotnet restore

FROM base AS test
# Expose a port if required (adjust or remove as needed)
EXPOSE 80

# Run tests when the container starts
CMD ["dotnet", "test"]
