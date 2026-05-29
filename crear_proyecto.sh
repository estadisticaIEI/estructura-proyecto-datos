#!/usr/bin/env bash

# =============================
# DATA PROJECT CREATOR SCRIPT (BASH VERSION)
# =============================

set -e

# Function: check if the given path is a critical or prohibited folder
is_prohibited_path() {
    local path="${1%/}"
    local lower="$(echo "$path" | tr 'A-Z' 'a-z')"
    local bad_paths=(
        "/" "/bin" "/etc" "/usr" "/usr/local" "/var" "/lib" "/System" "/Volumes"
        "/c/windows" "/c/program files" "/c/program files (x86)" "/c/users/public" "/c/users/administrator"
    )
    for p in "${bad_paths[@]}"; do
        if [[ "$lower" == "$p"* ]]; then
            return 0
        fi
    done
    return 1
}

# Prompt for base path
read -rp "📁 Enter the full path where the new project should be created: " base_path
if [[ -z "$base_path" ]]; then
    echo "\n❌ Invalid empty path. Cancelling..." >&2
    exit 1
fi

if is_prohibited_path "$base_path"; then
    echo "\n❌ Prohibited or system-critical path. Cancelling..." >&2
    exit 1
fi

if [[ ! -d "$base_path" ]]; then
    echo "\n❌ Path does not exist. Cancelling..." >&2
    exit 1
fi

# Prompt for project name
read -rp "📌 Enter the name of your new data project (letters, numbers, '-', '_'): " project_name
if [[ -z "$project_name" ]]; then
    echo "\n❌ Invalid empty project name. Cancelling..." >&2
    exit 1
fi

if [[ ! $project_name =~ ^[A-Za-z0-9_-]+$ ]]; then
    echo "\n❌ Project name contains invalid characters. Cancelling..." >&2
    exit 1
fi

project_path="$base_path/$project_name"

# Create project folder structure
folders=(
    ".venv"
    "data/raw" "data/processed" "data/external"
    "docs" "notebooks" "src"
    "outputs/figures" "outputs/powerbi_dashboard"
)
for folder in "${folders[@]}"; do
    mkdir -p "$project_path/$folder"
done

# Create essential files
files=(
    "requirements_devs.txt"
    "requirements_final.txt"
    "README.md"
    "data_dictionary.md"
)
for file in "${files[@]}"; do
    touch "$project_path/$file"
done

cd "$project_path"

git init >/dev/null
cat > .gitignore <<'EOGIT'
# .gitignore
.venv/
__pycache__/
data/
outputs/powerbi_dashboard/
requirements_devs.txt
*.pbix
EOGIT

# Set up Python environment
python -m venv .venv
if [[ -f ".venv/Scripts/activate" ]]; then
    source ".venv/Scripts/activate"
else
    source ".venv/bin/activate"
fi

python -m pip install --upgrade pip
pip install ipykernel jupyterlab notebook
python -m ipykernel install --user --name=".venv" --display-name="Python (.venv)"

# Write and install dependencies
cat > requirements_devs.txt <<'EOREQ'
pandas>=2.2.3
numpy>=1.26.4
matplotlib>=3.8.3
jupyterlab>=4.1.6
notebook>=7.1.3
seaborn>=0.13.0
openpyxl>=3.1.2
xlrd>=2.0.1
xlsxwriter>=3.1.9
EOREQ

pip install -r requirements_devs.txt

echo -e "\n🎉 Project '$project_name' was successfully created at: $project_path"

