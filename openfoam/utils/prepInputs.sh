#!/bin/bash

mkdir templatedir

tar -czf templatedir/elbow.tgz openfoam/case
#tar cvf templatedir/transferin.tar openfoam/utils
#using rsync instead of cp because cp exit with 1 when folders are omitted
rsync openfoam/utils/* templatedir
rsync openfoam/* templatedir
