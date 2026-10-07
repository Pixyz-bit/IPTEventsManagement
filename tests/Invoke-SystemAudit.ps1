param([switch]$KeepDatabase)
$ErrorActionPreference = 'Stop'
$appRoot = Join-Path (Split-Path $PSScriptRoot -Parent) '241611JalopEventsManagement'
$auditName = 'JalopAudit_' + [Guid]::NewGuid().ToString('N')
$auditRoot = Join-Path $env:TEMP $auditName
$sqlcmd = 'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/SQLCMD.EXE'
$server = '(localdb)\MSSQLLocalDB'
$created = $false
try {
    [void](New-Item -ItemType Directory -Path $auditRoot)
    $schema = [IO.File]::ReadAllText((Join-Path $appRoot 'Backend/Database/Migration/07_FinalDatabaseSchema.sql')).Replace('UniversityEventDB', $auditName)
    $schemaPath = Join-Path $auditRoot 'schema.sql'
    [IO.File]::WriteAllText($schemaPath, $schema)
    & $sqlcmd -S $server -d master -E -l 10 -t 20 -b -i $schemaPath
    if ($LASTEXITCODE -ne 0) { throw 'Isolated database creation failed.' }
    $created = $true
    $procedures = [IO.File]::ReadAllText((Join-Path $appRoot 'Backend/Database/StoredProcedures/00_InstallAll.sql')).Replace('USE [UniversityEventDB];', "USE [$auditName];")
    if ($procedures.Contains('USE [UniversityEventDB]')) { throw 'Unsafe procedure database target.' }
    $procedurePath = Join-Path $auditRoot 'procedures.sql'
    [IO.File]::WriteAllText($procedurePath, $procedures)
    & $sqlcmd -S $server -d $auditName -E -l 10 -t 20 -b -i $procedurePath
    if ($LASTEXITCODE -ne 0) { throw 'Isolated procedure installation failed.' }
    Copy-Item -LiteralPath (Join-Path $appRoot 'bin') -Destination $auditRoot -Recurse
    $runner = Join-Path $auditRoot 'bin/SystemAudit.exe'
    $assembly = Join-Path $auditRoot 'bin/241611JalopEventsManagement.dll'
    & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe "/out:$runner" "/reference:$assembly" /reference:System.Data.dll /reference:System.Configuration.dll /reference:System.Core.dll (Join-Path $PSScriptRoot 'SystemAudit.cs')
    if ($LASTEXITCODE -ne 0) { throw 'Audit compilation failed.' }
    $connection = "Data Source=$server;Initial Catalog=$auditName;Integrated Security=True;Encrypt=False;Connect Timeout=5;Pooling=True;"
    [IO.File]::WriteAllText(($runner + '.config'), '<configuration><connectionStrings><add name="UniversityEventDBConnection" connectionString="' + $connection + '" /></connectionStrings></configuration>')
    & $runner
    if ($LASTEXITCODE -ne 0) { throw 'Audit runner failed.' }
} finally {
    # Only the randomly named database created by this run may be removed.
    if ($created -and !$KeepDatabase -and $auditName -match '^JalopAudit_[a-f0-9]{32}$') {
        & $sqlcmd -S $server -d master -E -l 10 -t 20 -b -Q "ALTER DATABASE [$auditName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$auditName];"
        if ($LASTEXITCODE -ne 0) { Write-Warning "Disposable audit database cleanup failed: $auditName" }
    }
    Write-Output "Audit artifacts: $auditRoot. Existing application database was not used."
}
