
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS base
WORKDIR /app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore

FROM base AS test
# Expose port (adjust as needed)
EXPOSE 80

# Run tests
CMD dotnet test