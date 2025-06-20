#!/usr/bin/env bash

set -e

has_error=false

echo "==> Initializing Terraform..."
terraform init -input=false

if [ -f "terraform.tfstate" ]; then
  echo "==> State file found, showing current state as JSON..."
  terraform show -json > target.json
else
  echo "==> Running Terraform plan..."
  terraform plan -input=false -out=tfplan.binary
  echo "==> Converting Terraform plan to JSON..."
  terraform show -json tfplan.binary > target.json
fi

mkdir -p ./policy/default_exceptions
curl -sS -o ./policy/default_exceptions/avmsec_exceptions.rego https://raw.githubusercontent.com/Azure/policy-library-avm/refs/heads/main/policy/avmsec/avm_exceptions.rego.bak

if [ -d "exceptions" ]; then
  conftest test --all-namespaces --update git::https://github.com/Azure/policy-library-avm.git//policy/Azure-Proactive-Resiliency-Library-v2 -p policy/aprl -p policy/default_exceptions -p exceptions target.json || has_error=true
  conftest test --all-namespaces --update git::https://github.com/Azure/policy-library-avm.git//policy/avmsec -p policy/avmsec -p policy/default_exceptions -p exceptions target.json || has_error=true
else
  conftest test --all-namespaces --update git::https://github.com/Azure/policy-library-avm.git//policy/Azure-Proactive-Resiliency-Library-v2 -p policy/aprl -p policy/default_exceptions target.json || has_error=true
  conftest test --all-namespaces --update git::https://github.com/Azure/policy-library-avm.git//policy/avmsec -p policy/avmsec -p policy/default_exceptions target.json || has_error=true
fi

if [ "$has_error" = true ]; then
  echo "==> Conftest tests failed."
  exit 1
else
  echo "==> Conftest tests passed."
fi