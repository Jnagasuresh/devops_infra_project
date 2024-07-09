Here are 20 of the most popular Docker commands that you will find useful for managing Docker containers, images, and more:

1. **docker run**  
   Run a container from an image. Example:
   ```sh
   docker run -d -p 80:80 nginx
   ```

2. **docker ps**  
   List running containers. Example:
   ```sh
   docker ps
   ```

3. **docker ps -a**  
   List all containers, including stopped ones. Example:
   ```sh
   docker ps -a
   ```

4. **docker images**  
   List all images. Example:
   ```sh
   docker images
   ```

5. **docker pull**  
   Pull an image from a registry. Example:
   ```sh
   docker pull ubuntu
   ```

6. **docker build**  
   Build an image from a Dockerfile. Example:
   ```sh
   docker build -t myapp .
   ```

7. **docker exec**  
   Run a command in a running container. Example:
   ```sh
   docker exec -it mycontainer bash
   ```

8. **docker stop**  
   Stop a running container. Example:
   ```sh
   docker stop mycontainer
   ```

9. **docker start**  
   Start a stopped container. Example:
   ```sh
   docker start mycontainer
   ```

10. **docker restart**  
    Restart a container. Example:
    ```sh
    docker restart mycontainer
    ```

11. **docker rm**  
    Remove a container. Example:
    ```sh
    docker rm mycontainer
    ```

12. **docker rmi**  
    Remove an image. Example:
    ```sh
    docker rmi myimage
    ```

13. **docker logs**  
    Fetch the logs of a container. Example:
    ```sh
    docker logs mycontainer
    ```

14. **docker inspect**  
    Return detailed information about a container or image. Example:
    ```sh
    docker inspect mycontainer
    ```

15. **docker network ls**  
    List all networks. Example:
    ```sh
    docker network ls
    ```

16. **docker network create**  
    Create a new network. Example:
    ```sh
    docker network create mynetwork
    ```

17. **docker-compose up**  
    Start services defined in a docker-compose.yml file. Example:
    ```sh
    docker-compose up
    ```

18. **docker-compose down**  
    Stop and remove services defined in a docker-compose.yml file. Example:
    ```sh
    docker-compose down
    ```

19. **docker tag**  
    Tag an image with a new name. Example:
    ```sh
    docker tag myimage myrepo/myimage:tag
    ```

20. **docker push**  
    Push an image to a registry. Example:
    ```sh
    docker push myrepo/myimage:tag
    ```

These commands are essential for managing Docker containers and images efficiently. By mastering them, you'll be able to handle most common tasks in Docker.

--------------------------------------

The command `docker exec -it mycontainer bash` is used to start an interactive terminal session inside a running Docker container. Here’s a detailed breakdown of each part of the command:

- **docker exec**: This command is used to run a command in a running container.

- **-i**: This flag stands for "interactive". It keeps the STDIN (standard input) open, even if not attached. This is necessary for interactive shell sessions where you need to provide input.

- **-t**: This flag stands for "tty" (teletypewriter). It allocates a pseudo-TTY, which essentially provides a terminal interface. This is important for running commands that require a terminal, like `bash`.

- **mycontainer**: This is the name or ID of the running container where you want to execute the command. You can find the container name or ID using the `docker ps` command.

- **bash**: This is the command to be executed inside the container. `bash` is a Unix shell and command language. By specifying `bash`, you start a bash shell session inside the container.

### What Happens When You Run the Command

1. **Locate the Container**: Docker identifies the running container by the name or ID specified (`mycontainer`).
2. **Execute the Command**: Docker runs the specified command (`bash`) inside the container.
3. **Interactive Terminal**: Because of the `-i` and `-t` flags, Docker provides an interactive terminal session. This means you can type commands into the bash shell, and see the output interactively.

### Example

To see it in action, you might use the command like this:

1. **Start a Container**:
   ```sh
   docker run -d --name mycontainer ubuntu
   ```

   This command starts a detached Ubuntu container named `mycontainer`.

2. **Execute an Interactive Bash Shell**:
   ```sh
   docker exec -it mycontainer bash
   ```

   This command opens an interactive bash shell inside the `mycontainer` container.

3. **Using the Bash Shell**:
   Once inside the container, you can run any bash commands as if you were logged into a Linux system. For example:
   ```sh
   root@<container_id>:/# ls
   root@<container_id>:/# pwd
   root@<container_id>:/# exit
   ```

### Use Cases

- **Debugging**: You can use `docker exec -it mycontainer bash` to debug issues within the container by inspecting files, checking running processes, or installing additional tools.
- **Configuration**: You can make on-the-fly configuration changes or updates within the container.
- **Development**: Developers often use this command to test changes inside a running container interactively.

This command is very powerful for interacting with running containers, providing a full-featured shell environment within the isolated container context.
-------------------------------------
docker run -it ubuntu
docker exec -it myubuntu bash
1. Start a container:
   ```sh
   docker run -d --name myubuntu ubuntu sleep infinity
   ```
   This starts a new Ubuntu container in detached mode, running `sleep infinity` to keep it alive.

2. Execute a bash shell in the running container:
   ```sh
   docker exec -it myubuntu bash
   ```
   You will be dropped into a bash shell in the running `myubuntu` container.

### Key Differences:

- **Container Creation**:
  - `docker run -it ubuntu`: Creates and starts a new container.
  - `docker exec -it ubuntu bash`: Executes a command in an already running container.

- **Container State**:
  - `docker run -it ubuntu`: Can be used to start a container from scratch.
  - `docker exec -it ubuntu bash`: Requires the container to be already running.

- **Resource Management**:
  - `docker run -it ubuntu`: Creates a new set of resources (filesystem, processes) for the new container.
  - `docker exec -it ubuntu bash`: Utilizes the existing resources of the running container.

- **Typical Use Case**:
  - `docker run -it ubuntu`: Used for starting a new container for development, testing, or initial setup.
  - `docker exec -it ubuntu bash`: Used for inspecting, debugging, or interacting with an already running 