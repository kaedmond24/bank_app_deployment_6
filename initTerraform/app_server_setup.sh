#!/bin/bash

# Install Required Packages
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get install -y python3.7
apt-get install -y python3.7-venv
apt-get install -y build-essential
apt-get install -y libmysqlclient-dev
apt-get install -y python3.7-dev

# Create Virtual Env and Run Application
python3.7 -m venv test
source test/bin/activate
git clone https://github.com/kura-labs-org/c4_deployment-5.git
cd c4_deployment-5

# Install Dependencies
pip install -r requirements.txt
pip install gunicorn
pip install mysqlclient

# Start Application
python -m gunicorn app:app -b 0.0.0.0 -D
