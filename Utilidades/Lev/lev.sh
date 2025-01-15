#!/bin/bash
cd $HOME/levanter
pm2 start . --name levanter --attach --time
#npm start .
