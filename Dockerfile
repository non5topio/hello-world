# Stage 1: Build the application using the official .NET SDK image (Jammy)
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS build
WORKDIR /app
# Copy project file(s) for caching restore results
COPY *.csproj ./
RUN dotnet restore
# Copy all source files and publish the application
COPY . .
RUN dotnet publish -c Release -r linux-x64 -o /app/publish --self-contained false

# Stage 2: Create the runtime image based on Ubuntu 23.04 (has GLIBC 2.36)
FROM ubuntu:23.04 AS test

# Install prerequisites and the ASP.NET Core runtime
RUN apt-get update \
    && apt-get install -y wget ca-certificates gnupg \
    && wget https://packages.microsoft.com/config/ubuntu/23.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y aspnetcore-runtime-6.0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
# Copy the published output from the build stage
COPY --from=build /app/publish .
EXPOSE 80
# Replace 'YourApp.dll' with your actual application DLL name
ENTRYPOINT ["dotnet", "YourApp.dll"]
