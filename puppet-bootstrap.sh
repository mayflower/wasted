#!/bin/sh

cd /vagrant/vagrant

apt-get update -qq
[ -x /usr/bin/gem ] || apt-get install -y -q rubygems
gem list | grep deep_merge > /dev/null || gem install --no-rdoc --no-ri deep_merge

if [ ! -e modules/.r10k_stamp ] || [ modules/.r10k_stamp -ot Puppetfile ]; then
  [ -x /usr/bin/git ] || apt-get install -y -q git
  [ -x /usr/local/bin/r10k ] || gem install --no-rdoc --no-ri r10k

  r10k -v info puppetfile install
  touch modules/.r10k_stamp
fi
