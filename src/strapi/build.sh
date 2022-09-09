#!/bin/bash

BUILD=$1
AWS_REGION=eu-central-1

sudo docker build -t pagopa/strapi:${BUILD} .
sudo docker tag pagopa/strapi:${BUILD} 794703684555.dkr.ecr.eu-central-1.amazonaws.com/cms-p-strapi:${BUILD}

aws ecr get-login-password --region $AWS_REGION | sudo docker login --username AWS --password-stdin 794703684555.dkr.ecr.eu-central-1.amazonaws.com/cms-p-strapi

sudo docker push  794703684555.dkr.ecr.eu-central-1.amazonaws.com/cms-p-strapi:${BUILD}