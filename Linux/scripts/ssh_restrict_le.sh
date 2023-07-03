#!/bin/bash -feu
#

set -- $SSH_ORIGINAL_COMMAND

cmd="$1"; shift
case "$cmd" in
    ls|scp|systemctl|sudo) exec "$cmd" "$@" ;;
        *) echo "ERROR: request not permitted" ;;
esac

