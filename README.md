# Alex's apt repository

Personal Debian packages, signed and served from GitHub Pages at https://alexheavens.github.io/apt. It is not a general-purpose mirror: it holds only packages built for personal use.

## Contents

- `pool/main/`: the `.deb` files that are published.
- `build.sh`: builds and signs the repository into a directory.
- `key.asc`: the public signing key.
- `.github/workflows/`: `publish.yml` builds, signs and deploys; `gitleaks.yml` scans history for secrets.
- `.githooks/`, `scripts/`, `pins/`: the secrets-scanning hook, its installer and the pinned gitleaks version.

## Setup

Prerequisites: `apt-utils`, `gpg`, `curl` and `git`. Building needs a gpg secret key.

```bash
scripts/install-gitleaks.sh        # the pre-commit hook needs gitleaks
git config core.hooksPath .githooks
```

## Install

```bash
sudo curl --fail --location --output /etc/apt/keyrings/alexheavens.asc https://alexheavens.github.io/apt/key.asc
echo "deb [signed-by=/etc/apt/keyrings/alexheavens.asc] https://alexheavens.github.io/apt stable main" | sudo tee /etc/apt/sources.list.d/alexheavens.list
sudo apt update
sudo apt install quackmod-linux
```

## Add a package

Commit the `.deb` into `pool/main/` on `main`. The `publish` workflow regenerates the index, signs it with the `GPG_PRIVATE_KEY` secret and deploys it. Packages are `Architecture: all`; for another architecture, add a `binary-<arch>` index in `build.sh`.

[quackmod-linux](https://github.com/AlexHeavens/quackmod-linux) pushes its releases here itself.

## Tests

There is no test suite. CI builds the repository on every push and pull request; run the same build locally:

```bash
./build.sh /tmp/apt-site
```

On a push to `main`, CI signs with the `GPG_PRIVATE_KEY` secret; elsewhere it uses a throwaway key.

## Signing key

`key.asc` is the public key. A backup of the secret key is in `~/.local/share/apt-repo-signing-key.asc` on the machine that created it. The key never expires; to rotate it, replace `key.asc` and the secret, and tell clients to fetch the new key.
