#!/bin/bash

tarout=$1
htmlout=$2
rpath=$3

cd output
tar czvf results.tgz png log
cd ../
mv output/results.tgz $tarout

# create the html file
echo "<style>img{border: 2px solid #112d50;margin:5px;border-radius: 25px;background: #112d50;}div{display:inline-block}span{display:block;margin-bottom:10px}</style>" > tmp.html
echo "<body style='font-size:10px;font-family:Verdana;text-align:center'>" >> tmp.html
for f in output/png/*;do
    echo "<div><img width=\"200px\" src=\"/download/$(echo $rpath | sed 's|/efs/job_working_directory/||g')/output/png/$(basename $f)\"/><span>$(basename $f .png | sed 's/,/ /g')</span></div>" >> tmp.html
done
echo "</body>" >> tmp.html
mv tmp.html $htmlout

