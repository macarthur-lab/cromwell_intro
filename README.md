**docker image and wdl script for a simple cromwell / firecloud workflow**

Prereqs:

1. Make sure you have java v1.8 or higher
2. Create an account on [DockerHub](https://hub.docker.com)
2. Install Docker from https://hub.docker.com/editions/community/docker-ce-desktop-mac

To get started with docker:

1. build a docker image from the Dockerfile by running `make` 
(you can edit the Dockerfile to add/remove tools and edit the Makefile to control the build command)
2. use the following commands to check that the docker image and tools work as expected:

```
docker images --no-trunc
docker run -v /local/data_directory:/data_directory/inside/docker_container/ -it weisburd/feature-counts:latest
```

3. if you modified the docker image before building it, you need to also update `feature-counts.wdl` /
`feature-counts-parallel.wdl` with the new sha256 id of your docker image.

To get started with cromwell and running your .wdl workflow locally:

1. run `./download_cromwell_jars.sh` to install cromwell
2. edit the .wdl file to change the inputs, outputs, and commands that cromwell will run insider your docker image
3. validate that your .wdl and input.json specs have the correct syntax by running one of these:
```
java -jar womtool-45.1.jar validate feature-counts.wdl -i inputs.json
java -jar womtool-45.1.jar validate feature-counts-parallel.wdl -i inputs-parallel.json
```
4. run your workflow locally by running one of these:
```
java -jar cromwell-45.1.jar run -i inputs.json feature-counts.wdl
java -jar cromwell-45.1.jar run -i inputs-parallel.json feature-counts-parallel.wdl
```


