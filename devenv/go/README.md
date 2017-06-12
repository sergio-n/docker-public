# Go image

## Links
- [Docker Best Practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)

## Build container image
```bash
<SOLUTION_ROOT>/build/image_build.sh devenv/go
```

## Publish container image
```bash
<SOLUTION_ROOT>/build/image_publish.sh devenv/go
```

## Run a container
```bash
# amd64
docker run -it -u cloud -v ~/Documents/ch/data:/home/cloud/data sergeinipub.azurecr.io/devenv/go-shell:amd64-latest zsh
```