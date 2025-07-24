# =========================
# DATA PROJECT CREATOR SCRIPT (UPDATED WITH NEW CHANGES)
# =========================

# Function: check if the given path is a critical or prohibited Windows folder
function Is-ProhibitedPath ($path) {
    $badRoots = @(
        "C:\\Windows",
        "C:\\Program Files",
        "C:\\Program Files (x86)",
        "C:\\Users\\Public",
        "C:\\Users\\Administrator"
    )
    foreach ($root in $badRoots) {
        if ($path.ToLower().StartsWith($root.ToLower())) {
            return $true
        }
    }
    return $false
}

#region Prompt for base path
do {
    $basePath = Read-Host "📁 Enter the full path where the new project should be created (e.g. C:\\Users\\You\\Documents\\DataProjects)"
    if ($basePath -match '^(exit|cancel)$') {
        Write-Host "`n❌ Script cancelled by user." -ForegroundColor Red
        exit
    }
} while (-not $basePath)

if ($basePath -match '^\s*$') {
    Write-Host "`n❌ Invalid empty path. Cancelling..." -ForegroundColor Red
    exit
}

if (Is-ProhibitedPath $basePath) {
    Write-Host "`n❌ Prohibited or system-critical path. Cancelling..." -ForegroundColor Red
    exit
}

if (-not (Test-Path -Path $basePath)) {
    Write-Host "`n❌ Path does not exist. Cancelling..." -ForegroundColor Red
    exit
}
#endregion

#region Prompt for project name
do {
    $ProjectName = Read-Host "📌 Enter the name of your new data project (letters, numbers, '-', '_')"
    if ($ProjectName -match '^(exit|cancel)$') {
        Write-Host "`n❌ Script cancelled by user." -ForegroundColor Red
        exit
    }
} while (-not $ProjectName)

if ($ProjectName -match '^\s*$') {
    Write-Host "`n❌ Invalid empty project name. Cancelling..." -ForegroundColor Red
    exit
}
if ($ProjectName -notmatch '^[A-Za-z0-9\-_]+$') {
    Write-Host "`n❌ Project name contains invalid characters. Cancelling..." -ForegroundColor Red
    exit
}
#endregion

# Combine base path and project name
$projectPath = Join-Path $basePath $ProjectName

#region Create project folder structure
$folders = @(
    ".venv",
    "data\\raw", "data\\processed", "data\\external",
    "docs", "notebooks", "src",
    "outputs\\figures", "outputs\\powerbi_dashboard"
)

foreach ($folder in $folders) {
    New-Item -Path "$projectPath\\$folder" -ItemType Directory -Force | Out-Null
}
#endregion

#region Create essential files
$files = @(
    "requirements_devs.txt",
    "requirements_final.txt",
    "README.md",
    "data_dictionary.md"
)

foreach ($file in $files) {
    New-Item -Path "$projectPath\\$file" -ItemType File -Force | Out-Null
}
#endregion

#region Initialize Git and create .gitignore
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
#endregion

#region Set up Python environment
python -m venv .venv
& ".venv\\Scripts\\Activate.ps1"

python -m pip install --upgrade pip
pip install ipykernel jupyterlab notebook

python -m ipykernel install --user --name=".venv" --display-name="Python (.venv)"
#endregion

#region Write and install dependencies
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
"@ | Out-File -Encoding utf8 "$projectPath\\requirements_devs.txt"

pip install -r "$projectPath\\requirements_devs.txt"
#endregion

Write-Host "`n🎉 Project '$ProjectName' was successfully created at: $projectPath" -ForegroundColor Green
