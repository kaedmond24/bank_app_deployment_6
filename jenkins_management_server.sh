#!/bin/bash

# Install addtional packages
apt-get update
apt-get install software-properties-common -y
add-apt-repository -y ppa:deadsnakes/ppa 
apt-get install python3.7 -y
apt-get install python3.7-venv -y

# Install Jenkins dependencies 
apt-get install fontconfig -y
apt-get install openjdk-11-jre -y

# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins apt repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
apt-get update
apt-get install -y jenkins
