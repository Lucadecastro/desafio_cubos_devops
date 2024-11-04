import http from 'http';
import PG from 'pg';
import promClient from 'prom-client';

// Porta do servidor agora utiliza variável de ambiente 'PORT', caso não esteja definida, usará porta 8080 por padrão
const port = Number(process.env.PORT) || 8080;

// Criação de um registrador padrão pro Prometheus
const register = new promClient.Registry();
promClient.collectDefaultMetrics({ register });

// Configura conexão com PostgreSQL usando varíaveis de ambiente, utilizando um objeto para maior legibilidade.
const dbClient = new PG.Client({
  connectionString: `postgres://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`
});

let successfulConnection = false; // Indica status da conexão com o banco de dados

// Função para conectar ao banco uma única vez quando o servidor inciar
async function connectDatabase() {
  try {
    await dbClient.connect();
    console.log("Database connected successfully");
    successfulConnection = true; // Atualiza status da conexão ao estabelece-la com sucesso.
  } catch (error) {
    console.error("Failed to connect to database -", error.stack);
  }
}

connectDatabase(); // Chamada da função, inicia a conexão com o banco ao subir o servidor.

// Cria servidor HTTP que responde a requisições de acordo com a rota acessada pelo cliente
http.createServer(async (req, res) => {
  console.log(`Request: ${req.url}`);

  if (req.url === "/metrics") {
    try {
      res.setHeader("Content-Type", register.contentType);
      res.writeHead(200);
      res.end(await register.metrics()); // Exibe métricas coletadas
    } catch (err) {
      console.error('Erro ao coletar métricas:', err);
      res.writeHead(500);
      res.end('Internal Server Error');
    }
  } else if (req.url === "/api") {
    res.setHeader("Content-Type", "application/json");

    let result;
    let userAdmin = false; // Inicia como false mudando para true caso usuário seja 'admin'

    // Condicional para executar a consulta no banco apenas se ele estiver conectado
    if (successfulConnection) {
      try {
        // Realiza a consulta no banco e armazena o primeiro usuário na variável 'result'
        const queryResult = await dbClient.query("SELECT * FROM users");
        result = queryResult.rows[0];

        // Verifica se papel do usuário encontrado é "admin"
        if (result && result.role === "admin") {
          userAdmin = true;
        }
      } catch (error) {
        console.error("Error querying database -", error.stack);
      }
    }

    // Retorna JSON indicando status do banco e se o usuário admin foi encontrado
    const data = {
      database: successfulConnection,
      userAdmin: userAdmin
    };

    res.writeHead(200);
    // Finaliza resposta HTTP e converte o objeto data em string JSON
    res.end(JSON.stringify(data));
  } else {
    res.writeHead(503);
    res.end("Internal Server Error");
  }
}).listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});

/* Código antigo para referência:

-> Porta original do servidor, utilizando 'port' com letras minúsculas.
const port = Number(process.env.port);

-> Configuração antiga do cliente do PostgreSQL, sem utilizar um objeto para a configuração.
const client = new PG.Client(
  `postgres:{user}:${pass}@${host}:${db_port}`
);

-> Conexão ao banco de dados era feita em cada requisição, dentro do bloco if.
client.connect()
  .then(() => { successfulConnection = true })
  .catch(err => console.error('Database not connected -', err.stack));

-> Em cada requisição ao endpoint "/api", a conexão com o banco era estabelecida novamente,
-> o que poderia levar a problemas de performance e conexão excessiva.

-> Lógica original de retorno dos dados do banco de dados:
result = (await client.query("SELECT * FROM users")).rows[0];

-> Não havia verificação se 'result' existia antes de acessar 'result.role', o que
-> poderia resultar em erro se a tabela 'users' estivesse vazia.

*/