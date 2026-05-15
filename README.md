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
- Visual Studio Code

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

## 1. Criar e ativar ambiente virtual

```bash
python -m venv venv
venv\Scripts\activate
```

---

## 2. Instalar dependências

```bash
pip install dbt-postgres
```

---

## 3. Executar seeds

```bash
dbt seed
```

---

## 4. Executar modelos

```bash
dbt run
```

---

## 5. Executar testes

```bash
dbt test
```

---

## 6. Executar pipeline completo

```bash
dbt build
```
