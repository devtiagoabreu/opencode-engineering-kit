---
name: python-testing
description: Guia completo de testes em Python com pytest
category: testing
version: 1.0.0
author: OpenCode Community
tags: [python, testing, pytest, unit-tests]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Python 3.7+ instalado
  - pytest instalado
provides:
  - Configuração de testes
  - Exemplos de testes
  - Melhores práticas
---

# Python Testing

## Visão Geral

Esta skill fornece guia completo para escrever testes em Python usando pytest,
incluindo testes unitários, de integração e mocks.

## Pré-requisitos

- Python 3.7 ou superior
- pytest instalado (`pip install pytest`)
- pytest-cov para cobertura (`pip install pytest-cov`)

## Instruções de Uso

### 1. Configuração

```bash
# Instalar dependências
pip install pytest pytest-cov

# Criar pytest.ini
cat > pytest.ini << 'EOF'
[pytest]
testpaths = tests
python_files = test_*.py
python_functions = test_*
addopts = -v --tb=short
EOF
```

### 2. Estrutura de Testes

```
meu_projeto/
├── src/
│   └── meu_modulo.py
├── tests/
│   ├── __init__.py
│   ├── test_meu_modulo.py
│   └── conftest.py
└── pytest.ini
```

### 3. Testes Unitários

```python
# tests/test_meu_modulo.py
import pytest
from src.meu_modulo import somar, subtrair

class TestSomar:
    def test_somar_positivos(self):
        assert somar(2, 3) == 5
    
    def test_somar_negativos(self):
        assert somar(-1, -1) == -2
    
    def test_somar_zero(self):
        assert somar(0, 5) == 5

class TestSubtrair:
    def test_subtrair_basico(self):
        assert subtrair(5, 3) == 2
    
    def test_subtrair_resultado_negativo(self):
        assert subtrair(3, 5) == -2
```

### 4. Testes com Fixtures

```python
# tests/conftest.py
import pytest

@pytest.fixture
def dados_validos():
    return {
        "nome": "João",
        "email": "joao@email.com",
        "idade": 30
    }

@pytest.fixture
def cliente_mock(mocker):
    return mocker.patch('src.cliente.Cliente')
```

### 5. Testes com Parametrize

```python
@pytest.mark.parametrize("a, b, esperado", [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
    (10, -5, 5),
])
def test_somar_parametrizado(a, b, esperado):
    assert somar(a, b) == esperado
```

### 6. Testes de Exceção

```python
def test_dividir_por_zero():
    with pytest.raises(ZeroDivisionError):
        dividir(10, 0)
```

### 7. Mocking

```python
from unittest.mock import Mock, patch

def test_chamar_api():
    with patch('src.api.requests.get') as mock_get:
        mock_get.return_value.json.return_value = {"status": "ok"}
        resultado = chamar_api()
        assert resultado["status"] == "ok"
        mock_get.assert_called_once()
```

## Exemplos

### Exemplo 1: Teste de Classe

```python
# src/calculadora.py
class Calculadora:
    def __init__(self):
        self.historico = []
    
    def somar(self, a, b):
        resultado = a + b
        self.historico.append(f"{a} + {b} = {resultado}")
        return resultado
    
    def obter_historico(self):
        return self.historico.copy()

# tests/test_calculadora.py
import pytest
from src.calculadora import Calculadora

@pytest.fixture
def calc():
    return Calculadora()

def test_somar(calc):
    assert calc.somar(2, 3) == 5

def test_historico(calc):
    calc.somar(1, 2)
    calc.somar(3, 4)
    assert len(calc.obter_historico()) == 2
```

### Exemplo 2: Teste de Integração

```python
# tests/test_integracao.py
import pytest
from src.banco import Database

@pytest.fixture
def db():
    database = Database(":memory:")
    yield database
    database.close()

def test_criar_tabela(db):
    db.criar_tabela("usuarios")
    assert "usuarios" in db.listar_tabelas()

def test_inserir_usuario(db):
    db.criar_tabela("usuarios")
    db.inserir("usuarios", {"nome": "João"})
    usuarios = db.selecionar("usuarios")
    assert len(usuarios) == 1
```

## Comandos Úteis

```bash
# Executar todos os testes
pytest

# Executar com verbose
pytest -v

# Executar com cobertura
pytest --cov=src

# Executar teste específico
pytest tests/test_meu_modulo.py

# Executar teste específico
pytest tests/test_meu_modulo.py::TestSomar::test_somar_positivos

# Executar testes que correspondem a padrão
pytest -k "somar"
```

## Referências

- [pytest Documentation](https://docs.pytest.org/)
- [Python Testing with pytest](https://www.amazon.com/Python-Testing-pytest-Brian-Okken/dp/1680502409)
- [Real Python - Testing](https://realpython.com/testing-in-python/)

## Notas

- Escreva testes antes do código (TDD)
- Mantenha testes independentes
- Use nomes descritivos para testes
- Teste edge cases e exceções
- Use fixtures para setup compartilhado
- Mantenha testes rápidos
