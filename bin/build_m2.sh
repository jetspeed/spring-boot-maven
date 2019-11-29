#!/bin/bash
docker build -f Dockerfile.t -t spring-boot-maven:m2 . --target=m2
