# Sales Importer

Aplicação Rails que recebe arquivos TAB-separated, normaliza os dados de vendas em PostgreSQL e exibe o total bruto importado.

## Requisitos

- Ruby 4.0.6
- PostgreSQL
- Bundler

## Configuração

```bash
bundle install
cp .env.example .env
```

Edite o `.env` com suas credenciais do PostgreSQL. Depois execute:

```bash
rails db:prepare
rails server
```

Acesse `http://localhost:3000` e envie um arquivo `.tab` ou `.tsv`. Há um exemplo em `inputs_example/example_input.tab`.

## Formato

O arquivo deve ter cabeçalho e estas colunas, nesta ordem:

```text
purchaser name, item description, item price, purchase count, merchant address, merchant name
```

Os dados são normalizados em compradores, comerciantes, itens e compras. O total bruto é `item price × purchase count`.

## Testes

```bash
rails test
```
