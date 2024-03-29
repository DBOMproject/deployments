# Quick Start guide for Auto-Channel Setup- Node2

## Prerequiste 

- Linux Server
- Docker - v18.0 or higher
- Docker Compose - v1.25.0 or higher
- Git client - needed for clone commands
- Make sure hostname is resolvable by IP and not by localhost IP(127.0.0.1). If not edit /etc/hosts file to add network IP against the hostname.

## Setup

Clone this Git repository and navigate to the node2 folder under docker-compose-autochannel.

```sh
cd docker-compose-autochannel-setup/node2/
```
### Generating a configuration file
The first step is to generate a valid config file for the homeserver. 
- Build the .env file using the .env.example 
- Create a data directory and update the server_name for homeserver in the docker-compose file under homeserver2 service environment variables. Refer samplehomeserver.yaml for server_name definition and naming conventions.

Note: Ensure that the user has appropriate permissions to create files inside data directory.

```sh
mkdir data
chmod <appropriate_perm> data
docker-compose run --rm homeserver2 generate
```

This will generate the config file inside ./data, named "homeserver.yaml".

### Configure Homeserver

- Generate ssl certificates for TLS connection.
```
openssl req -x509 -newkey rsa:4096 -keyout "./data/<<server_name>>.tls.key" -out "./data/<<server_name>>.tls.crt" -days 365 -nodes -subj "/O=matrix"
```

- Refer the samplehomeserver.yaml for the required parameters and edit the homeserver.yaml file with appropraite values.

### Deploy Applications

Launch the applications using docker-compose 

```sh
docker-compose --env-file ./.env -f docker-compose.yaml up -d 
```

Once you run this command, the latest images will be pulled from DockerHub and the containers will come up. If you want to use a specific version of the containers, please edit the compose file to point to the appropriate versions

```sh
docker ps
```
The output should list all the containers configured in docker-compose file.


### Register User in the Homeserver

To register a user account run the following command with appropriate values.
HOMESERVER_URL is the public-facing domain of the home server.

```
curl -XPOST -k -d '{"username":<<USERNAME>>, "password":<<PASSWORD>>, "auth": {"type":"m.login.dummy"}}' "https://<<HOMESERVER_URL>>/_matrix/client/r0/register"
```
Example-
```
curl -XPOST -k -d '{"username":"user2", "password":"Matrix1234", "auth": {"type":"m.login.dummy"}}' "https://example.com:8481/_matrix/client/r0/register"
```

### Login to the matrix server using the registered user

```
curl -XPOST -k "http://<<FEDAGENT_URL>>/login"
```
FEDAGENT_URL is the server address on which federation agent is running.

Example-
```
curl -XPOST -k "http://example.com:6000/login"
```

### Subscribe to a channel on Node1

To subscribe to a DBoM channel, use the following curl command. FEDAGENT_URL is the server address on which federation agent is running.
```
curl -XPOST -k --header 'Content-Type: application/json' -d '{"roomId": "<<roomalias from node1>>","action": "JOIN","repoID": "<<repoID>>","channelId": "<<channelId>>","role": "<<read/write>>"}' "https://<<FEDAGENT_URL>>/subscribeChannel"
```
Example-
``` 
curl -XPOST -k --header 'Content-Type: application/json' -d '{"roomId": "#tutorial:example.com:8480","action": "JOIN","repoID": "DB1","channelId": "C1","role": "read"}' "http://example.com:6000/subscribeChannel"
```
Store the request id to be used later for querying suscription status.

### Query subscription status

To query the subscription of channel status use the following curl command.
```
  curl -k "http://<<FEDAGENT_URL>>/getRequestState/<<REQUEST_ID_HERE>>"
```

Example-

```
curl -k "http://example.com:6000/getRequestState/<<REQUEST_ID_HERE>>"
```

## Troubleshooting 

- If you face any issues with file permissions, please update the file permission for the user using chown and chgrp commands

Example 

```sh
chown '<current_user>' <file_name>
chgrp '<user_grp>' <filename>
```
- If any of the container fails to start. Please check the logs for that respective container 

```
docker ps
docker logs <container_id_from_ps_cmd>
```








