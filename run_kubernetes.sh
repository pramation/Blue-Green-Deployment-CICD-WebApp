#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
# dockerpath=<>
dockerpath="pramation/capstoneproj"

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run capstoneprojmicroserviceapi\
      --image=$dockerpath\
      --port=8080 --labels app=capstoneprojmicroserviceapi


sleep 30
# Step 3:
# List kubernetes pods
kubectl get pods

sleep 30

# Step 4:
# Forward the container port to a host
kubectl port-forward capstoneprojmicroserviceapi 8080:8080
