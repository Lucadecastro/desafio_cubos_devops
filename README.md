# Desafio técnico - Cubos DevOps

Este repositório contém um setup containerizado para um ambiente seguro e isolado utilizando Docker, Docker Compose e Terraform. Ele incluí um frontend, backend, banco de dados PostgreSQL, bem como ferramentas de monitoramento Prometheus e Grafana configuradas para monitorar o ambiente e trabalharem em redes separadas com o backend acessível apelas pelo frontend e banco de dados.

## Pré-Requisitos:
Certifique-se de que os seguintes softwares estejam instalados e atualizados na sua máquina:
    - [Docker](https://docs.docker.com/get-docker/)
    - [Docker Compose](https://docs.docker.com/compose/install/)
    - [Terraform](https://www.terraform.io/downloads) (versão 1.x ou superior)

## Passo a Passo para Rodar o Projeto

### 1. Clone o repositório
```bash
git clone https://github.com/Lucadecastro/desafio_cubos_devops.git
cd desafio_cubos_devops
```

### 2. Configuração de ambiente
Crie um arquivo `.env` na raíz do projeto e adicione as variáveis de ambiente necessárias:

```plaintext
DB_USER=username
DB_PASS=password
DB_HOST=postgres
DB_PORT=5432
DB_NAME=desafio
```

⚠️ **Certifique-se de que esses valores correspondem aos usados em `variables.tf`.**

### 3. Construa as Imagens Docker
Antes de iniciar a orquestração com o Terraform, construa as imagens Docker com o Docker Compose:

```bash
docker-compose build
```

Esse comando garantirá que as imagens `frontend-image` e `backend-image` estejam prontas para serem utilizadas pelo Terraform.

### 4. Setup da Infraestrutura com Terraform
Navegue até a pasta terraform e inicialize o Terraform para configurar as redes, volumes e contêineres:

```bash
cd terraform
terraform init
terraform apply
```

Este comando configurará:

    * Redes: Redes external-net e internal-net para isolamento seguro.
    * Containers: Containers para o frontend, backend e PostgreSQL conectados às redes especificadas.

### 5. Acesse a Aplicação
A aplicação estará disponível nos seguintes endereços:

    * Frontend: http://localhost
    * Backend: Acessível apenas via rota `/api` através do frontend.

### 6. Monitoramento e Observabilidade
As ferramentas de monitoramento estão configuradas da seguinte forma:

    * Prometheus: Acesse em http://localhost:9090. O prometheus é configurado para coletar métricas do backend.
    * Grafana: Acesse em http://localhost:3000. Utilize as seguintes credenciais padrão para login:
        * Usuário: `admin`
        * Senha: `admin`

### 7. Verifique a Inicialização do Banco de Dados
O banco de dados PostgreSQL será inicializado com o `script.sql`, que criará uma tabela `users` com um usuário `admin` pré-configurado.

### 8. Reinicialização Automática
Os contêineres estão configurados com `restart: always`, garantindo que sejam reiniciados automaticamente em caso de falhas inesperadas.

### 9. Verifique as Métricas no Prometheus e Grafana
    * Prometheus: Verifique se as métricas estão sendo coletadas acessando a interface do Prometheus e consultando as métricas configuradas.
        * Digite na barra de pesquisa do Prometheus `up` e clique em "Execute"
    * Grafana: Configure um dashboard no Grafana adicionando Prometheus como datasource e crie visualizações para monitorar o desempenho dos serviços.
        * Abra o menu hamburguer "Home" caso não esteja aberto
        * Selecione "Connections", depois "Add new connection", aonde você adicionará o Prometheus.
        * Em Data sources, certifique-se de incluir em "cConnection" a URL `http://prometheus:9090`
        * Não é necessário criar autenticação ou configurações avançadas, desça até o botão `Save & Test`e pode salvar.
        * Você será informado que agora pode visualizar os dados criando um dashboard ou consultando dados no Explore view!

### 10. Importando um Dashboard no Grafana
Para facilitar a visualização das métricas coletadas pelo Prometheus, você pode importar um Dashboard pronto no Grafana.

    * No Grafana, no canto superior direito, clique no ícone `+` e selecione "Import dashboard"
    * Insira a URL ou o ID de um dashboard da comunidade.
    * Clique em "Load" e aguarde a importação.
    * Selecione a fonte de dados configurada (neste caso, Prometheus) e clique em "Import"