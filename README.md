# Iubank Api

Sistema para gerenciar contas bancárias de clientes, permitindo fazer transferências de um cliente para outro e expor o saldo atual da conta, sempre em reais.

### Stack de desenvolvimento do projeto:

- Ruby 2.7.2 (linguagem de Programação)
- Rails 6.0.3.4 (Framework)
- MySql (Banco de Dados)
- Docker + Docker-compose (Infraestrutura para desenvolvimento em containers)
- Knock - ( Gem utilizada para criação da autenticação através de token JWT)
- Rspec (Suite de testes)

## Requisitos para instalação

```bash
docker version 19.03.6
docker-compose 1.21.2
```

## Instalação

### Obs. Caso tenha problemas para executar o docker utilizar o sudo ou dar permissão ao seu usuário no grupo do docker.

1 - Clonar repositório

```git
git clone https://github.com/garibeiro1993/iubank.git
```
2 - Acessar diretório do projeto

```bash
cd iubank
```

3 - Crie um novo arquivo chamado .env e copie o conteúdo do arquivo .env.example para dentro dele, este arquivo armazena as variáveis de ambiente de conexão com o banco de dados mysql, ex:

```bash
# Rails Application
DB_NAME_PROD=iubank_db_production
DB_NAME_DEV=iubank_db_development
DB_NAME_TEST=iubank_db_test
DB_USER=root
DB_PASSWORD=password
DB_HOST=mysql

# MySQL
MYSQL_ROOT_PASSWORD=password
MYSQL_DATABASE=mysql
MYSQL_USER=appuser
MYSQL_PASSWORD=password

```
4 - Buildar aplicação

```bash
docker-compose build
```

5 - Criar o Banco e Rodar as Migrations

```bash
docker-compose run --rm app bundle exec rails db:drop db:create db:migrate
```

5 - Executar esteira de testes

```bash
docker-compose run --rm app bundle exec rspec
```

6 - Start na aplicação

```bash
docker-compose up
```

# Rest Api Utilização



## Conteúdo da requisição

#### api/v1/accounts

- id (inteiro)(opcional)
- name (string)(obrigatório)
- balance (inteiro)(obrigatório) - Em centavos de real Exemplo: 13052 (R$ 130,52))
- email (string)(obrigatório)
- password (string)(obrigatório) - Minimo de 8 caracteres

## Criar conta

### Request

```curl
curl -X POST \
  http://localhost:3000/api/v1/accounts/ \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "id": 2330,
    "name": "Conta Iugu Premium",
    "balance": 10000,
    "email": "email_ex_1@gmail.com",
    "password": "12345678"
}
'
```

### Response

```curl
{
  "id": 2330,
  "name": "Conta Iugu Premium",
  "balance": 10000,
  "email": "email_ex_1@gmail.com",
  "token": {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDYwNTgzNjAsInN1YiI6MjMzMH0.LP_qIitP8cbgVlLVVxNCX5gDFW_k1Z3g3PBExKTeZEw"
  }
}
```
## Conteúdo da requisição

#### api/v1/transfers

- amount (inteiro)(obrigatório) - Em centavos de real Exemplo: 13052 (R$ 130,52))
- destination_account_id (inteiro)(obrigatório)

## Criar Transferência

### Request

```curl
curl -X POST \
  http://localhost:3000/api/v1/transfers/ \
  -H 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDYwNTgzNjAsInN1YiI6MjMzMH0.LP_qIitP8cbgVlLVVxNCX5gDFW_k1Z3g3PBExKTeZEw' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{
    "amount": 1000,
    "destination_account_id": "2331"
}'
```

### Response

```curl
{
  "id": 3,
  "source_account_id": 2330,
  "destination_account_id": 2331,
  "amount": 100
}
```

## Conteúdo da requisição

#### api/v1/accounts/:id

- id (inteiro)(obrigatório)

## Consultar Saldo

### Request

```curl
curl -X GET \
  http://localhost:3000/api/v1/accounts/2330 \
  -H 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDYwNTg2MjMsInN1YiI6MjMzMH0.tlqKr0ESUdJ5jbrH-7EzLyFqOpojdtEMFvOuKhhMuZw' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json'
```

### Response

```curl
 { "balance":9000 }
```

## Conteúdo da requisição

#### api/v1/account_token

Para gerar um novo token é necessário informar o email e senha utilizado no ato da criação da conta.

- email (string)(obrigatório)
- password (string)(obrigatório)

## Gerar um novo token (Endpoint Adicional)

### Request

```curl
curl -X POST \
  http://localhost:3000/api/v1/account_token \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -d '{ "auth": {
	"email": "email_ex_1@gmail.com",
	"password" : "12345678"
} }'
```

### Response

```curl
 {"jwt":"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDYwNjQ0MzksInN1YiI6MjMyM30.XtI8UmJePhcjONL9ouzM2QVme5vGc53KQqX6FXOTVj4"}
```

## Considerações finais

Primeiro gostaria de explicar algumas decisões tomadas no processo de desenvolvimento de cada feature:

### - Criação da conta

- Além dos parâmetros iniciais para criação da conta também inclui informação de email e senha, pois, é um padrão utilizado pela gem knock que vincula o token a estes dados, achei bacana fazer desta forma, pois, além do processo padrão é possível resgatar um token de acesso fazendo a requisição no endpoint de gerar um novo token, conforme descrito na documentação em **Gerar um novo token (Endpoint Adicional)**.

- Por não ser uma feature com muitas regras não senti a necessidade de abstrair em um serviço.

### - Transferir dinheiro

- Foi solicitado o source_account_id como parâmetro de entrada, porém, como estou usando a gem knock a mesma já prove um método de current user quando usuário está autenticado, por este motivo não inclui o mesmo na requisição, podendo apenas informar o destination e amount para efetuar a transferência.


### - Teste unitários.

- Tentei cobrir o máximo possível de casos de teste, principalmente no serviço que realiza as transferências, foram cobertos mais de 30 cenários, onde utilizei o máximo de contextos que consegui imaginar.


### - Meus agradecimentos

- Obrigado por todo o processo, espero ter conseguido demonstrar o máximo os meus conhecimentos técnicos.
