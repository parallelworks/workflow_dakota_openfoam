#! /bin/bash

echo $@

in=$1
state_file=$2
params=$3
out=$4
outpng=$5

# untar the input directory
rm -rf input
mkdir input
tar -xzvf $in -C input --strip-components 2
sudo chmod 777 * -R
#sudo chmod 777 ../../../ -R

# replace the params in the case files
IFS=',' read -a paramcut <<< "$params"
echo Parameter Length: "${#paramcut[@]}"

for (( c=0; c<=${#paramcut[@]}; c=c+2 ))
do
    pname=${paramcut[$c]}
	pval=${paramcut[$c+1]}
	#echo $pname
	#echo $pval
	find input -type f -exec sed -i "s/@@$pname@@/$pval/g" {} \;
done

OPENFOAM_PATH=/opt/openfoam4
echo . $OPENFOAM_PATH/etc/bashrc > input/run.sh
echo . $OPENFOAM_PATH/bin/tools/RunFunctions >> input/run.sh
cat input/Allrun >> input/run.sh

echo ""
echo "------ START RUNFILE ------"
cat input/run.sh
echo "------ END RUNFILE ------"
echo ""

# execute openfoam parallel run
cd input

docker_run="docker run -i --rm -v $PWD:/scratch -w /scratch parallelworks/openfoam4 /bin/bash"

# openfoam commands
$docker_run run.sh
#/bin/bash run.sh
ec=$?

#rm processor* -R

touch open.foam

# generate the snapshot
#sed -i '/.*open.foam.*/c\<Element index="0" value="'$PWD'/open.foam"\/>' ../$state_file
#../utils/snapshot.sh ../$state_file

cd ../

mkdir example_outputs
mkdir example_outputs/$params

echo "./extract.sh /opt/paraview530/bin extract.py input/system/controlDict input/elbowKPI.json example_outputs/$params/ example_outputs/$params/metrics.csv plot.py" > run_ME.sh

echo "ls -fl" >>run_ME.sh

cat run_ME.sh

sudo chmod 777 -R *

docker_run_ME="docker run -i --rm -v $PWD:/scratch -w /scratch xinchenguo/paraview530 /bin/bash"

$docker_run_ME run_ME.sh

tar cvzf ${params}.tar.gz example_outputs

rm $out >/dev/null 2>&1
#cp _stdout_1.txt input/log_openfoam.out >/dev/null 2>&1
#cp _stderr_1.txt input/log_openfoam.err >/dev/null 2>&1

tar -czf tmp.tgz input

mv tmp.tgz $out

#echo "image" > $outpng
#cp input/out.png $outpng

exit $ec

