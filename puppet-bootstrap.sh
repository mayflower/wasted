#!/bin/sh

cd /vagrant/vagrant

if [ ! -e modules/.r10k_stamp ] || [ modules/.r10k_stamp -ot Puppetfile ]; then
  apt-get update -qq
  [ -x /usr/bin/git ] || apt-get install -y -q git
  [ -x /usr/bin/gem ] || apt-get install -y -q rubygems
  [ -x /usr/local/bin/r10k ] || gem install --no-rdoc --no-ri r10k
  gem list | grep deep_merge > /dev/null || gem install --no-rdoc --no-ri deep_merge

  r10k -v info puppetfile install
  touch modules/.r10k_stamp
fi
