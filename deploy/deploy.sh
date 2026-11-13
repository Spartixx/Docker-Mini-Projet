#!/bin/bash

vagrant scp docker-compose.yml manager1:/opt/docker/docker-compose.yml
vagrant ssh manager1 -c "docker stack deploy --compose-file /opt/docker/docker-compose.yml voting-app"
