# 🧪 Guía para la Creación de Proyectos de Ciencia de Datos en Windows 11

Este documento explica cómo crear automáticamente la estructura de un proyecto de ciencia de datos usando **PowerShell**, **Git** y **Python** en **Windows 11**.

Incluye un script (`crear_proyecto.ps1`) que puedes **descargar desde el repositorio** y ejecutar en tu máquina para generar toda la estructura del proyecto de forma automática.

---
## 🧰 Requisitos previos

Asegúrate de tener instalado:

- Python 3.11.9 (y agregado al `PATH`)
- Git para Windows
- PowerShell (incluido por defecto en Windows 11)
- Permisos para ejecutar scripts en PowerShell

---
## 🔽 Descargar el script desde GitHub

Descarga el archivo `crear_proyecto.ps1` desde el repositorio oficial:

🔗 [https://github.com/estadisticaIEI/estructura-proyecto-datos](https://github.com/estadisticaIEI/estructura-proyecto-datos)

Pasos:

1. Entra al enlace.
2. Haz clic sobre `crear_proyecto.ps1`.
3. Luego haz clic en **Raw**.
4. Clic derecho → **Guardar como...** y guárdalo en cualquier carpeta de tu equipo.

---

## 🛡️ Habilitar y desbloquear ejecución de scripts

### Paso 1: Permitir ejecución de scripts (solo una vez)

Abre PowerShell y ejecuta:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Paso 2: Desbloquear archivo descargado

Como el archivo fue descargado de internet, Windows podría bloquearlo. Ejecuta este comando **cambiando la ruta** por la del archivo en tu PC:

```powershell
Unblock-File -Path "C:\RUTA\A\TU\SCRIPT\crear_proyecto.ps1"
```
---

## ⚙️ ¿Qué hace el script?

El script `crear_proyecto.ps1` realiza las siguientes acciones:

1. Crea una carpeta con el nombre del proyecto dentro de la ruta base.
2. Genera una estructura estándar de carpetas para ciencia de datos.
3. Inicializa un repositorio Git.
4. Crea un archivo `.gitignore` con rutas típicas a excluir.
5. Crea un entorno virtual `.venv` con Python.
6. Activa el entorno virtual.
7. Actualiza `pip` a la versión más reciente.
8. Instala dependencias base como JupyterLab.
9. Registra el kernel `.venv` para Jupyter.
10. Crea un archivo `requirements_devs.txt` con las librerías necesarias.
11. Instala las dependencias.
12. Muestra la lista de paquetes instalados.

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
├── notebooks/
│   └── 01_data_cleaning.ipynb     # Ejemplo de notebook inicial
├── src/
│   ├── data_processing.py         # Script de limpieza y procesamiento
│   └── analysis.py                # Script de análisis y modelado
├── reports/
│   ├── figures/                   # Gráficos exportados (PNG, SVG)
│   └── powerbi_dashboard/
│       └── powerbi_dashboard.pbix # Tablero de Power BI
├── .gitignore                     # Rutas excluidas del control de versiones
├── requirements_devs.txt          # Librerías de desarrollo (versiones mínimas)
├── requirements_final.txt         # Librerías finales (versiones fijadas)
├── README.md                      # Este archivo
└── data_dictionary.md             # Diccionario de datos y variables
```

---

## ▶️ Cómo usar el script

1. Guarda el archivo `crear_proyecto.ps1` en una carpeta de tu elección.

2. **Edita el archivo** y reemplaza la línea de la ruta base con tu ruta personalizada. Por ejemplo:

```powershell
$basePath = "C:\Users\TuNombre\Documents\ProyectosCienciaDatos"
```

3. Abre PowerShell y ejecuta el script indicando el nombre del nuevo proyecto:

```powershell
& "C:\RUTA\A\TU\SCRIPT\crear_proyecto.ps1" -ProjectName "EjemploProyecto"
```

> ⚠️ El nuevo proyecto se creará en la ruta que configuraste en `$basePath`, no en la ubicación donde guardaste el script.

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

- Al finalizar tu proyecto, puedes guardar las versiones exactas de tus librerías:

```powershell
pip freeze > requirements_final.txt
```
---

## ✅ Resultado esperado

Un entorno de trabajo profesional para ciencia de datos, con entorno virtual, notebooks, estructura ordenada de carpetas y dependencias listas para usar.
