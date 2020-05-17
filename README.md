added a bash script which both compiles and runs on the input given. After compilation, it cleans all the temp files created

usage : ./python.sh [-option] <inputfile>.py

valid options are -s,-S,-I0,-i0,-I1,-i1,-SI0,-si0,-i0s,-i0S,-I1S,-I1s,-sI1,-SI1

-S series option means conversion to assembly code.
-I0 series means unoptimized intermediate code
-I1 series means optimized intermediate code

can combine options. eg : -SI0 or -I0S to convert unoptimized intermediate code to assembly code.

no option means optimized code is converted to assembly and printed on stdout.

to just compile, type make. the executable is called python.out
to clean the files, type make clean
