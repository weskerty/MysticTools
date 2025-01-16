#!/bin/bash
pkg update -y && pkg upgrade -y
cd $HOME/levanter
pm2 start . --name levanter --attach --time
#npm start .
