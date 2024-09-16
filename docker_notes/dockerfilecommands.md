
### FROM 
       -----> source/base image
RUN ----> to run all commands (Executes commands in a new layer on top of the current image and commits the results)
COPY ---> copy files or directories from host machine to into docker image only, can not copy from url
ADD --- Copy from either from docker server or from URL. and it will be extrated the zip or tar files durig the add.
#### WORKDIR  ----> Switch to working directory
Sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow.
```
WORKDIR /path/to/directory
WORKDIR /app

```
LABEL Createdby = "Naga" ---> Adds metadata to the image in the form of key-value pairs
MAINTAINER "mycompany"
#### EXPOSE ----> 8080
Informs Docker that the container will listen on the specified network ports at runtime. This does not actually publish the port but is used for documentation and container linking.

```
EXPOSE <port> [<port>/<protocol>...]
EXPOSE 8080

```
#### ENTRYPOINT ---> ["/BIN/BASH"]
 Configures a container to run as an executable. Unlike CMD, ENTRYPOINT cannot be overridden by command-line arguments.
 ```
 ENTRYPOINT ["executable", "param1", "param2"]

 ENTRYPOINT ["java", "-jar", "/app.jar"]

```
#### CMD ---> [/ETC/ENTRYPOINT.SH"] ---it can override the entrypoint, provides default commands that will be executed when a container is run. Only the last 'CMd' in the dockerfile will take effect.
```
 CMD ["executable","param1","param2"]
 CMD ["python", "app.py"]

```
#### VOLUME ---> 
Creates a mount point with a specified path and marks it as holding externally mounted volumes from the host or other containers.
```
Syntax:

VOLUME ["/path/to/directory"]
Example:
VOLUME ["/data"]

```
#### ENV ---> 
```
 ENV <key>=<value>

 ENV NODE_ENV=production

```
#### USER --->
Specifies the user name or UID (and optionally the user group or GID) to use when running the image and for any subsequent RUN, CMD, and ENTRYPOINT commands.

```
USER <user>[:<group>]

USER nobody

```

#### ARG
Defines a variable that users can pass at build-time to the Docker build process.

```
ARG <name>[=<default value>]

Example:

ARG VERSION=1.0
RUN echo "Building version $VERSION"

```

```docker
FROM ubuntu:latest
RUN apt update -y
RUN apt install net-tools vim nano -y
CMD ["/bin/bash"]
```
```docker
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

```docker
# Use an official Maven image as the base image
FROM maven:3.8.4-openjdk-11
# Create a working directory inside the container
WORKDIR /app
# Copy the pom.xml file to the container
COPY pom.xml .
# Download the project dependencies
RUN mvn dependency:go-offline
# Copy the rest of the application source code to the container
COPY src ./src
# Build the application
RUN mvn package
# Define the command to run your application
CMD ["java", "-jar", "target/bmi-1.0.jar"]
# EXPOSE port
EXPOSE 8000
```
---

### Build tools

```
* Program language                     build tools                                 Dependencies
* Java                                 Maven, Ant, Gradle, IntelliJ                POM.xm,
* .Net                                 Visual Studio, MSBuild                      .csproj
* Python                               Python                                      requirement.txt
* Ruby                                 Ruby                                        gems.txt
* Node.JS                              NPM                                         packages.json

```

* **Artifact** is a runnable application which can run with out further building the application or program

In the context of Docker, a "staged build" refers to a technique called **multi-stage builds**. This approach is used to create Docker images in multiple steps or stages within a single Dockerfile. Each stage can have its own base image, instructions, and files. The primary benefits of using multi-stage builds are to:

1. **Reduce Image Size**: By using multi-stage builds, you can include tools and dependencies only in the stages where they are needed, and exclude them from the final image. This helps in creating smaller, more efficient Docker images.

2. **Improve Security**: Since only the necessary artifacts are included in the final image, this reduces the attack surface and limits the potential vulnerabilities.

3. **Optimize Build Process**: You can reuse intermediate layers across different stages, improving the overall build speed.

### Example with out a multi-Stage build

```Dockerfile
# Use an official Maven image as the base image
FROM maven:3.8.4-openjdk-11
# Create a working directory inside the container
WORKDIR /app
# Copy the pom.xml file to the container
COPY pom.xml .
# Download the project dependencies
RUN mvn dependency:go-offline
# Copy the rest of the application source code to the container
COPY src ./src
# Build the application
RUN mvn package
# Define the command to run your application
CMD ["java", "-jar", "target/bmi-1.0.jar"]
# EXPOSE port
EXPOSE 8000
```
### Example of a Multi-Stage Dockerfile

```Dockerfile
# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the project files and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the files and build the project
COPY . ./
RUN dotnet publish -c Release -o /out

# Stage 2: Create the final runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

# Copy the compiled output from the build stage
COPY --from=build /out .

# Command to run the application
ENTRYPOINT ["dotnet", "YourApp.dll"]
```

### Explanation

- **Stage 1 (`build`)**: This stage uses the .NET SDK image to compile the application. It includes all the necessary tools for building, such as compilers and other build dependencies.
  
- **Stage 2 (`runtime`)**: This stage uses a smaller .NET runtime image, which only includes the runtime environment without any build tools. The output of the first stage (`/out`) is copied into this final stage.

By using multi-stage builds, the final image only contains the necessary runtime environment and the application itself, without any of the build-time dependencies, resulting in a smaller, more secure image.