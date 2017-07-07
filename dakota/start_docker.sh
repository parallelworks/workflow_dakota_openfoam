docker run -i --rm -v $PWD:/scratch -w /scratch parallelworks/dakota_openfoam /bin/bash dakota/runDakota.sh dakota/dakota_case.in results/out.dat results/out.html
