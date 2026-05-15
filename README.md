# Teste Técnico — Engenharia de Dados

## Objetivo

Este projeto foi desenvolvido para o Clube do Valor como solução para o teste técnico de Engenharia de Dados utilizando dbt.

O objetivo principal é construir um pipeline analítico para processamento de transações financeiras, aplicando boas práticas de modelagem, qualidade de dados, documentação e organização em camadas.

---

# Arquitetura do Projeto

O projeto foi estruturado seguindo a arquitetura recomendada para projetos dbt:

```text
models/
│
├── staging/
│   ├── stg_clients.sql
│   ├── stg_transactions.sql
│   └── schema.yml
│
├── intermediate/
│   ├── int_transactions.sql
│   └── schema.yml
│
└── marts/
    ├── dim_clients.sql
    ├── fact_transactions.sql
    ├── mart_client_portfolio.sql
    └── schema.yml
```

---

# Tecnologias Utilizadas

- dbt
- PostgreSQL
- Python 3.11

---

# Camadas do Projeto

## Staging

A camada de staging é responsável por:

- padronização de colunas em snake_case;
- tipagem dos dados;
- limpeza inicial;
- deduplicação dos clientes;
- aplicação de validações básicas.

### Modelos

#### stg_transactions

Modelo responsável pela padronização das transações financeiras.

#### stg_clients

Modelo responsável pela padronização e deduplicação dos dados cadastrais dos clientes.

Foi aplicada deduplicação simples por `client_id` para evitar inconsistências nos joins analíticos.

---

## Intermediate

A camada intermediate concentra regras de negócio e cálculos derivados.

### int_transactions

Modelo responsável por:

- join entre clientes e transações;
- cálculo de métricas financeiras;
- ajuste de sinais financeiros para operações BUY e SELL.

Foram criadas as seguintes métricas:

- `gross_amount`
- `signed_quantity`
- `signed_amount`

---

## Marts

Camada analítica final utilizada para consumo.

### fact_transactions

Tabela fato contendo granularidade de uma linha por transação financeira.

O modelo foi implementado utilizando materialização incremental.

### mart_client_portfolio

Modelo analítico responsável por calcular:

- posição líquida por cliente e ativo;
- quantidade líquida;
- valor financeiro líquido.

A lógica considera:

```text
BUY = positivo
SELL = negativo
```

### dim_clients

Dimensão analítica contendo informações cadastrais dos clientes enriquecidas com o valor total consolidado do portfólio financeiro.

---

# Macro Reutilizável

Foi criada a macro `signed_value` para evitar repetição da lógica de sinalização das operações financeiras.

A macro ajusta dinamicamente os valores conforme o tipo da operação:

- BUY → positivo
- SELL → negativo

A macro é utilizada nos cálculos de:

- `signed_quantity`
- `signed_amount`

---

# Testes Implementados

## Generic Tests

Foram implementados testes genéricos utilizando `schema.yml`:

- `not_null`
- `unique`
- `accepted_values`

---

## Singular Test

Foi implementado o teste singular:

```text
assert_no_negative_position.sql
```

O teste identifica clientes com posição líquida negativa no portfólio consolidado.

O teste foi configurado com:

```text
severity = warn
```

permitindo que o problema seja monitorado sem interromper a execução do pipeline.

---

# Incremental Model

O modelo `fact_transactions` foi implementado utilizando materialização incremental.

A estratégia incremental utiliza:

- `transaction_date` como chave de controle para processamento incremental;
- `transaction_id` como `unique_key` para garantir unicidade das transações.

Dessa forma, apenas novos registros são processados a cada execução incremental do modelo.

---

# Documentação

Todos os modelos, colunas e macros foram documentados utilizando:

- `schema.yml`
- `dbt docs`

Para geração da documentação:

```bash
dbt docs generate
```

Para visualizar no navegador:

```bash
dbt docs serve
```

---

# Como Executar o Projeto

Executar os comandos abaixo na raiz do projeto.

---

# Pré-requisitos

Antes de executar o projeto, é necessário possuir instalado:

- Python 3.11+
- Git
- PostgreSQL 14+

---

# Instalações

## 1. Instalar Python

Realizar download do Python 3.11:

https://www.python.org/downloads/

Durante a instalação, marcar a opção:

```text
Add Python to PATH
```

---

## 2. Instalar PostgreSQL

Realizar instalação do PostgreSQL:

https://www.postgresql.org/download/

Durante a instalação, utilizar preferencialmente:

| Configuração | Valor |
|---|---|
| Host | localhost |
| Porta | 5432 |
| Usuário | postgres |

---

# Configuração do Ambiente

## 3. Clonar o repositório

Repositório:

https://github.com/Lzoppas/teste-tecnico-dbt

Clonar projeto:

```bash
git clone https://github.com/Lzoppas/teste-tecnico-dbt.git
cd teste-tecnico-dbt
```
---

## 4. Criar e ativar ambiente virtual

### Windows

Criar ambiente virtual:

```bash
python -m venv venv
```

Ativar ambiente virtual:

```powershell
venv\Scripts\activate
```

---

## 5. Instalar dependências

Instalar o adapter do dbt para PostgreSQL:

```bash
pip install dbt-postgres
```

Validar instalação:

```bash
dbt --version
```

---

## 6. Criar database do projeto

Executar o comando abaixo no terminal para acessar o PostgreSQL:

```bash
psql -U postgres
```

Após conectar no SQL Shell (`psql`), executar:

```sql
CREATE DATABASE teste_cdv;
```

Para sair do SQL Shell:

```sql
\q
```

---


---

## 7. Configurar o dbt profile

Criar manualmente a pasta:

```text
C:\Users\<usuario>\.dbt
```

Dentro da pasta `.dbt`, criar o arquivo:

```text
profiles.yml
```

Adicionar o seguinte conteúdo:

```yaml
teste_cdv:
  target: dev

  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      pass: SUA_SENHA
      port: 5432
      dbname: teste_cdv
      schema: public
      threads: 4
```

Substituir:

```yaml
SUA_SENHA
```

pela senha definida na instalação do PostgreSQL.

---

# Execução do Projeto

## 8. Validar conexão do dbt

Executar:

```bash
dbt debug
```

Resultado esperado:

```text
All checks passed!
```

---

## 9. Executar seeds

```bash
dbt seed
```

---

## 10. Executar modelos

```bash
dbt run
```

---

## 11. Executar testes

```bash
dbt test
```

---

## 12. Executar pipeline completo

```bash
dbt build
```

---

## 13. Gerar documentação

Gerar documentação:

```bash
dbt docs generate
```

Visualizar documentação no navegador:

```bash
dbt docs serve
```

---

# Problemas Comuns

## PowerShell bloqueando scripts

Executar:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Erro: profile not found

Verificar se o arquivo:

```text
C:\Users\<usuario>\.dbt\profiles.yml
```

foi criado corretamente.

---

## Erro de autenticação PostgreSQL

Validar:

- usuário;
- senha;
- porta;
- serviço do PostgreSQL ativo.

---