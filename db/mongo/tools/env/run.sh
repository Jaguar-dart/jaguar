#!/usr/bin/env bash

docker build --tag jaguar_mongo .
docker run -it -p 27018:27018 jaguar_mongo