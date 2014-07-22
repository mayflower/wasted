#!/bin/bash

set -e

# First Hipsters, then Bill Gates
if [[ "$OSTYPE" == *darwin* || "$OSTYPE" == *msys* ]]
then
  DIR="$(cd "$(dirname $0)" && pwd -P)"
else
  DIR=$(readlink -m $(dirname $0))
fi

# Prevent IDEs from crying
readonly DIR

hierarchy () {
    read -p "Do you want to use the hierarchy? " yn
    case $yn in
        [Yy]* )
            echo "[bootstrap] create configs and basic hierarchy" && \
                cp -Ri "$DIR/vagrant-cfg.dist" "$DIR/../vagrant-cfg";;
        * ) ;;
    esac
}

main() {
    echo "[bootstrap] link Vagrantfile to project root" && \
        ln -si vagrant/Vagrantfile "$DIR/../Vagrantfile"
    echo "[bootstrap] link .vagrant to project root" && \
        ln -si vagrant/.vagrant "$DIR/../.vagrant" &&
        (mkdir vagrant/.vagrant 2>/dev/null || true)
    read -p "Do you want to use the simple devstack.yaml (can be changed to big hierarchy later)? " yn
    case $yn in
        [Yy]* )
            echo "[bootstrap] create devstack.yaml in project root" && \
                cp -i "$DIR/devstack.yaml.dist" "$DIR/../devstack.yaml";;
        [Nn]* )
            hierarchy;;
        * ) ;;
    esac
}

main
