#!/usr/bin/env bash
echo "==> Validating module terraform codes..."
error=false
(terraform init -upgrade && terraform validate -json | jq -e .valid) || error=true
if ${error}; then
     echo "------------------------------------------------"
     echo ""
     echo "Some Terraform codes contain errors."
     echo "$(terraform validate -json)"
     echo ""
     exit 1
fi
exit 0
