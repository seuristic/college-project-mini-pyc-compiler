added a bash script which both compiles and runs on the input given. After compilation, it cleans all the temp files created <br>

usage :   `./python.sh [-option] <inputfile>.py` <br>

valid options are -s,-S,-I0,-i0,-I1,-i1,-SI0,-si0,-i0s,-i0S,-I1S,-I1s,-sI1,-SI1<br>

-S series option means conversion to assembly code.<br>
-I0 series means unoptimized intermediate code<br>
-I1 series means optimized intermediate code<br>

can combine options. eg : -SI0 or -I0S to convert unoptimized intermediate code to  assembly code. 

no option means optimized code is converted to assembly and printed on stdout.<br>

to just compile, type `make`. the executable is called python.out <br>
to clean the files, type `make clean`<br>
