#!/bin/sh
#
# connects to wifi
# USAGE: wifi SSID PASS

case "$1" in
   -con | -c)
      CARD="$(ip link | grep -o 'w.*:' | tr -d ':')"
      iwctl station "$CARD" get-networks
      iwctl --passphrase "${PASS:-$2}" station "$CARD" connect "${SSID:-$1}"
      ;;
   -dis | -d) iwctl station "$CARD" disconnect;

esac
