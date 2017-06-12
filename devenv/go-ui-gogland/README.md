# Go Gogland UI shell image

## Links
- [Docker Best Practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
- [Docker UI reference](https://github.com/jessfraz/dockerfiles)
- [Setting X11 Forwarding for GUI Applications](https://www.hoffman2.idre.ucla.edu/access/x11_forwarding/)
- [Running Linux GUI Apps in Windows using Docker](https://manomarks.net/2015/12/03/docker-gui-windows.html)
- [Dockerize an SSH service](https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container)

## Build container image
```bash
<SOLUTION_ROOT>/build/image_build.sh devenv/go-ui-gogland
```

## Publish container image
```bash
<SOLUTION_ROOT>/build/image_publish.sh devenv/go-ui-gogland
```

### Prepare X Server (OS X)

- Install XQuartz

Next we are going to install XQuartz - which basically gives you an X11 display client on your OSX desktop. Just grab the package at [http://xquartz.macosforge.org/landing/](http://xquartz.macosforge.org/landing/) and do the usual OSX procedure for installing it.

```bash
defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
```

- Start socat (in my testing it had to be done first)
```bash
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```
- Start XQuartz

## Run a container
```bash
#
# Run in local docker
#

XServerHost=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

# optional (firewall settings)
# xhost + $ip

LocalShellWorkingDir=~/Documents/ch/devshell/go_sample_env_1
RemoteShellWorkingDir=/home/cloud

# Privileged mode is needed for debugging
docker run --privileged \
    --rm \
    -it \
    -u cloud \
    -e DISPLAY=$XServerHost:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/Documents:$RemoteShellWorkingDir/Documents \
    -v $LocalShellWorkingDir/.Gogland1.0:$RemoteShellWorkingDir/.Gogland1.0 \
    -v $LocalShellWorkingDir/GoglandProjects:$RemoteShellWorkingDir/GoglandProjects \
    -v $LocalShellWorkingDir/.java:$RemoteShellWorkingDir/.java \
    -v $LocalShellWorkingDir/.yjp:$RemoteShellWorkingDir/.yjp \
    -v $LocalShellWorkingDir/.cache:$RemoteShellWorkingDir/.cache \
    sergeinipub.azurecr.io/devenv/go-ui-gogland-shell:amd64-latest \
    -c "./gogland/bin/gogland.sh"
```

```bash
#
# Run in remote docker
#

# Pull the image 
docker pull sergeinipub.azurecr.io/devenv/go-ui-gogland-shell:amd64-latest

# env mapping variables
XServerHost=10.4.5.45
LocalShellWorkingDir=/media/shared/go_sample_env_1
RemoteShellWorkingDir=/home/cloud

# Privileged mode is needed for debugging
docker run --privileged \
    --rm -e DISPLAY=$XServerHost:0 \
    -d \
    -v $LocalShellWorkingDir/ch:$RemoteShellWorkingDir/ch \
    -v $LocalShellWorkingDir/.Gogland1.0:$RemoteShellWorkingDir/.Gogland1.0 \
    -v $LocalShellWorkingDir/GoglandProjects:$RemoteShellWorkingDir/GoglandProjects \
    -v $LocalShellWorkingDir/.java:$RemoteShellWorkingDir/.java \
    -v $LocalShellWorkingDir/.yjp:$RemoteShellWorkingDir/.yjp \
    -v $LocalShellWorkingDir/.cache:$RemoteShellWorkingDir/.cache \
    -p 22022:22022 \
    sergeinipub.azurecr.io/devenv/go-ui-gogland-shell:amd64-latest \
    -c "./gogland/bin/gogland.sh"

# ssh container with X Forwarding (run on the client)
ssh -Y -l cloud g-1 -p 22022

# inspect image content
docker run -it sergeinipub.azurecr.io/devenv/go-ui-gogland-shell:amd64-latest -c zsh
```