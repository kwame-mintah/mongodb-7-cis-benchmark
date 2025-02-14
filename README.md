# MongoDB 7 Center for Internet Security Benchmarks

This project aims to demonstrate various way of remediating issues highlighted by Center for Internet Security (CIS)
depending on how your chosen instance is being run, e.g. via docker-compose, docker stack, kubernetes etc.

## Development

- [MongoDB v7](https://www.mongodb.com/docs/manual/release-notes/7.0/)
- [Docker for desktop](https://www.docker.com/products/docker-desktop/)
- [Studio 3T (Free edition)](https://studio3t.com/free/)

## Addressing Benchmarks

There are several ways of addressing the issues raised by CIS, however the project will make the assumption that the MongoDB
server being started is _new_ and not an existing one. Please note, that with existing instances, some commands may need to be run
while the instance is running and sometimes requires a restart.

The [mongod.conf](./docker-compose/mongod.conf) configuration file can be used in most cases to address the concerns raised.

## Environment variables

The following environment variable need to be set before attempting to start any of the services, such as
setting the [root](https://www.mongodb.com/docs/manual/reference/built-in-roles/#root) username and password etc.

| Environment Variable | Description               |
| -------------------- | ------------------------- |
| MONGO_ROOT_USERNAME  | The root users' username. |
| MONGO_ROOT_PASSWORD  | The root users' password  |

## Usage

### Docker Compose

The following steps can be used to start up the MongoDB instance via [docker compose](https://docs.docker.com/compose/):

1. Navigate to [`/docker-compose/`](/docker-compose/) directory which contains the [`docker-compose.yaml`](/docker-compose/docker-compose.yaml) file,
2. Run container in detached mode with `docker compose up -d`.
   
### Docker Stack

The following steps can be used to start up the MongoDB instance via [docker swarm](https://docs.docker.com/engine/swarm/):

1. Navigate to the [`/docker-stack/`](/docker-stack/) which contains [`docker-compose.yaml`](/docker-stack/docker-compose.yaml) file,
2. Initialize a swarm with `docker swarm init`,
3. Deploy the services onto the node `docker stack deploy --compose-file docker-compose.yaml mongodb_cis_benchmarks --detach=false`.

### Connecting to database via Studio3T (Free edition)

The following steps can be used to connect to your MongoDB instance via Studio3T application:

1. Copy the following URL and replace words in capitals accordingly,

   ```markdown
   mongodb://MONGO_ROOT_USERNAME:MONGO_ROOT_PASSWORD@127.0.0.1:27071/admin?retryWrites=true&loadBalanced=false&serverSelectionTimeoutMS=2000&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1
   ```

2. Add a 'new connection' via Studio3T and paste into the 'URI' text box.

## Helpful commands

The following below are a list of commands that are helpful to verify various.

Print a [list of all the databases](https://www.mongodb.com/docs/manual/reference/command/listDatabases/) created:

```shell
mongosh -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD 127.0.0.1:27071 --quiet --eval  "printjson(db.adminCommand('listDatabases'))"
```

Query database for roles scoped in "admin" database:

```shell
mongosh -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD 127.0.0.1:27071 --quiet --eval "printjson(db.system.users.find({\"roles.role\":{\$in:[\"dbOwner\",\"userAdmin\",\"userAdminAnyDatabase\"]},\"roles.db\": \"admin\" }))"
```

Get [command line arguments](https://www.mongodb.com/docs/manual/reference/command/getCmdLineOpts/#getcmdlineopts) passed:

```shell
mongosh -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD 127.0.0.1:27071 --quiet --eval "printjson(db.serverCmdLineOpts())"
```
