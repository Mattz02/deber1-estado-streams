# deber1-estado-streams

Deber de manejo de estado y streams en Flutter.

Este repositorio contiene dos proyectos Flutter:

- `deber1/`: parte A, contador. Este es el nombre que se usó para la carpeta que la guía llama `parte_a_contador/`.
- `parte_b_conexion/`: parte B, comparación entre Future y Stream con Cubit.

Las variantes del contador están en las ramas `version/setstate`, `version/riverpod` y `version/bloc`. La parte B está en `main`.

## Ejecutar la parte B

Desde la raíz de una copia del repositorio, con los cambios locales guardados antes de cambiar de rama:

```bash
git switch main
cd parte_b_conexion
flutter pub get
flutter run
```

La app tiene dos pestañas: **Con Future** consulta al pulsar el botón; **Con Stream** escucha cambios automáticamente.

## Corrección de la guía: inicio de B y B.4 Cierre

La entrega pide un único repositorio, pero el bloque de preparación de B ejecuta `git init` dentro de `parte_b_conexion`. Eso crea otro repositorio independiente: no hereda el remoto `origin` ni la rama `main` del repositorio exterior, y puede iniciar en `master`. Por eso el `git push -u origin main` de B.4 falla dentro de ese repositorio.

Debe existir un solo `.git`, en la raíz de `deber1-estado-streams`. Las ramas pertenecen al repositorio completo, no a cada carpeta Flutter.

Para crear la parte B desde cero, se ejecutaría lo siguiente **desde la raíz del repositorio exterior**, con los cambios anteriores guardados. No repetir este bloque aquí: el proyecto ya existe.

```bash
git switch main
flutter create parte_b_conexion
cd parte_b_conexion
flutter pub add connectivity_plus flutter_bloc
cd ..
git add parte_b_conexion
git commit -m "chore: proyecto base de conexion"
```

No se ejecuta `git init` dentro de ninguna de las apps. El remoto del repositorio exterior ya está configurado como `origin`.

Para cerrar y publicar nuevos cambios de B, ejecutar **desde la raíz del repositorio exterior y en la rama `main`**:

```bash
git branch --show-current
git add parte_b_conexion README.md
git diff --cached --stat
git commit -m "feat: conexion con Future y con Stream + Cubit"
git push -u origin main
```

Si no hay cambios nuevos, no hace falta otro commit. `git add` prepara archivos y `git commit` los guarda localmente; solo `git push` los publica en GitHub.

## Comparar la arquitectura de la parte A

Desde la raíz, las rutas deben incluir `deber1/`. Usar solo `lib/domain` desde aquí compararía rutas inexistentes y podría dar un resultado vacío engañoso.

```bash
git diff version/setstate version/riverpod -- deber1/lib/domain deber1/lib/data
git diff version/setstate version/bloc -- deber1/lib/domain deber1/lib/data
git diff version/setstate version/bloc --stat -- deber1/lib/presentation
```
