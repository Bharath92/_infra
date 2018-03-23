#!/bin/bash -e

bootstrap_admiral() {
  apt-get update
  apt-get install -y git-core
  git clone https://github.com/Shippable/admiral.git /root/admiral
  cd /root/admiral
  export ADMIRAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
  export DB_IP=$ADMIRAL_IP
  ./admiral.sh install --installer-access-key {{ACCESS_KEY}} --installer-secret-key {{SECRET_KEY}} --dev --password {{PASSWORD}} --silent
  docker pull 374168611083.dkr.ecr.us-east-1.amazonaws.com/api:master
  docker pull 374168611083.dkr.ecr.us-east-1.amazonaws.com/micro:master
  docker pull 374168611083.dkr.ecr.us-east-1.amazonaws.com/www:master
  docker pull 374168611083.dkr.ecr.us-east-1.amazonaws.com/mktg:master
  docker pull 374168611083.dkr.ecr.us-east-1.amazonaws.com/genexec:master
  docker pull 374168611083.dkr.ecr.us-east-1.amazonaws.com/nexec:master
}

bootstrap_admiral
