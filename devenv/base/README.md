# Base shell image

## Links
- [Docker Best Practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)

## Build container image
```bash
<SOLUTION_ROOT>/build/image_build.sh devenv/base
```

## Publish container image
```bash
<SOLUTION_ROOT>/build/image_publish.sh devenv/base
``` 

## Run a container
```bash
docker run -it -u cloud sergeinipub.eastus2.cloudapp.azure.com/devenv/base-shell:amd64-latest zsh
```