#!/usr/bin/env bash
# Builds the signed apt repository for the .deb files in pool/main into the directory given as $1.
# Signs with the default secret key of the running gpg.
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
site="$(realpath --canonicalize-missing "${1:?usage: build.sh OUTPUT_DIRECTORY}")"

rm -rf "$site"
mkdir -p "$site/pool/main" "$site/dists/stable/main/binary-all"
find "$repository_root/pool/main" -name '*.deb' -exec cp {} "$site/pool/main/" \;
cp "$repository_root/key.asc" "$site/key.asc"

cd "$site"
apt-ftparchive packages pool/main > dists/stable/main/binary-all/Packages
gzip --keep dists/stable/main/binary-all/Packages
apt-ftparchive \
  --option APT::FTPArchive::Release::Origin=AlexHeavens \
  --option APT::FTPArchive::Release::Suite=stable \
  --option APT::FTPArchive::Release::Codename=stable \
  --option APT::FTPArchive::Release::Architectures=all \
  --option APT::FTPArchive::Release::Components=main \
  release dists/stable > dists/stable/Release.unsigned
mv dists/stable/Release.unsigned dists/stable/Release
gpg --batch --yes --armor --detach-sign --output dists/stable/Release.gpg dists/stable/Release
gpg --batch --yes --clearsign --output dists/stable/InRelease dists/stable/Release
