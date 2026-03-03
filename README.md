# Meal plan PDF generator

This project builds a meal plan PDF from a LaTeX source file.
It includes local build commands and a Docker-based build workflow.

## Project files

- `main.tex`: Main LaTeX document for the meal plan.
- `Makefile`: Build and utility commands for `make` users.
- `justfile`: Equivalent commands for `just` users.
- `Dockerfile`: Reproducible TeX Live build environment.

## Prerequisites

To build locally, install these tools:

- TeX Live with `latexmk` and XeLaTeX support.
- TeX Gyre fonts (for `TeX Gyre Pagella`).
- `make` or `just`.

## Build locally

Run one of the following commands:

```bash
make build
```

```bash
just build
```

The output PDF is written to `build/main.pdf`.

## Build with Docker

1. Build the Docker image.

```bash
make build-image
```

2. Build the PDF inside the container.

```bash
make build-in-docker
```

The generated `main.pdf` is copied to the project root directory.

## Clean build artifacts

Use either command:

```bash
make clean
```

```bash
just clean
```

This removes `build/`, backup files, and generated PDF files.

## Format TeX source

Install `tex-fmt`:

```bash
make install-tex-fmt
```

Format source files:

```bash
make format
```

## Troubleshooting

- If font errors appear, ensure TeX Gyre fonts are installed.
- If Docker builds fail during `tlmgr` updates, retry later or switch to a
  different CTAN mirror.
