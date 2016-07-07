#!/bin/bash

set -ex

if [[  -f "/home/git/repositories/gitolite.rc" ]]; then
  echo 'import rc file'
  su git -c "cp /home/git/repositories/gitolite.rc /home/git/.gitolite.rc"
else
  echo 'export rc file'
  su git -c "cp /home/git/.gitolite.rc /home/git/repositories/gitolite.rc"
fi

if [[ -d "/home/git/keys" ]]; then
  echo "Using admin public key supplied at [/home/hit/keys/admin.pub].\n"
  su git -c "/home/git/bin/gitolite setup -pk=/home/git/keys/admin.pub"
else
  su git -c "/home/git/bin/gitolite setup"
  echo "The built-in private key for admin:\n"
  cat /admin
fi

exec /usr/sbin/sshd -D

