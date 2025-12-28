# container-images

## utils

Use `env.example` to configure your `.env` file.

```commandline
touch $(pwd)/.local/.bash_history

docker run --rm -it \
    --env-file $(pwd)/.env \
    --volume $(pwd):/app \
    --volume $(pwd)/.local/.aws:/root/.aws \
    --volume $(pwd)/.local/.tfenv/versions:/root/.tfenv/versions \
    --volume $(pwd)/.local/.terraform.d:/root/.terraform.d \
    --volume $(pwd)/.local/.bash_history:/root/.bash_history \
    ghcr.io/lotta5xx-org/container-images/utils:latest
```
