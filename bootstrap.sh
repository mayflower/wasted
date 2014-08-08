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

main() {
    echo "[bootstrap] link Vagrantfile to project root" && \
        ln -si vagrant/Vagrantfile "$DIR/../Vagrantfile"
    echo "[bootstrap] link .vagrant to project root" && \
        ln -si vagrant/.vagrant "$DIR/../.vagrant" &&
        (mkdir vagrant/.vagrant 2>/dev/null || true)
    echo "[bootstrap] create devstack.yaml in project root" && \
        cp -i "$DIR/devstack.yaml.dist" "$DIR/../devstack.yaml"
}

main
