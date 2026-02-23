# run-dev.ps1 (en la raíz, junto al pom.xml)
Get-Content .\docker\.env | ForEach-Object {
    if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
    $name, $value = $_ -split '=', 2
    [System.Environment]::SetEnvironmentVariable($name.Trim(), $value.Trim(), "Process")
}

Write-Host "POSTGRES_DB=$env:POSTGRES_DB"
Write-Host "POSTGRES_USER=$env:POSTGRES_USER"
Write-Host "SPRING_PROFILES_ACTIVE=$env:SPRING_PROFILES_ACTIVE"

# Asegura perfil dev (por si no lo pones en .env)
[System.Environment]::SetEnvironmentVariable("SPRING_PROFILES_ACTIVE", "dev", "Process")

.\mvnw.cmd spring-boot:run