#! /bin/bash
# requires: xvfb (apt-get install xvfb) and pvpython (apt-get install paraview)
# usage: ./snapshot.sh <Paraview State File>.pvsm

export PATH=$PATH:/opt/paraviewopenfoam50/bin

cat > snapshot.py <<END
from paraview.simple import *
import sys
paraview.simple._DisableFirstRenderCameraReset()
LoadState(sys.argv[1])
view = GetActiveView()
view.ViewSize = [ 400, 400 ]
WriteImage("out.png")
END

# run the python script in a frame buffer
xvfb-run -a --server-args="-screen 0 1024x768x24" pvpython snapshot.py $1
