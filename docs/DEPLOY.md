# Deploy with Docker Swarm
Needed environment variables


## Why Docker swarm
We will create a swarm cluster with 3 nodes: 
- 2 workers
- 1 Manager

**Why using docker swarm:**
- Load balancing: This is usefull to distribute the trafic when a node is overcharged.
- Scalability: Change replicas of services if needed
- If a worker is down, another maintain the app alive
- Uses a docker-compose file: Almost the same as the compose dev file


## Procedure explaination
### Configure your stack for production
First, create a ``docker-compose.yml`` file for production only: Docker swarm will use it to deploy stacks.

You must create another one because some things may differ from your dev compose file:
- Dockerfile used stage
- Service dependencies must be a list
- No build specification, you should use "image"
- Deploy section in services
- etc.

Both compose files can evolve in a different way, that's why you should have differents one.

### Configure the cluster
(For this project, we used VMs and vagrant to make easier VMs / server creation. In reality, we create a cluster on real servers, in different location if possible).

#### Creating VMs
First we created a host-only network (192.168.99.0) in our hypervisor (VMWare Workstation)

To create and manage VMs easier, we used Vagrant to:
- Assign IPs from the above network and configure VM network
- Define the VM OS (Ubuntu 26.04 LTS)
- Define hardware configuration
- Create the project directory (``/opt/docker``)
- Auto-install docker and make it accessible to the host machine

VMs names and IP addresses:
- Manager: **name:** manager1, **IP:** 192.168.99.100
- First worker: **name:** worker1, **IP:** 192.168.99.101
- Second worker: **name:** worker2, **IP:** 192.168.99.102

You can find vagrant configuration here: [Vagrantfile](../deploy/Vagrantfile)

- We use ``vagrant up`` to start VMs.
- To connect to a VM, use ``vagrant ssh <vm_name>``.

#### Creating cluster
##### Init swarm cluster
First, we connect to the manager node using ``vagrant ssh manager1``.
Then, we create the swarm cluster using ``docker swarm init --advertise-addr 192.168.99.100``
(The IP is the one of the Manager node)

##### Make nodes join the cluster
After the swarm cluster creation, a command is given to make worker VMs join the cluster.
This command is like that: ``docker swarm join --token <token> <192.168.99.100:port>``
We enter this command in both worker VMs

#### Deploy stack
First, we must build and push our images in a container registry. In a real project, we would do this in a CI job, here we will manually build the images and push in the Docker Hub. 

Usually, we would deploy using CI (Like .gitlab-ci.yml or .github/workflows/ci.yml).
We could proceed like that (simplified resume of a possible procedure):
- Add a private SSH key to the container (if deploying using docker, like gitlab-ci would do). You could add the private key in a CI env variable to have it.
- Add the new docker-compose.yml configuration file in the manager node using SCP. 
- Connect to the manager node using SSH (Manager must have the public key in its authorized-keys in the project directory). You could store the deploy user / host in CI env variables.
- Run ``docker stack deploy --compose-file docker-compose.yml voting-app``

Here, we created a bash script (as we are using local VMs, we will not create a CI file).
This [bash script](../deploy/deploy.bash) does the following procedure:
- Copy the docker compose configuration file in ``/opt/docker`` using vagrant scp (a vagrant plugin to use SCP in order to copy files through network in a VM using SSH)
- Connect to the machine via SSH : ``vagrant ssh manager1`` and deploy the stack using ``docker stack deploy --compose-file /opt/docker/docker-compose.yml voting-app``.

## Your app is ready
You can access the vote app with ``192.168.99.100:8000``, same for the result app with ``192.168.99.100:8888``.

In reality, you could buy a domain and configure a reverse proxy / external load-balancer. You could also use solutions like traefik to manage domain resolution with docker containers.

## Replication
We use three replicats for each services. It means that swarm will dispatch a replicat for each worker (and manager, since a manager can be a worker). Then, we can try to destroy a worker VM and observe that our app is still alive. We could also destroy the other worker since we can see that an instance of the app is also alive in the manager acting like a worker too.

## Continuous integration
In reality the recommanded approch could be
- Use a CI (like gitlab CI) to build your docker images and push into a registry.
- Use a CI to deploy in production on MERGE (or another event) in main (or other). It could connect using SSH to the cluster, pull the new image, update services tags if needed and redeploy stack while keeping at least one instance for each service to be sure that the app is still available during deployment.

### Why this workflow
This workflow could be a good approch because:
- Updates are delivered faster as everything is automatised with CI tools.
- Easier for developpers, they just need to think about their code, env variable they need and that's all.

That's why our approach could be better since, for each new deployment we need to:
- Push the new docker image to a registry, think about the new tag using convention (a CI would do it automatically depending of commit title convention (So a commitlint job should be added))
- Run our deployment script manually to copy the new docker-compose.yml (possibly changed) and redeploy the stack.
