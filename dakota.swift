# GENERAL DAKOTA CASE RUNNER
type file;

# -- INPUT / OUTPUT DEFINITIONS
# Parallel.Works automates the creation of the Swift run command using your workflow definition
# Swift needs to pick up the run arguments with the arg() command

# inputs
#file casein         <arg("case","sample_inputs/dakota_case.in")>;

# outputs
file outdat         <arg("dat","results/out.dat")>;
file outhtml        <arg("html","results/out.html")>;

# these are external files needed by the Swift workflow
#file execute        <"runDakota.sh">;
file swiftconf      <"swift.conf">;
#file openfoamcase   <"
#file[] utils        <FilesysMapper;location="utils">;

file[] openfoam <Ext;exec="mapper.sh",root="openfoam">; 
file[] dakota <Ext;exec="mapper.sh",root="dakota">; 
file[] templatedir <Ext;exec="mapper.sh",root="templatedir">; 
file[] templatedir_ofa <Ext;exec="mapper_ofa.sh">;
 
# -- APP DEFINITIONS
# this app generates the list of fitness values
app (file pout,file perr,file outd,file outh) runDAKOTA (file[] templatedir, file[] dakota, file swiftconf) {
    bash "dakota/start_docker.sh" stdout=@pout stderr=@perr;
}


app (file pout, file perr, file[] templatedir ) prepInputs (file[] openfoam) {
    bash "openfoam/utils/prepInputs.sh" stdout=@pout stderr=@perr;
}


#app (file pout, file perr) tree (file[] openfoam)
#{
#    tree stdout=@pout stderr=@perr;
#}

# -- WORKFLOW COMMANDS
# this commpand runs app specified above
file pout   <"logs/prep.out">;
file perr   <"logs/prep.err">;
file dout   <"logs/dakota.out">;
file derr   <"logs/dakota.err">;
(pout,perr,templatedir_ofa) = prepInputs(openfoam);
(dout,derr,outdat,outhtml) = runDAKOTA(templatedir_ofa,dakota,swiftconf);

#(sout,serr)=tree(openfoam);
