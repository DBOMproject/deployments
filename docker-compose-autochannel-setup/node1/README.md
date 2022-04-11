# Quick Start guide for Auto-Channel Setup- Node1

## Prerequistes 

- Linux Server
- Docker - v18.0 or higher
- Docker Compose - v1.25.0 or higher
- Git client - needed for clone commands
- Make sure hostname is resolvable by IP and not by localhost IP(127.0.0.1). If not edit /etc/hosts file to add network IP against the hostname.



## Setup

Clone this Git repository and navigate to the node1 folder under docker-compose-autochannel.

```sh
cd docker-compose-autochannel-setup/node1/
```

### Generating a configuration file


The first step is to generate a valid config file for the homeserver. 
- Build the .env file using the .env.example 
- Create a data directory and update the server_name for homeserver in the docker-compose file under homeserver2 service environment variables. Refer samplehomeserver.yaml for server_name definition and naming conventions.

Note: Ensure that the user has appropriate permissions to create files inside data directory.



```sh
mkdir data
chmod <appropriate_perm> data
docker-compose run --rm homeserver1 generate
```

This will generate the config file inside ./data, named "homeserver.yaml".

### Configure Homeserver

- Generate ssl certificates for TLS connection.
```sh
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

With the containers started, next, test the APIs by executing the script - testAPIs.sh. This will also populate some data on this dbom channel which we will access via the other node.

```sh
chmod +x testAPIs.sh
./testAPIs.sh
```

### Register User in the Homeserver

To register a user account run the following command with appropriate values. HOMESERVER_URL is the public-facing domain of the home server.  

```
curl -XPOST -k -d '{"username":<<USERNAME>>, "password":<<PASSWORD>>, "auth": {"type":"m.login.dummy"}}' "https://<<HOMESERVER_URL>>/_matrix/client/r0/register"
```
Example-
```
curl -XPOST -k -d '{"username":"user1", "password":"Matrix1234", "auth": {"type":"m.login.dummy"}}' "https://example.com:8480/_matrix/client/r0/register"
```

Copy the acess token from the output of the above command and use it as paramter while creating public room.

### Login to the matrix server using the registered user

```
curl -XPOST -k "http://<<FEDAGENT_URL>>/login"
```
FEDAGENT_URL is the server address on which federation agent is running.

Example-
```
curl -XPOST -k "http://example.com:6000/login"
```
### Create a public room 

Create a public room using the following curl command. 

```
curl -XPOST -k -d '{"room_alias_name":"<<room_aliasname>>", "preset": "public_chat","name": "<<room_name>>"}' "https://<<HOMESERVER_URL>>/_matrix/client/r0/createRoom?access_token=YOUR_ACCESS_TOKEN"
```
Example-
```
curl -XPOST -k -d '{"room_alias_name":"tutorial", "preset": "public_chat","name": "tutorial"}' "https://example.com:8480/_matrix/client/r0/createRoom?access_token=YOUR_ACCESS_TOKEN"
```
Copy the room alias from the output and share it with the other node user.

### Get list of subscription requests 

To query the list of subscription requests use the following curl command.
```
  curl -k "http://<<FEDAGENT_URL>>/subscriptionRequests/"
```

Example-

```
curl -k "http://example.com:6000/subscriptionRequests/"
```
Copy the request ID of particular request to accept/reject the request.


### Accept the subscription request

To approve a subscription request use the following curl command.
```
  curl -k "http://<<FEDAGENT_URL>>/subscriptionRequests/<<REQUEST_ID_HERE>>/accept"
```

Example-

```
curl -k "http://example.com:6000/subscriptionRequests/<<REQUEST_ID_HERE>>/accept"
```

### Reject the subscription request

To reject a subscription request use the following curl command.
```
  curl -k "http://<<FEDAGENT_URL>>/subscriptionRequests/<<REQUEST_ID_HERE>>/reject"
```

Example-

```
curl -k "http://example.com:6000/subscriptionRequests/<<REQUEST_ID_HERE>>/reject"
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

- The queue for holding subscription requests is in-memory implementation so the subscription requests will be erased on closing the fedagent application.





