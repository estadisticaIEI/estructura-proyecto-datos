# 🧪 Guía para la Creación de Proyectos de Ciencia de Datos en Windows 11

Este documento explica cómo crear automáticamente la estructura de un proyecto de ciencia de datos usando **PowerShell**, **Git** y **Python** en **Windows 11**.

El script (crear_proyecto.ps1) puede ejecutarse directamente desde internet sin necesidad de descarga manual.

---
## 🧰 Requisitos previos

Asegúrate de tener instalado en tu equipo:

- Python 3.11.9 (y agregado al `PATH`)
- Git para Windows
- PowerShell (incluido por defecto en Windows 11)
- Permisos para ejecutar scripts en PowerShell

---
## 🛡️ Habilitar ejecución de scripts
Si es la primera vez que ejecutas scripts descargados de internet, abre PowerShell como administrador y ejecuta:

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Esto habilitará la ejecución de scripts solo en la sesión actual (recomendado).

---

## 🚀 Ejecución rápida desde internet
Puedes crear tu proyecto ejecutando este único comando en PowerShell:

```
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/estadisticaIEI/estructura-proyecto-datos/main/crear_proyecto.ps1')
```

Esto descargará y ejecutará el script directamente en memoria.

## 🖥️ Versión para Bash
Si trabajas en Linux, macOS o usas WSL en Windows, puedes ejecutar el script `crear_proyecto.sh`:

```bash
bash <(curl -s https://raw.githubusercontent.com/estadisticaIEI/estructura-proyecto-datos/main/crear_proyecto.sh)
```


---

## ▶️ Uso del script
El script te pedirá dos datos de forma interactiva:

1️⃣ Ruta base donde crear el proyecto (por ejemplo:
`C:\Users\TuNombre\Documents\ProyectosCienciaDatos`)

2️⃣ Nombre del proyecto (por ejemplo: `AnalisisVentas2024`)

Ejemplo de ejecución:

```
📁 Enter the full path where the new project should be created (e.g. C:\Users\You\Documents\DataProjects)
> C:\Users\TuNombre\Documents\ProyectosCienciaDatos

📌 Enter the name of your new data project (letters, numbers, '-', '_')
> MiPrimerProyecto
```

Cuando finalice, verás un mensaje indicando la ruta completa del proyecto creado.

---

## ⚙️ ¿Qué hace el script?

El script `crear_proyecto.ps1` realiza las siguientes acciones:

✅ Creación de la estructura estándar de carpetas  
✅ Inicialización de un repositorio Git  
✅ Creación de un archivo .gitignore  
✅ Configuración de un entorno virtual Python (.venv)  
✅ Instalación de dependencias básicas para ciencia de datos  
✅ Registro del kernel en JupyterLab

---

## 📝 Estructura generada del proyecto

```
NombreDelProyecto/
│
├── .venv/                         # Entorno virtual Python
├── data/
│   ├── raw/                       # Datos originales
│   ├── processed/                 # Datos limpios
│   └── external/                  # Datos externos (APIs, GIS, etc.)
├── docs/                          # Documentación, informes, papers
├── notebooks/                     # Jupyter Notebooks
├── src/                           # Scripts de procesamiento y análisis
├── outputs/
│   ├── figures/                   # Gráficos exportados (PNG, SVG)
│   └── powerbi_dashboard/         # Tableros de Power BI
├── .gitignore                     # Exclusiones de Git
├── requirements_devs.txt          # Librerías mínimas para desarrollo
├── requirements_final.txt         # Librerías finales (versiones fijadas)
├── README.md                      # Este archivo
└── data_dictionary.md             # Diccionario de datos y variables
```

---
## 📦 Librerías preinstaladas (`requirements_devs.txt`)

El script instala las siguientes dependencias mínimas:

```text
pandas>=2.2.3
numpy>=1.26.4
matplotlib>=3.8.3
jupyterlab>=4.1.6
notebook>=7.1.3
seaborn>=0.13.0
openpyxl>=3.1.2
xlrd>=2.0.1
xlsxwriter>=3.1.9
```

> Estas versiones son sugeridas y pueden adaptarse según el proyecto. Se instalan desde el archivo `requirements_devs.txt`.

---

## 🧠 Consejos finales

🔹 Si deseas capturar las versiones exactas de tus dependencias antes de entregar el proyecto, ejecuta:

```
pip freeze > requirements_final.txt
```

🔹 Lo anterior garantiza replicabilidad del proyecto para otras personas que puedan estar interesadas en el mismo.

🔹 Puedes reutilizar este script cuantas veces quieras para crear nuevos proyectos en diferentes carpetas.

---

## ✅ Resultado esperado

Un entorno de trabajo profesional para ciencia de datos, con entorno virtual, notebooks, estructura ordenada de carpetas y dependencias listas para usar.
