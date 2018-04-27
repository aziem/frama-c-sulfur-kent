#!/bin/bash

make clean 

# Make sure octD is being used
sed -i '735s/^.*/PLUGIN_REQUIRES:= apron.octD apron.boxMPQ apron.polkaMPQ apron.apron gmp/' Makefile

#./configure && make -j 2 && ./reinstall.sh
./reinstall.sh


