#!/bin/bash
docker build -f Dockerfile.t -t spring-boot-maven:base . --target=build
