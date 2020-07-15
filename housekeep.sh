#!/usr/bin/env sh

doas -- pacman -Scc --noconfirm
doas -- pacman -Rns "$(pacman -Qtdq)" --noconfirm
find ~ -xtype l -delete -o -type d -empty -delete
doas -- rm -fr ~/.local/share/cache/* /var/log/journal/* ~/.local/share/Trash/*

# find ~ -xtype l -delete
# find ~ -type d -empty -delete
# mkdir -p ~/.local/share/cache ~/.local/share/Trash
# doas -- mkdir -p /var/log/journal
