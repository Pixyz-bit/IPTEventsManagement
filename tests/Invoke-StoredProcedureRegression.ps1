param([switch]$KeepDatabase)
$ErrorActionPreference = 'Stop'
$appRoot = Join-Path (Split-Path $PSScriptRoot -Parent) '241611JalopEventsManagement'
$spTestName = 'JalopStoredProcedureTest_' + [Guid]::NewGuid().ToString('N')
$spTestRoot = Join-Path $env:TEMP $spTestName
$sqlcmd = 'C:/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/SQLCMD.EXE'
$server = '(localdb)\MSSQLLocalDB'
$created = $false
try {
    [void](New-Item -ItemType Directory -Path $spTestRoot)
    $schema = [IO.File]::ReadAllText((Join-Path $appRoot 'Backend/Database/Migration/07_FinalDatabaseSchema.sql')).Replace('UniversityEventDB', $spTestName)
    $schemaPath = Join-Path $spTestRoot 'schema.sql'
    [IO.File]::WriteAllText($schemaPath, $schema)
    & $sqlcmd -S $server -d master -E -l 10 -t 20 -b -i $schemaPath
    if ($LASTEXITCODE -ne 0) { throw 'Isolated schema creation failed.' }
    $created = $true
    $procedures = [IO.File]::ReadAllText((Join-Path $appRoot 'Backend/Database/StoredProcedures/00_InstallAll.sql')).Replace('USE [UniversityEventDB];', "USE [$spTestName];")
    if ($procedures.Contains('USE [UniversityEventDB]')) { throw 'Unsafe procedure database target.' }
    $procedurePath = Join-Path $spTestRoot 'procedures.sql'
    [IO.File]::WriteAllText($procedurePath, $procedures)
    & $sqlcmd -S $server -d $spTestName -E -l 10 -t 20 -b -i $procedurePath
    if ($LASTEXITCODE -ne 0) { throw 'Isolated procedure installation failed.' }
    Copy-Item -LiteralPath (Join-Path $appRoot 'bin') -Destination $spTestRoot -Recurse
    $runner = Join-Path $spTestRoot 'bin/StoredProcedureRegression.exe'
    $assembly = Join-Path $spTestRoot 'bin/241611JalopEventsManagement.dll'
    & 'C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe' /nologo /target:exe "/out:$runner" "/reference:$assembly" /reference:System.Data.dll /reference:System.Configuration.dll /reference:System.Core.dll (Join-Path $PSScriptRoot 'StoredProcedureRegression.cs')
    if ($LASTEXITCODE -ne 0) { throw 'Integration runner compilation failed.' }
    $connection = "Data Source=$server;Initial Catalog=$spTestName;Integrated Security=True;Encrypt=False;Connect Timeout=5;Pooling=True;"
    [IO.File]::WriteAllText(($runner + '.config'), '<configuration><connectionStrings><add name="UniversityEventDBConnection" connectionString="' + $connection + '" /></connectionStrings></configuration>')
    & $runner
    if ($LASTEXITCODE -ne 0) { throw 'Stored-procedure integration checks failed.' }
} finally {
    if ($created -and !$KeepDatabase -and $spTestName -match '^JalopStoredProcedureTest_[a-f0-9]{32}$') {
        & $sqlcmd -S $server -d master -E -l 10 -t 20 -b -Q "ALTER DATABASE [$spTestName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$spTestName];"
        if ($LASTEXITCODE -ne 0) { Write-Warning "Disposable test database cleanup failed: $spTestName" }
    }
    Write-Output "Test artifacts: $spTestRoot. Application database was not used."
}
