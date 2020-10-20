#/bin/bash

export NGINX_VERSION=1.19.3
export NSSM_VERSION=2.24-101-g897c7ad
export NODE_VERSION=12.19.0
#export current_dir = $(shell pwd)
export NGINX_LINK="http://nginx.org/download/nginx-${NGINX_VERSION}.zip"
export NGINX_PKG="nginx-${NGINX_VERSION}"
export NSSM_LINK="http://nssm.cc/ci/nssm-${NSSM_VERSION}.zip"
export NSSM_PKG="nssm-${NSSM_VERSION}"
export NODE_LINK="https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-win-${ALIASX}.zip"
export NODE_PKG="node-v${NODE_VERSION}-win-${ALIASX}"
