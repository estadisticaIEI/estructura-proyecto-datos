# ========================
# DATA PROJECT CREATOR SCRIPT (INTERACTIVE)
# ========================

# Ask user for the base path
$basePath = Read-Host "📁 Enter the full path where the new project should be created (e.g. C:\Users\Andre\Documents\DataProjects)"
if ($basePath -match '^(exit|cancel)$') {
    Write-Host "`n❌ Script cancelled by user." -ForegroundColor Red
    exit
}

# Ask user for the project name
$ProjectName = Read-Host "📌 Enter the name of your new data project"
if ($ProjectName -match '^(exit|cancel)$') {
    Write-Host "`n❌ Script cancelled by user." -ForegroundColor Red
    exit
}

# Combine into full project path
$projectPath = Join-Path $basePath $ProjectName

# Create folder structure
$folders = @(
    ".venv",
    "data\raw",
    "data\processed",
    "data\external",
    "docs",
    "notebooks",
    "src",
    "reports\figures",
    "reports\powerbi_dashboard"
)

foreach ($folder in $folders) {
    New-Item -Path "$projectPath\$folder" -ItemType Directory -Force | Out-Null
}

# Create empty files
$files = @(
    "requirements_devs.txt",
    "requirements_final.txt",
    "README.md",
    "data_dictionary.md"
)

foreach ($file in $files) {
    New-Item -Path "$projectPath\$file" -ItemType File -Force | Out-Null
}

# Initialize Git and create .gitignore
Set-Location $projectPath
git init | Out-Null

@"
# .gitignore
.venv/
__pycache__/
data/
*.pbix
"@ | Out-File -Encoding utf8 .gitignore

# Create and activate virtual environment
python -m venv .venv
& "$projectPath\.venv\Scripts\Activate.ps1"

# Upgrade pip and install core packages
python -m pip install --upgrade pip
pip install ipykernel jupyterlab notebook

# Register Jupyter kernel
python -m ipykernel install --user --name=".venv" --display-name="Python (.venv)"

# Write and install dependencies
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
"@ | Out-File -Encoding utf8 "$projectPath\requirements_devs.txt"

pip install -r "$projectPath\requirements_devs.txt"

# Final message
Write-Host "`n🎉 Project '$ProjectName' was successfully created at: $projectPath" -ForegroundColor Green
