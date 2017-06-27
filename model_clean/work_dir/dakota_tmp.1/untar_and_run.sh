#!/bin/bash
#pwd
#ls -fl
tar xvf transferin.tar
chmod 777 -R *
#ls -fl
#echo $1
#echo $2
./utils/runOpenfoam.sh $1 $2 $3 $4 $5
#ls -fl
tail -n +2 example_outputs/openFOAM/metrics.csv | cut -d "," -f 2 > results.txt
tar cvzf ${3}.tar.gz example_outputs
echo "current work dir is $(pwd)"
