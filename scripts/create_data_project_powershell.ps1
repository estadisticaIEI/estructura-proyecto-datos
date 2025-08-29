# =========================
# DATA PROJECT CREATOR SCRIPT (minimal & robust)
# =========================

# --- Console encoding (avoid garbled chars) ---
try {
    chcp.com 65001 | Out-Null
}
catch {}
try {
    [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
    [Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
    $OutputEncoding = [System.Text.UTF8Encoding]::new()
}
catch {}

# --- Helpers ---
function Test-ProhibitedPath ($path) {
    $badRoots = @(
        "C:\Windows",
        "C:\Program Files",
        "C:\Program Files (x86)",
        "C:\Users\Public",
        "C:\Users\Administrator"
    )
    foreach ($root in $badRoots) {
        if ($path.ToLower().StartsWith($root.ToLower())) { return $true }
    }
    return $false
}

# --- Prompt: base path ---
$promptBasePath = @"
Enter the full path where the new project should be created
(e.g. C:\Users\You\Documents\DataProjects)
[Press Enter to cancel / type E to Exit]
"@
$basePath = Read-Host $promptBasePath

# Cancelación explícita o Enter vacío -> salir
if ($basePath -match '(?i)^(e|exit|cancel)$' -or $basePath -match '^\s*$') {
    Write-Host "`nScript cancelled by user." -ForegroundColor Red
    exit 1
}

# Validaciones de la ruta
if (Test-ProhibitedPath $basePath) {
    Write-Host "`nProhibited or system-critical path. Cancelling..." -ForegroundColor Red
    exit 1
}
if (-not (Test-Path -Path $basePath)) {
    Write-Host "`nPath does not exist. Cancelling..." -ForegroundColor Red
    exit 1
}

# --- Prompt: project name ---
$promptProject = @"
Enter the name of your new data project
(allowed: letters, numbers, '-' or '_')
[Press Enter to cancel / type E to Exit]
"@
$ProjectName = Read-Host $promptProject

# Cancelación explícita o Enter vacío -> salir
if ($ProjectName -match '(?i)^(e|exit|cancel)$' -or $ProjectName -match '^\s*$') {
    Write-Host "`nScript cancelled by user." -ForegroundColor Red
    exit 1
}

# Validaciones del nombre
if ($ProjectName -notmatch '^[A-Za-z0-9\-_]+$') {
    Write-Host "`nProject name contains invalid characters. Cancelling..." -ForegroundColor Red
    exit 1
}

# --- Paths & root folder ---
$projectPath = Join-Path $basePath $ProjectName
New-Item -Path $projectPath -ItemType Directory -Force | Out-Null

# --- Folders ---
$folders = @(
    ".venv",
    "data/raw", "data/processed", "data/external",
    "docs", "notebooks", "src",
    "outputs/figures", "outputs/powerbi_dashboard"
)
foreach ($folder in $folders) {
    New-Item -Path (Join-Path $projectPath $folder) -ItemType Directory -Force | Out-Null
}

# --- Files ---
$files = @("requirements_devs.txt", "requirements_final.txt", "README.md", "data_dictionary.md")
foreach ($file in $files) {
    $filePath = Join-Path $projectPath $file
    if (-not (Test-Path $filePath)) { New-Item -Path $filePath -ItemType File -Force | Out-Null }
}

# --- Git & .gitignore ---
Set-Location $projectPath
git init | Out-Null
@"
# .gitignore
.venv/
__pycache__/
data/
outputs/powerbi_dashboard/
requirements_devs.txt
*.pbix
"@ | Out-File -Encoding utf8 .gitignore

# --- Python env & Jupyter kernel ---
python -m venv .venv
& (Join-Path $projectPath ".venv\Scripts\Activate.ps1")

python -m pip install --upgrade pip
pip install ipykernel jupyterlab notebook
python -m ipykernel install --user --name=".venv" --display-name="Python (.venv)"

# --- Dependencies (dev) ---
@"
pandas>=2.2.3
numpy>=1.26.4
matplotlib>=3.8.3
jupyterlab>=4.1.6
notebook>=7.1.3
seaborn>=0.13.0
openpyxl>=3.1.2
xlrd>=2.0.1
xlsxwriter>=3.1.9
"@ | Out-File -Encoding utf8 (Join-Path $projectPath "requirements_devs.txt")
pip install -r (Join-Path $projectPath "requirements_devs.txt")

Write-Host "`nProject '$ProjectName' was successfully created at: $projectPath" -ForegroundColor Green
