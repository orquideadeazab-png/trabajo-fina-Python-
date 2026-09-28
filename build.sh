#!/usr/bin/env bash
# Script de build para Render (o similar). Dar permisos con: chmod +x build.sh
set -o errexit

pip install -r requirements.txt

python manage.py collectstatic --noinput
python manage.py migrate
python manage.py poblar_datos
