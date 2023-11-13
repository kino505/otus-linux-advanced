#!/bin/bash
export APPLICATION=m1-t2
#export STATE_BUCKET=sf-terraform-prod
export REF=master
export TF_CLI_ARGS_apply="-auto-approve"
#export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export REPO=git@github.com:kino505/otus-linux-advanced.git//terraform-modules/yc
#env|grep TF_

work_dir_prefix=_work_
tf_act=${1:-plan}

wd="${work_dir_prefix}/${APPLICATION}"
#if [ -d ${wd} ]; then
# rm -rf ./${wd}
#fi

mkdir -p ./${wd}
terraform -chdir=./${wd} init -from-module=${REPO}/${APPLICATION}?ref=${REF} -upgrade
cp ./vars.auto.tfvars.json ./${wd}/

terraform -chdir=./${wd} $tf_act


