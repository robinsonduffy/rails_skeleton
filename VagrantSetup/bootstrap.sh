#!/bin/sh -e
apt-get update
apt-get -y install build-essential patch
apt-get -y install ruby-dev zlib1g-dev liblzma-dev
apt-get -y install ruby-dev libxml2-dev libxslt-dev
apt-get -y install libpq-dev