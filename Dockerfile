FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS test

WORKDIR /app

# Copy all files 
COPY . ./

# Restore dependencies
RUN dotnet restore

# Run the tests
CMD ["dotnet", "test", "/p:CollectCoverage=true", "/p:CoverletOutputFormat=cobertura", "/p:Threshold=80"]