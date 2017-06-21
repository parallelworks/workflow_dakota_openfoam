type file;

# -- INPUT / OUTPUT DEFINITIONS
# Parallel.Works automates the creation of the Swift run command using your workflow definition
# e.g. swift openfoam.swift -input=motorBike.tgz -decompose=decomposeParDict -results=openfoam_runner -nproc='2'
# Swift needs to pick up the run arguments with the arg() command

file input 			<arg("input","sample_inputs/elbow.tgz")>;
file state 			<arg("state","sample_inputs/elbow.pvsm")>;
file JSONfile                   <"sample_inputs/elbowKPI.json">;

file sweep			<"sample_inputs/params.run">;

file utils[] 		<filesys_mapper;location="utils">;

file out    		<arg("results","results.tgz")>;
file html    		<arg("html","results.html")>;


# -- APP DEFINITIONS

app (file cases) expandSweep (file sweep,file[] utils) {
	python "utils/expandSweep.py" @sweep "cases.list";
}

app (file out,file outpng,file sout,file serr) runOpenfoam (file input,string c,file state,file utils[], file JSONfile)
{
    bash "utils/runOpenfoam.sh" @input @state c @out @outpng @JSONfile stdout=@sout stderr=@serr;
}

app (file out,file html) postSweep (file pngs[],file logs[],file utils[], string rpath) {
	bash "utils/postSweep.sh" @out @html rpath;
}


# -- WORKFLOW COMMANDS

file caseFile 	<"cases.list">;
caseFile = expandSweep(sweep,utils);
string[] cases = readData(caseFile);

tracef("\n%i Cases in Simulation\n\n",length(cases));

file outpngs[];
file outlogs[];
foreach c,i in cases {
	file outtar  		<strcat("output/tgz/",i,".tgz")>;
	file outpng  		<strcat("output/png/",c,".png")>;
    file sout  			<strcat("output/log/out/",i,".txt")>;
    file serr  			<strcat("output/log/err/",i,".txt")>;
	(outtar,outpng,sout,serr) = runOpenfoam(input,c,state,utils,JSONfile);
	outpngs[i] = outpng;
	outlogs[i] = sout;
}

#(out,html) = postSweep(outpngs,outlogs,utils,rpath);

