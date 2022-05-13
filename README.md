# Udacity AWS DevOps Engineer Capstone Project


## Project Overview

This capstone project showcases the use of several CI/CD tools and cloud services covered in the program Udacity - AWS Cloud DevOps Engineer.

### Introduction

This project "operationalize" a simple python/flask
demo app ["hello world"](./deploy_app/app.py), using [CircleCI](https://www.circleci.com) and
 a [Kubernetes](https://kubernetes.io/)(K8S) cluster deployed using minikube(https://minikube.sigs.k8s.io/)(Minikube).
 We use blue/green stragety to switch to the new production deployement.

Majority of the project's tasks are in the CircliCI configuration. All the application related files are in `deploy_app` folder and 
the files related to kubernetes deployement is in `ansible` folder.


### Project Tasks

Using a CI/CD approach, we build a [Docker](https://www.docker.com/resources/what-container) image and then run it in a two node [Kubernetes](https://kubernetes.io/) cluster.

The project includes the following main tasks:
### 1. Preparation & making the code ready for deployment
* Initialize the Python virtual environment:  `make setup`
* Install all necessary dependencies:  `make install`
* Test the project's code using linting:  `make lint`
* Above three tasks needs the following files to be created first and made available in the folder `deploy_app`:  
               * `Makefile`   
               * `Dockerfile`  
               * `requirements.txt`  
               * `app.py`  
### 2. Containarize the application  in Docker and upload to the dockerhub         
* Create Docker container for the [hello world](/deploy_app/app.py) application: [Dockerfile](deploy_app/Dockerfile)
* Publish the Docker Container to a public Docker Registry:
 [Docker Hub](https://hub.docker.com/repository/docker/pramation/capstoneproj) the containerized application
### 3. Install kubernetis cluser and deploy the docker containers in the kubernetes pods 
* Create AWS EC2 instance.
* Install & configure minikube,docker,kubectl
* Deploy the application in the kubernetes pods by pulling the docker images from the dockerhub
* initialize the kubernetes cluster app manually
### 4. Switch the application link to point to the new production
* create a new index.html file with the new application link.
* copy and replace the index.html file in the s3 location
### 5. Verify the new deployment
* use [New Production](https://<bucket name>.s3.amazonaws.com)

### CI/CD Tools and Cloud Services Used
  #### AWS tools and services
     * [Amazon AWS](https://aws.amazon.com/) - Cloud services  
     
     * [AWS CLI](https://aws.amazon.com/cli/) - Command-line tool for AWS  
     
     * [CloudFormation](https://aws.amazon.com/cloudformation/) - Infrastructure as Code  
     
     * EC2  
     
     * S3  
     
  #### CI/CD Tools
     * [Circle CI](https://www.circleci.com) - Cloud-based CI/CD platformservice
     * [Minikube](https://minikube.sigs.k8s.io) -  MiniKube, opensource Kubernetes Cluster
     * [Ansible](https://www.ansible.com/) . An opensource configuration and application deployment tool.
     * [kubectl](https://kubernetes.io/docs/reference/kubectl/) - a command-line tool to control Kubernetes clusters
     * [Docker](https://www.docker.com/) - Packges application and its dependinces in a self contained container.
     * [Docker Hub](https://hub.docker.com/repository/docker/pramation/capstoneproj) - Container images repository service

### CicleCI Variables

  To `build` and `publish` docker images, you need to set up the following environment
  variables in your CircleCI project with your DockerHub account's values:

* DOCKERHUB_USERNAME
* DOCKERHUB_PASSWORD
  
### Main Files

* [Makefile](./deploy_app/Makefile): the main file to execute all the project steps, i.e., the project's command center!
* [config.yml](.circleci/config.yml): Main Engine which brings all the components together
* [app.py](./deploy_app/app.py): the sample python/flask app file for all the application code.
* [Dockerfile](./hello_app/Dockerfile): the Docker image's specification file
* [build_server.yml](.circleci/build_server.yml): build EC2 cloudformation template file
* [deploy_app.py](./circleci/ansible/deploy_app.yml): builds Kubernetis environment using this playbook by Ansible.

The whole pipeline is initiated and executed by running the capstone-devops project in CircleCI.  The jobs and its dependencies of this pipeline is as follows:  
1.`linting`: This job is to verify for errors in the application setup in the Dockerfile  
* This job sets up the environment.  
* Installs the dependent libraries using `requirement.txt`. (cmd: make install)  
* Runs lint to verify for issues, uses hadolint. (cmd: make lint)  
* Files used `Makefile`, `Dockerfile`,`app.py` & `requirement.txt`  
* No other job dependency, this is the first job.  
2. `build_docker_image`: builds docker image and publishes to the dockerhub repository.Uses docker:17.05.0-ce-git as its CircleCI image.  
* Setup remote Docker Engine.  
* Build Docker image.Uses files in deploy_app folder. (cmd: docker build --tag=<tag> <path>/deploy_app)  
* Upload Docker image to the remode Docker repository. (cmd docker login <  > && docker image tag <> , docker push )  
* Run Docker Image to test and verify if the image is build correctly. (cmd: docker run)  
* Files used: `Makefile`, `Dockerfile`,`app.py` & `requirement.txt`  
* Depends on successful completion of `linting` job.  
3. `deploy-infrastructure`: Builds EC2 ubuntu server, requires 2 CPU, 8GB Memory, 20GB storage.  
* Uses AWS CloudFormation . (cmd: aws cloudformation deploy --template-file .circleci/build_server.yml)  
* files Used: .circleci/build_server.yml  
* Depends on successful completion of `build_docker_image` job.  
4. `deploy_app_in_kube`: Installs, configures and start Kubernetis Cluster Services.This also deploys Docker containers in Kubernetis.  
 * Gets the IP address of the EC2 instance created by the previos job and store it in `inventory.txt`.  
 * runs Ansible playbook to performs following steps.  
        * Install Minikube, Docker, Kubectl  
        * Create Docker deployments in the Kube Pods. (cmd: `kubectl create deployment ..`)  
        * Expose the Container port to the Host port. (cmd: `kubectl expose ...`)  
        * Files used: `deploy_app.yml`,`inventory.txt` , `mail.yml`  
  * Depends on successful completion of `deploy-infrastructure` job.  
 5. `switch_to_new_production`: This switches the production link from old deployment to the new one.  
 * Get the IP address of the EC2 machine where the application was deployed.  
 * Builds index.html file with the new application link.  
 * Copy the index.html file to the S3 bucket.  
 * Depends on successful completion of `deploy_app_in_kube` job.  
  
### Project Execution steps:  
   1. Run the pipeline in CircleCI.  
   2. Manually initialize the Kubernetis Application Cluster.(cmd: `kubectl port-forward`)  
### Test the Bule/Green deployment.  
   1. Test verify the new deployment by clicking on the link `https://<bucket name>.s3.amazonaws.com`  
   2. Very the new IP and the contents.  
    
 
