#! /bin/bash

export PATH=$PATH:/core/xinchen/swift-k/dist/swift-svn/bin

# tar up the case because of recursive filemapper limitation
#rm sample_inputs/elbow.tgz
#./utils/prepInputs.sh

# run swift workflow
#swift openfoam.swift


# ./utils/runOpenfoam.sh standalone
# ./utils/runOpenfoam.sh sample_inputs/elbow.tgz sample_inputs/elbow.pvsm inlet5_X,5,inlet6_Y,5 out.tgz out.png


# ./runDakota.sh sample_inputs/dakota_case.in results/out.dat results/out.html 
rm -fr work_dir
rm -fr templatedir/*

./openfoam/utils/prepInputs.sh

docker run -i --rm -v $PWD:/scratch -w /scratch parallelworks/dakota_openfoam /bin/bash dakota/runDakota.sh dakota/dakota_case.in results/out.dat results/out.html 
