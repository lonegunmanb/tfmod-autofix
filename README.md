# Autofix

This repo provides a scaffold to help you run some auto fixes and checks on your Terraform configs.

To run it:

```bash
curl -H 'Cache-Control: no-cache, no-store' -sSL "https://raw.githubusercontent.com/lonegunmanb/tfmod-autofix/main/scripts/run.sh" | bash
```

You must have `docker` installed, if you want to use other container tool, like `podman`, you can set the environment variable `CONTAINER_RUNTIME`, like:

```bash
export CONTAINER_RUNTIME=podman
```

If you'd like to run it inside a container, like `docker`, please set `IN_CONTAINER` to any value, like:

```bash
docker run --rm -e IN_CONTAINER=1 -v $(pwd):/src -w /src -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID mcr.microsoft.com/azterraform:latest bash -c "curl -H 'Cache-Control: no-cache, no-store' -sSL "https://raw.githubusercontent.com/lonegunmanb/tfmod-autofix/main/scripts/run.sh" | bash"
```

You must have Azure credential set up, you can use `az login` to log in to Azure CLI, or set the environment variable `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, and `ARM_TENANT_ID`.
