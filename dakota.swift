# GENERAL DAKOTA CASE RUNNER
type file;

# -- INPUT / OUTPUT DEFINITIONS
# Parallel.Works automates the creation of the Swift run command using your workflow definition
# Swift needs to pick up the run arguments with the arg() command

# inputs
#file casein         <arg("case","dakota/dakota_case.in")>;

string inlet5_X_min = arg("inlet5_X_min");
string inlet5_X_max = arg("inlet5_X_max");
string inlet6_Y_min = arg("inlet6_Y_min");
string inlet6_Y_max = arg("inlet6_Y_max");
string num_cases = arg("num_cases");
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
app (file pout,file perr,file outd,file outh) runDAKOTA (file[] templatedir, file[] dakota, file swiftconf, string i5xmin, string i5xmax, string i6ymin, string i6ymax, string ncase) {
    bash "dakota/update_params.sh" i5xmin i5xmax i6ymin i6ymax ncase "dakota/dakota_case.in" "dakota/runDakota.sh"; # stdout=@pout stderr=@perr;
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
(dout,derr,outdat,outhtml) = runDAKOTA(templatedir_ofa,dakota,swiftconf, inlet5_X_min, inlet5_X_max, inlet6_Y_min, inlet6_Y_max, num_cases);

#(sout,serr)=tree(openfoam);
