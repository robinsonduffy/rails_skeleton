#!/bin/sh -e

cd /vagrant
bundle
rake db:migrate
rake db:seed
rails server -d