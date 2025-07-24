# 🧪 Guía para la Creación de Proyectos de Ciencia de Datos

Este repositorio contiene dos scripts para generar automáticamente la estructura de un proyecto de ciencia de datos:

1. **PowerShell (Windows nativo)**: `scripts/crear_proyecto.ps1`
2. **Bash (WSL/Linux/macOS)**: `scripts/create_data_project_bash.sh`

Ambos crean:
- Estructura estándar de carpetas (`data/raw`, `notebooks`, `src`, etc.)
- Repositorio Git con `.gitignore`
- Entorno virtual Python (.venv)
- Archivos de dependencias (`requirements_devs.txt` y `requirements_final.txt`)
- Registro de kernel en Jupyter

---
## 🧰 Requisitos previos

- **Windows**: PowerShell con permisos para ejecutar scripts.
- **WSL/Linux/macOS**: Bash, `python3.11` con módulo `venv` (`sudo apt install python3.11-venv` en Ubuntu).
- **Git** en cualquier plataforma.
- **Python 3.11.9** (o posterior en la rama 3.11), disponible como `python3.11` o `py -3.11`.

---
## 🚀 Ejecución rápida

### PowerShell (Windows nativo)
Ejecuta sin clonar:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
iex (New-Object Net.WebClient).DownloadString(
  'https://raw.githubusercontent.com/estadisticaIEI/estructura-proyecto-datos/main/scripts/create_data_project_powershell.ps1'
)
```

### Bash (WSL/Linux/macOS)
Sin clonar (desde WSL o Linux/macOS):
```bash
bash <(curl -fsSL \
  https://raw.githubusercontent.com/estadisticaIEI/estructura-proyecto-datos/main/scripts/create_data_project_bash.sh
)
```

Durante la ejecución, se te pedirá:
1. Ruta base donde crear el proyecto (p. ej. `C:\Users\TuUsuario\Documents\DataProjects` o `/home/usuario/proyectos`).
2. Nombre del proyecto (solo letras, números, guiones o guiones bajos).
3. Para Bash: si deseas instalar dependencias (`y/N`).

---
## ⚙️ Uso del script

- **PowerShell**: interactivo, crea `.venv\Scripts\activate`, instala deps y registra kernel.
- **Bash**: detecta WSL vs Linux/macOS; crea `.venv/bin/activate` o `.venv/Scripts/activate`; instala ipykernel; registra kernel.

Al finalizar verás:
```
🎉 Proyecto 'MiProyecto' creado en: /ruta/Completa/MiProyecto
   • Activa el entorno:
     - Windows:    .\.venv\Scripts\activate
     - Linux/MacOS:  source .venv/bin/activate
   • Para notebooks: elige el kernel.
```

---
## 📝 Estructura generada

```
MiProyecto/
│
├── .venv/                        # Entorno virtual Python
├── data/
│   ├── raw/
│   ├── processed/
│   └── external/
├── docs/
├── notebooks/
├── src/
├── outputs/
│   ├── figures/
│   └── powerbi_dashboard/
├── .gitignore
├── requirements_devs.txt
├── requirements_final.txt
├── README.md
└── data_dictionary.md
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
---

## 🧠 Consejos finales

🔹 Si deseas capturar las versiones exactas de tus dependencias antes de entregar el proyecto, ejecuta:

```
pip freeze > requirements_final.txt
```
---
## ✅ Resultado esperado

Un proyecto listo para trabajar en ciencia de datos, con entorno virtual, estructura ordenada y dependencias mínimas instaladas.
