# GENERAL DAKOTA CASE RUNNER
type file;

# -- INPUT / OUTPUT DEFINITIONS
# Parallel.Works automates the creation of the Swift run command using your workflow definition
# Swift needs to pick up the run arguments with the arg() command

# inputs
file casein         <arg("case","sample_inputs/dakota_case.in")>;

# outputs
file outdat         <arg("dat","results/out.dat")>;
file outhtml        <arg("html","results/out.html")>;

# these are external files needed by the Swift workflow
file execute        <"runDakota.sh">;
file swiftconf      <"swift.conf">;
file[] templatedir  <FilesysMapper;location="templatedir">;
file[] utils        <FilesysMapper;location="utils">;

# -- APP DEFINITIONS
# this app generates the list of fitness values
app (file dat,file html,file pout,file perr) runDAKOTA (file execute,file casein,file[] td,file[] utils,file swiftconf) {
    bash @execute @casein @dat @html stdout=@pout stderr=@perr;
}

# -- WORKFLOW COMMANDS
# this commpand runs app specified above
file sout   <"logs/dakota.out">;
file serr   <"logs/dakota.err">;
(outdat,outhtml,sout,serr) = runDAKOTA(execute,casein,templatedir,utils,swiftconf);
