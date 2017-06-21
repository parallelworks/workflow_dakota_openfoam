. /opt/openfoam4/etc/bashrc
. /opt/openfoam4/bin/tools/RunFunctions
#!/bin/sh
#cd ${0%/*} || exit 1    # Run from this directory

# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions

# Get application directory
application=`getApplication`

runApplication fluentMeshToFoam elbow.msh
runApplication "$application"
#runApplication foamMeshToFluent
#runApplication foamDataToFluent

#------------------------------------------------------------------------------
