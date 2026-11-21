# apt

- Add a package: commit the `.deb` into `pool/main/` on `main`. The `publish` workflow indexes, signs and deploys it.
- Run: `./build.sh /tmp/apt-site`. It needs a gpg secret key; for a local check, create a throwaway one with `gpg --batch --passphrase '' --quick-generate-key ci@example.invalid`.
- Test: no test suite; the build is the test.
- Docs: `README.md` for install, setup and the signing key.
- Before each commit, check the staged diff for secrets. The pre-commit hook needs `git config core.hooksPath .githooks`.
