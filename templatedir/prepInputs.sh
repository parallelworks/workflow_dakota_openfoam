#!/bin/bash

tar -czf templatedir/elbow.tgz openfoam/case
#tar cvf templatedir/transferin.tar openfoam/utils
cp -ar openfoam/utils/* templatedir
