# run-dev.ps1 (root)
$envFile = ".\docker\.env"
$composeFile = ".\docker\docker-compose.yml"   # ajusta si se llama distinto

# Export env vars for this process (optional, sirve para mvn)
Get-Content $envFile | ForEach-Object {
    if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
    $name, $value = $_ -split '=', 2
    [System.Environment]::SetEnvironmentVariable($name.Trim(), $value.Trim(), "Process")
}

[System.Environment]::SetEnvironmentVariable("SPRING_PROFILES_ACTIVE", "dev", "Process")

Write-Host "POSTGRES_DB=$env:POSTGRES_DB"
Write-Host "POSTGRES_USER=$env:POSTGRES_USER"
Write-Host "SPRING_PROFILES_ACTIVE=$env:SPRING_PROFILES_ACTIVE"

# 1) Levanta Docker (Postgres)
docker compose --env-file $envFile -f $composeFile up -d

# 2) Corre la app
.\mvnw.cmd spring-boot:run