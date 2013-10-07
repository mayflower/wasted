#!/bin/sh

apt-get update -qq
[ -x /usr/bin/git ] || apt-get install -y -q git
[ -x /usr/bin/gem ] || apt-get install -y -q rubygems
[ -x /usr/local/bin/r10k ] || gem install --no-rdoc --no-ri r10k
cd /vagrant && r10k -v info puppetfile install

