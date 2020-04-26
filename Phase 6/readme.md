added a bash script which both compiles and runs on the input given. After compilation, it cleans all the temp files created <br>

usage :   `./python.sh [-option] <inputfile>.py [-option]` <br>

valid options are -s -S . they direct the script to save the assembly code to filename.S file. without this option , the assembly code is printed on stdout<br>

to just compile, type `make`. the executable is called python.out <br>
to clean the files, type `make clean`<br>
