# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS test
WORKDIR /src
# Copy project files and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the source code and publish with a RuntimeIdentifier
COPY . .
RUN dotnet publish -c Release -r linux-x64 -o /app/publish --self-contained false

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS runtime
WORKDIR /app
COPY --from=test /app/publish .
EXPOSE 80
# Replace 'YourApp.dll' with your actual application DLL name
ENTRYPOINT ["dotnet", "YourApp.dll"]
