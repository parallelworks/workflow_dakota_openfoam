sed -i "s/INLET5_X_MIN/$1/" $6
sed -i "s/INLET5_X_MAX/$2/" $6
sed -i "s/INLET6_Y_MIN/$3/" $6
sed -i "s/INLET6_Y_MAX/$4/" $6
sed -i "s/NUMBER_OF_EXPS/$5/" $6


sed -i "s/INLET5_X_MIN/$1/g" $7
sed -i "s/INLET5_X_MAX/$2/g" $7
sed -i "s/INLET6_Y_MIN/$3/g" $7
sed -i "s/INLET6_Y_MAX/$4/g" $7
