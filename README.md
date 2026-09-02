# Sales Importer

[![CI](https://github.com/DaviDantass/ikli-challenge/actions/workflows/ci.yml/badge.svg)](https://github.com/DaviDantass/ikli-challenge/actions/workflows/ci.yml)

Aplicação Rails para importar vendas de arquivos TAB-separated, normalizar os dados em PostgreSQL e apresentar o total bruto da importação.

## Tecnologias

- Ruby 4.0.6 e Rails 8.1
- PostgreSQL
- BCrypt para armazenamento seguro de senhas
- Minitest
- RuboCop, Brakeman e Bundler Audit

## Executando no Linux ou macOS

Pré-requisitos: Ruby, Bundler e PostgreSQL em execução.

```bash
git clone https://github.com/DaviDantass/ikli-challenge.git
cd ikli-challenge
bundle install
cp .env.example .env
```

Edite o `.env` caso suas credenciais do PostgreSQL sejam diferentes. Em seguida:

```bash
rails db:prepare
rails server
```

Acesse [http://localhost:3000](http://localhost:3000), crie uma conta e faça login. O arquivo `inputs_example/example_input.tab` pode ser usado para testar o upload.

> `rails db:prepare` cria o banco e executa as migrations. Se necessário, execute separadamente `rails db:create` e `rails db:migrate`.

## Variáveis de ambiente

| Variável | Descrição | Exemplo |
| --- | --- | --- |
| `DB_HOST` | Host do PostgreSQL | `localhost` |
| `DB_PORT` | Porta do PostgreSQL | `5432` |
| `DB_USERNAME` | Usuário | `postgres` |
| `DB_PASSWORD` | Senha | `postgres` |
| `DB_NAME` | Banco de desenvolvimento | `ikli_challenge` |

O arquivo `.env` não é versionado. Use `.env.example` como modelo.

## Formato aceito

O arquivo deve ser UTF-8, usar tabulações como separador e conter o cabeçalho abaixo, nesta ordem:

```text
purchaser name	item description	item price	purchase count	merchant address	merchant name
```

Exemplo:

```text
João Silva	R$10 off R$20 of food	10.0	2	987 Fake St	Bob's Pizza
Amy Pond	R$30 of awesome for R$10	10.0	5	456 Unreal Rd	Tom's Awesome Shop
```

O total bruto é calculado para cada upload:

```text
item price × purchase count
```

## Arquitetura

O domínio é normalizado em quatro entidades:

```text
Purchaser 1 ── N Purchase N ── 1 Item N ── 1 Merchant
```

- `SalesFileValidator`: valida estrutura e conteúdo antes de qualquer escrita.
- `SalesImporter`: reutiliza entidades existentes, registra as compras e calcula o total.
- `ImportsController`: recebe o upload e apresenta sucesso ou erro.
- `User`: autentica usuários com senha protegida por BCrypt.

O preço unitário é armazenado em `Purchase`, preservando o valor praticado no momento da venda. Toda importação ocorre em uma transação: uma linha inválida impede salvamento parcial.

## Autenticação

O cadastro exige nome, e-mail único e senha de pelo menos oito caracteres. Senhas nunca são armazenadas diretamente: `has_secure_password` mantém apenas o hash BCrypt em `password_digest`.

Após login, o identificador do usuário fica na sessão do Rails. A sessão é regenerada no login e no cadastro para evitar session fixation. Todas as rotas de upload exigem autenticação, e mensagens de erro não revelam se o e-mail ou a senha está incorreto.

## Validações

- Extensão `.tab` ou `.tsv`;
- tamanho máximo de 5 MB;
- máximo de 10.000 vendas;
- encoding UTF-8;
- cabeçalho e seis colunas obrigatórias;
- campos não vazios;
- preço decimal não negativo;
- quantidade inteira positiva.

Arquivos TSV são texto puro e não possuem uma assinatura binária (magic number) confiável. Por isso, a validação combina extensão, encoding, estrutura e conteúdo.

## Testes e qualidade

```bash
rails test
bundle exec rubocop
bundle exec brakeman --no-pager
bundle exec bundler-audit
```

O GitHub Actions executa testes, lint e verificações de segurança a cada push na `main` e em pull requests.

Os testes automatizados cobrem validação de arquivos, normalização, cálculo do total, upload, cadastro, login, logout e proteção de acesso.

## Decisões e limitações

- Compradores, comerciantes e itens são reutilizados para evitar duplicação de entidades.
- Cada linha importada representa uma nova venda. Reenviar o mesmo arquivo cria novas compras intencionalmente.
- A autenticação tradicional foi adicionada como bônus sem depender de provedores externos ou credenciais OAuth.

## Solução de problemas

### Falha ao conectar na porta 5432

Confirme que o PostgreSQL está ativo e que as credenciais do `.env` estão corretas:

```bash
pg_isready -h localhost -p 5432
```

### Banco inexistente ou migrations pendentes

```bash
rails db:create
rails db:migrate
```

### Dependências ausentes

```bash
bundle install
```
