# Utilização do ambiente para desenvolvimento

## Verificar se o docker está iniciado
```
docker ps

```
Caso não apareça a listagem de containers, executar o comando
```
sudo service docker start
```
Após o docker estar iniciado os comando para iniciar o amabiente sever dentro da pasta server, onde se encontra o arquivo docker-compose.yml

```BASH
# Para iniciar
docker-compose up -d

# Para desligar
docker-compose stop
```