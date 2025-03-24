# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS test
WORKDIR /src
# Copy only the project file(s) first for caching restore results
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining source code and publish the application in Release configuration
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS runtime
WORKDIR /app
# Copy the published output from the build stage
COPY --from=test /app/publish .
# Expose port 80 (adjust if needed)
EXPOSE 80
# Replace 'YourApp.dll' with the actual name of your app's DLL
ENTRYPOINT ["dotnet", "YourApp.dll"]
