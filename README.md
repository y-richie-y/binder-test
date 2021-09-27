# Lambeq

## About

Lambeq is a toolkit for quantum natural language processing (QNLP).

This project is in early development, so there is no guarantee of
stability.

## Getting started

### Prerequisites

- Git
- Python 3.7+

### Installation

1. Download this repository:
   ```bash
   git clone https://github.com/CQCL/lambeq
   ```

2. Enter the repository:
   ```bash
   cd lambeq
   ```

#### Automatic Installation

The repository contains a script `install.sh` which, given a directory
name, creates a Python virtual environment and installs Lambeq.

To install Lambeq using this script, run:
```bash
bash install.sh <installation-directory>
```

#### Manual Installation

3. Make sure `pip` is up-to-date:

   ```bash
   pip install --upgrade pip wheel
   ```

4. Lambeq has the dependency `depccg` which requires the following
   packages to be installed *before* installing `depccg`:
   ```bash
   pip install cython numpy
   ```
   Further information can be found on the
   [depccg homepage](//github.com/masashi-y/depccg).

5. Install Lambeq from the local repository using pip:
   ```bash
   pip install --use-feature=in-tree-build .
   ```

   To include all optional dependencies, run:
   ```bash
   pip install --use-feature=in-tree-build .[all]
   ```

6. If using a pretrained depccg parser,
[download a pretrained model](//github.com/masashi-y/depccg#using-a-pretrained-english-parser):
   ```bash
   depccg_en download
   ```

## Usage

The [docs/examples](https://github.com/CQCL-DEV/lambeq-beta/blob/main/examples/ccg2discocat.ipynb)
directory contains notebooks demonstrating
usage of the various tools in Lambeq.

Example - parsing a sentence into a diagram (see
[docs/examples/ccg2discocat.ipynb](https://github.com/CQCL/lambeq-beta/blob/main/docs/examples/ccg2discocat.ipynb)):

```python
from lambeq.ccg2discocat import DepCCGParser

depccg_parser = DepCCGParser()
diagram = depccg_parser.sentence2diagram('This is a test sentence')
diagram.draw()
```

Note: all pre-trained depccg models apart from the basic one are broken,
and depccg has not yet been updated to fix this. Therefore, it is
recommended to just use the basic parser, as shown here.

## Testing

Run all tests with the command:

```bash
pytest
```

Note: if you have installed in a virtual environment, remember to install
pytest in the virtual environment using pip.

## Building Documentation

Build the documentation by running the commands:
```bash
cd docs
make clean
make html
```
the docs will be under `docs/_build`.

To rebuild the rst files themselves, run:

```bash
sphinx-apidoc --force -o docs lambeq
```

