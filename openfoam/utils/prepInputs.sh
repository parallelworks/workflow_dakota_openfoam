#!/bin/bash

tar -czf templatedir/elbow.tgz openfoam/case
#tar cvf templatedir/transferin.tar openfoam/utils
cp openfoam/utils/* templatedir
cp openfoam/* templatedir
