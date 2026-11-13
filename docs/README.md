# Global structure
Each project has its own Dockerfile. A docker-compose.yml file is at the project root directory to manage all services.
There is another docker-compose.yml file for production only. We put it in [deploy](../deploy).

## For developpers
To start the project locally, juste use:
- ``docker compose up`` to up the full stack
- ``docker compose up <service>`` to up a specific service

## For SysAdmins / persons in charge of deployment
Since we are not using CI, you will have to realize some steps to deploy your new application in production.

### Build a new image and push it to a registry 
An example to build and push the vote service:

**Requirements:** You need to be login to your container registry. Use ``docker login`` if you are not.

```shell
docker compose build vote
docker images
```
Retrieve the ID of the image you want to push.
```shell
docker tag <ID> repository/image_name:image_tag
docker image push repository/image_name:image_tag
```

### Deploy to the new app
You can update your service to use the new image tag. Here is an example for the vote service:

Retrieve the service ID:
```shell
docker service ls
```

Apply an image update:
```shell
docker service update --image elasad0306/vote:1.1.0 <SERVICE_ID>
```

---

### Another alternative
You can also make changes to the docker-compose production file and re-deploy the stack. In this case, you must copy the new docker-compose file in the manager and redeploy the stack. This can be done by running [this script](../deploy/deploy.sh).

## References

- [Swarm cluster](./DEPLOY.md)
- [Vote app migration / architecture documentation](VOTE.md)
- [Worker app migration / architecture documentation](WORKER.md)