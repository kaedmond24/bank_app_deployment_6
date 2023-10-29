#!/bin/bash

# Install Required Packages
apt-get install software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get install -y python3.7, python3.7-venv, python3.7-dev
apt-get install -y build-essential, libmysqlclient-dev

# Set Enviroment Variables
DBuser=admin
DBpassword=deployment5
export DBuser
export DBpassword

# Create Virtual Env and Run Application
python3.7 -m venv test
source test/bin/activate
git clone https://github.com/kura-labs-org/c4_deployment-5.git
cd c4_deployment-5

# Install Dependencies
pip install -r requirements.txt
pip install gunicorn
pip install mysqlclient

# Run Application
# python database.py
# sleep 1
# python load_data.py
# sleep 1 
python -m gunicorn app:app -b 0.0.0.0 -D
