#! /bin/bash

infile=$1
datfile=$2
htmlfile=$3

sudo chmod 777 * -R

# setup steps for dakota to work
#cp utils/* ./
#rm -fr templatedir/*
cp swift.conf templatedir
cp dakota/* templatedir
cp dakota/utils/* templatedir
#prepare openfoam
#cp -ar case sample_inputs utils templatedir
#./utils/prepInputs.sh
#rm templatedir/transferin.tar
#tar cvf templatedir/transferin.tar case sample_inputs utils
#tar cvf templatedir/transferin.tar utils

INSTALL_DIR=/dakota
export PATH=$PATH:$INSTALL_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INSTALL_DIR/lib:$INSTALL_DIR/bin
export PYTHONPATH=$PYTHONPATH:$PWD/utils

echo "Running DOE Analysis"
dakota -input $infile
ec=$?

if [ -f "out_dace.dat" ] && [ "$ec" == "0" ];then
    cp out_dace.dat $datfile
else
    echo "error with dakota run"
    exit 1
fi

# convert the samples file 
genResponse() {
awk 'BEGIN {FS=" "};NR > 1 {print $2,$3,'\$$2'}' $1 > out_dace.spd
cat > out_dace.spk << END
 Load[name = test, file = 'out_dace.spd', n_predictors = 2,n_responses = 1]
 CreateAxes[name = ax_2d, bounds = '0 10 | 0 20 ']
 CreateSample[name = test_data, axes = ax_2d, grid_points = (100,100),labels = (radius,height)]
 CreateSurface[name = kriging_branin_local, data = test, type = kriging, lower_bounds = (0, 0), upper_bounds = (10, 20), optimization_method = local ]
 Evaluate[surface = kriging_branin_local, data = test_data, label = kriging]
 Save[data = test_data, file = '$3']
END
surfpack out_dace.spk
rm out_dace.spk out_dace.spd
}

echo "Generating the Response Surfaces"
genResponse out_dace.dat 4 out_surrogate_area.dat
genResponse out_dace.dat 5 out_surrogate_volume.dat

echo "Plotting Prediction Results"
python templatedir/graph.py $htmlfile

#delete dakota files
./templatedir/dakota_cleanup
