#!/usr/bin/env bash

docker build --tag jaguar_pg .
docker run -it -p 5432:5432 jaguar_pg