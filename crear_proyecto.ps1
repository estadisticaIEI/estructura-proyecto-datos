param(
    [string]$ProjectName
)

# ================================================
# CONFIGURA AQUÍ LA RUTA BASE DE TUS PROYECTOS
# Reemplaza esta línea con la carpeta donde quieras guardar tus proyectos
# Ejemplo: "C:\Users\TuNombre\Documents\ProyectosCienciaDatos"
# ================================================
$basePath = "C:\RUTA\A\TU\CARPETA\DE\PROYECTOS"

# Ruta completa del nuevo proyecto
$projectPath = Join-Path $basePath $ProjectName

# 1. Crear carpetas necesarias
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

# 2. Crear archivos vacíos clave
$files = @(
    "requirements_devs.txt",
    "requirements_final.txt",
    "README.md",
    "data_dictionary.md"
)

foreach ($file in $files) {
    New-Item -Path "$projectPath\$file" -ItemType File -Force | Out-Null
}

# 3. Inicializar repositorio Git y crear .gitignore
Set-Location $projectPath
git init | Out-Null

@"
# .gitignore
.venv/
__pycache__/
data/
*.pbix
"@ | Out-File -Encoding utf8 .gitignore

# 4. Crear entorno virtual
python -m venv .venv

# 5. Activar entorno virtual (solo en esta terminal)
& "$projectPath\.venv\Scripts\Activate.ps1"

# 6. Actualizar pip
python -m pip install --upgrade pip

# 7. Instalar dependencias base
pip install ipykernel jupyterlab notebook

# 8. Registrar el kernel con nombre personalizado
python -m ipykernel install --user --name=".venv" --display-name="Python (.venv)"

# 9. Crear archivo requirements_devs.txt e instalar dependencias
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

# 10. Verificar instalación
pip list

Write-Host "`n✅ Proyecto '$ProjectName' creado y configurado correctamente." -ForegroundColor Green
