# SIAP — Sistema Inteligente de Adaptación Pedagógica

Aplicación web desarrollada en **Django** que adapta automáticamente el nivel
de dificultad de las preguntas de práctica a cada estudiante de **1er ciclo
de secundaria (7mo y 8vo grado)**, según su desempeño en tiempo real.

---

## 📌 Descripción

En un aula de secundaria conviven estudiantes con niveles de dominio muy
distintos sobre un mismo tema. SIAP resuelve este problema ofreciendo a cada
estudiante un banco de preguntas que se ajusta dinámicamente: si responde
bien, el sistema le presenta preguntas más difíciles; si falla, reduce la
dificultad para reforzar el tema antes de avanzar. El docente, por su parte,
cuenta con un panel donde visualiza el dominio de cada estudiante por tema y
recibe alertas de quienes necesitan más apoyo.

## 🎯 Objetivo

Construir un sistema web que:

- Estime, para cada estudiante y cada tema, un **nivel de dominio (0-100)**.
- Seleccione automáticamente la siguiente pregunta según ese nivel (motor
  adaptativo).
- Permita al **docente** monitorear el progreso de todo el grupo sin
  depender de hojas de cálculo manuales.

## ⚙️ Funcionalidades

- **Registro e inicio de sesión** de estudiantes (7mo u 8vo grado).
- **Panel del estudiante**: progreso visual (barra de dominio) por tema y
  acceso directo a practicar.
- **Quiz adaptativo**: presenta una pregunta, recibe la respuesta, actualiza
  el dominio al instante y explica por qué la respuesta era correcta o no.
- **Motor adaptativo** (`pedagogia/motor_adaptativo.py`): lógica que decide
  cuánto sube o baja el dominio según aciertos/errores y rachas, y traduce
  ese dominio en una banda de dificultad (1 a 5).
- **Panel del docente**: tabla con todos los estudiantes, su dominio
  promedio, precisión y detalle por tema; alerta automática para quienes
  tienen dominio promedio bajo.
- **Panel de administración de Django** (`/admin/`) para que el docente
  cargue materias, temas y preguntas sin tocar código.
- **Banco de preguntas de ejemplo** ya cargado (Fracciones, Ecuaciones de
  primer grado, Ortografía) mediante un comando de gestión.

## 🛠️ Tecnologías

| Componente         | Tecnología                          |
|---------------------|--------------------------------------|
| Backend / Framework  | Python 3.12 + Django                 |
| Base de datos        | SQLite (desarrollo) — fácilmente migrable a PostgreSQL |
| Frontend             | HTML + Bootstrap 5 (CDN)             |
| Archivos estáticos   | WhiteNoise                           |
| Servidor de producción | Gunicorn                           |
| Análisis del algoritmo | Jupyter Notebook, pandas, matplotlib |
| Entorno de desarrollo | Google Antigravity                  |

## 📂 Estructura del proyecto

```
siap/
├── manage.py
├── requirements.txt
├── requirements-dev.txt
├── Procfile                     # despliegue (Render/Railway)
├── build.sh                     # script de build para despliegue
├── .env.example
├── siap_project/                # configuración del proyecto Django
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── pedagogia/                   # app principal
│   ├── models.py                # Materia, Tema, Pregunta, PerfilAdaptativo...
│   ├── motor_adaptativo.py      # lógica de adaptación (núcleo "inteligente")
│   ├── views.py
│   ├── urls.py
│   ├── admin.py
│   ├── tests.py                 # 8 pruebas unitarias
│   ├── templates/pedagogia/
│   └── management/commands/
│       └── poblar_datos.py      # carga materias/temas/preguntas de ejemplo
└── notebooks/
    └── analisis_motor_adaptativo.ipynb   # simulación y validación del algoritmo
```

## 🚀 Instrucciones de ejecución (local)

### 1. Clonar el repositorio e instalar dependencias

```bash
git clone <URL-DE-TU-REPOSITORIO>
cd siap
python -m venv venv
source venv/bin/activate        # En Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configurar variables de entorno (opcional en local)

```bash
cp .env.example .env
```

En desarrollo local, Django usa valores por defecto seguros si no defines
nada (`DEBUG=True`, `ALLOWED_HOSTS=localhost,127.0.0.1`).

### 3. Aplicar migraciones y cargar datos de ejemplo

```bash
python manage.py migrate
python manage.py poblar_datos
```

Esto crea:
- Usuario **docente**: `docente` / `docente123`
- Usuario **estudiante demo**: `estudiante_demo` / `demo1234`
- 2 materias, 3 temas y 16 preguntas de ejemplo.

### 4. Levantar el servidor

```bash
python manage.py runserver
```

Abre `http://127.0.0.1:8000/` en el navegador.

- **Estudiante**: inicia sesión con `estudiante_demo` / `demo1234`, o
  regístrate como uno nuevo.
- **Docente**: inicia sesión con `docente` / `docente123` y entra a
  `/docente/` o `/admin/` para gestionar preguntas.

### 5. Ejecutar las pruebas

```bash
python manage.py test pedagogia
```

### 6. Ejecutar el notebook de análisis (opcional)

```bash
pip install -r requirements-dev.txt
cd notebooks
jupyter notebook analisis_motor_adaptativo.ipynb
```

## ☁️ Despliegue

Instrucciones para desplegar en **Render** (gratuito) usando los archivos
`Procfile` y `build.sh` ya incluidos:

1. Sube el proyecto a GitHub.
2. En [render.com](https://render.com) crea un **Web Service** nuevo
   apuntando a tu repositorio.
3. Configura:
   - **Build command**: `./build.sh`
   - **Start command**: `gunicorn siap_project.wsgi`
4. Agrega las variables de entorno (según `.env.example`):
   - `SECRET_KEY` (genera una nueva, no uses la de ejemplo)
   - `DEBUG=False`
   - `ALLOWED_HOSTS=<tu-dominio>.onrender.com`
   - `CSRF_TRUSTED_ORIGINS=https://<tu-dominio>.onrender.com`
5. Despliega. El `build.sh` instala dependencias, corre migraciones y carga
   los datos de ejemplo automáticamente.

🔗 **Enlace al despliegue funcional:** _(agregar aquí una vez desplegado)_

## 🧠 Sobre el motor adaptativo

El algoritmo completo, su justificación y su validación mediante simulación
están documentados en `notebooks/analisis_motor_adaptativo.ipynb`. En
resumen: cada acierto o error mueve el nivel de dominio del estudiante
(escala 0-100) en una cantidad que crece con la racha de aciertos/errores
consecutivos, y ese dominio se traduce en una banda de dificultad (1 a 5)
que filtra el banco de preguntas disponible.

## 👨‍💻 Autoría y entorno de desarrollo

Proyecto desarrollado usando **Google Antigravity** como entorno de
desarrollo asistido por IA (ver evidencia en `/docs/evidencia-antigravity/`
del repositorio).

## 📹 Video de sustentación

🔗 _(agregar aquí el enlace al video una vez grabado)_
