#!/usr/bin/env bash
echo "which2"
which tfenv

echo "terragrunt"
cat /opt/tgenv/bin/terragrunt

echo "run use"
/opt/tfenv/bin/tfenv use 1.1.5

echo "opt"
ls -la /opt

echo "opt/tfenv"
ls -la /opt/tfenv

echo "opt/tfenv/versions"
ls -la /opt/tfenv/versions

echo "list"
/opt/tfenv/bin/tfenv list

echo "version"
/opt/tfenv/bin/tfenv version-name

echo "path"
echo "${TFENV_TERRAFORM_VERSION}"