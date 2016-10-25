#!/usr/bin/env sh

set -e

# First Hipsters, then Bill Gates, then the ones with a real good OS
case "$OSTYPE" in
    *darwin*|*msys*)
        DIR="$(cd "$(dirname $0)" && pwd -P)"
        ;;
    *)
        DIR=$(readlink -m $(dirname $0))
        ;;
esac

# Prevent IDEs from crying
readonly DIR


main() {
    echo "[bootstrap] link Vagrantfile to project root" && \
        ln -si vagrant/Vagrantfile "$DIR/../Vagrantfile"
    echo "[bootstrap] link .vagrant to project root" && \
        ln -si vagrant/.vagrant "$DIR/../.vagrant" &&
        (mkdir vagrant/.vagrant 2>/dev/null || true)
    echo "[bootstrap] create configs and basic hierarchy" && \
        cp -Ri "$DIR/vagrant-cfg.dist/" "$DIR/../vagrant-cfg"
}

main
