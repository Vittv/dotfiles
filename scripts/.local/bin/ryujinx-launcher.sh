#!/usr/bin/env bash
~/build/ryujinx-1.3.3-x64.AppImage
sleep 2
rsync -a ~/.config/Ryujinx/bis/user/save/ /mnt/drive/backup/games/01-saves/ryujinx-saves/
echo "Saves backed up!"
