*Claude Code authored*

# Alex's apt repository

Personal Debian packages, signed and served from GitHub Pages at https://alexheavens.github.io/apt.

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

## Signing key

`key.asc` is the public key. A backup of the secret key is in `~/.local/share/apt-repo-signing-key.asc` on the machine that created it. The key never expires; to rotate it, replace `key.asc` and the secret, and tell clients to fetch the new key.
