# MongoDB 7 Center for Internet Security Benchmarks

This project aims to demonstrate various way of remediating issues highlighted by Center for Internet Security (CIS)
depending on how your chosen instance is being run, e.g. via docker-compose, docker stack, kubernetes etc.

## Development

- [MongoDB v7](https://www.mongodb.com/docs/manual/release-notes/7.0/)
- [Docker for desktop](https://www.docker.com/products/docker-desktop/)
- [Studio 3T (Free edition)](https://studio3t.com/free/)

## Environment variables

The following environment variable need to be set before attempting to start any of the services.

| Environment Variable | Description                                                                                     |
| -------------------- | ----------------------------------------------------------------------------------------------- |
| MONGO_ROOT_USERNAME  | The [root](https://www.mongodb.com/docs/manual/reference/built-in-roles/#root) users' username. |
| MONGO_ROOT_PASSWORD  | The root users' password                                                                        |

## Helpful commands

The following below are a list of commands that are helpful to verify various.

Print a list of all the databases created:

```shell
mongosh -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --quiet --eval  "printjson(db.adminCommand('listDatabases'))"
```
