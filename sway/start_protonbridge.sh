#!/bin/sh

sleep 10
gpg --batch --no-tty --pinentry-mode loopback --passphrase-file /home/a0z1/.passphrase.txt -dq ~/.config/mutt/Passwds/private.gpg > /dev/null
protonmail-bridge --noninteractive
