# Database Setup Script for YachtX
# This script helps set up PostgreSQL database for the application

Write-Host "YachtX Database Setup" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host ""

# Check if PostgreSQL is installed
$psqlPath = Get-Command psql -ErrorAction SilentlyContinue
if (-not $psqlPath) {
    Write-Host "ERROR: PostgreSQL (psql) not found in PATH" -ForegroundColor Red
    Write-Host "Please install PostgreSQL or add it to your PATH" -ForegroundColor Yellow
    exit 1
}

Write-Host "PostgreSQL found: $($psqlPath.Source)" -ForegroundColor Green
Write-Host ""

# Prompt for PostgreSQL superuser password
Write-Host "Enter PostgreSQL superuser (postgres) password:" -ForegroundColor Yellow
$securePassword = Read-Host -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Set password in environment
$env:PGPASSWORD = $password

Write-Host ""
Write-Host "Testing connection..." -ForegroundColor Cyan

# Test connection
$testResult = psql -U postgres -c "SELECT version();" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Cannot connect to PostgreSQL" -ForegroundColor Red
    Write-Host "Please check:" -ForegroundColor Yellow
    Write-Host "  1. PostgreSQL service is running" -ForegroundColor Yellow
    Write-Host "  2. Password is correct" -ForegroundColor Yellow
    exit 1
}

Write-Host "Connection successful!" -ForegroundColor Green
Write-Host ""

# Check if database exists
Write-Host "Checking if 'yachtx' database exists..." -ForegroundColor Cyan
$dbExists = psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='yachtx'" 2>&1

if ($dbExists -match "1") {
    Write-Host "Database 'yachtx' already exists" -ForegroundColor Green
    $recreate = Read-Host "Do you want to recreate it? (y/N)"
    if ($recreate -eq "y" -or $recreate -eq "Y") {
        Write-Host "Dropping existing database..." -ForegroundColor Yellow
        psql -U postgres -c "DROP DATABASE IF EXISTS yachtx;" 2>&1 | Out-Null
        Write-Host "Creating new database..." -ForegroundColor Yellow
        psql -U postgres -c "CREATE DATABASE yachtx;" 2>&1 | Out-Null
    }
} else {
    Write-Host "Creating 'yachtx' database..." -ForegroundColor Yellow
    psql -U postgres -c "CREATE DATABASE yachtx;" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to create database" -ForegroundColor Red
        exit 1
    }
    Write-Host "Database created successfully!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Checking for schema files..." -ForegroundColor Cyan

# Check for schema file
if (Test-Path "database\schema.sql") {
    Write-Host "Found schema.sql, applying..." -ForegroundColor Yellow
    psql -U postgres -d yachtx -f database\schema.sql 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Schema applied successfully!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Schema application had errors" -ForegroundColor Yellow
    }
} else {
    Write-Host "WARNING: schema.sql not found in database\ directory" -ForegroundColor Yellow
}

# Check for seed file
if (Test-Path "database\seed.sql") {
    $loadSeed = Read-Host "Do you want to load seed data? (y/N)"
    if ($loadSeed -eq "y" -or $loadSeed -eq "Y") {
        Write-Host "Loading seed data..." -ForegroundColor Yellow
        psql -U postgres -d yachtx -f database\seed.sql 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Seed data loaded successfully!" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "Database setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Update your .env file with:" -ForegroundColor Cyan
Write-Host "  DB_USER=postgres" -ForegroundColor White
Write-Host "  DB_PASSWORD=<your_postgres_password>" -ForegroundColor White
Write-Host ""

# Clear password from environment
$env:PGPASSWORD = ""
