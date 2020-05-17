#!/bin/bash
if [[ $# -eq 0 ]]; then
    echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py"
    exit 2
fi
make > /dev/null
if [[ $# -eq 2 ]]; then
    if [[ $1 == "-S" ]] || [[ $1 == "-s" ]] || [[ $1 == "-si1" ]] || [[ $1 == "-i1s" ]] || [[ $1 == "-Si1" ]] || [[ $1 == "-i1S" ]]; then 
        if test -f "$2"; then
            fbname=$(basename "$2" .py).S
            cat $2 | ./python.out | python opt1.py | python compile.py > $fbname
        else
            echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py"
            make clean > /dev/null
            exit 2
        fi
    elif [[ $1 == "-I1" ]] || [[ $1 == "-i1" ]]; then 
        if test -f "$2"; then
            fbname=$(basename "$2" .py).S
            cat $2 | ./python.out | python opt1.py > $fbname
        else
            echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py"
            make clean > /dev/null
            exit 2
        fi
    elif [[ $1 == "-I0" ]] || [[ $1 == "-i0" ]]; then 
        if test -f "$2"; then
            fbname=$(basename "$2" .py).S
            cat $2 | ./python.out > $fbname
        else
            echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py"
            make clean > /dev/null
            exit 2
        fi
    elif [[ $1 == "-SI0" ]] || [[ $1 == "-si0" ]] || [[ $1 == "-i0s" ]] || [[ $1 == "-i0S" ]]; then 
        if test -f "$2"; then
            fbname=$(basename "$2" .py).S
            cat $2 | ./python.out | python compile.py > $fbname
        else
            echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py"
            make clean > /dev/null
            exit 2
        fi
    else
        echo -e "python: \033[1;31m error: \033[0m wrong option\nusage: ./python.sh [-option] <inputfile>.py"
        make clean > /dev/null
        exit 2 
    fi
else
    if test -f "$1"; then
        cat $1 | ./python.out | python opt1.py | python compile.py
    else
        echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py"
        make clean > /dev/null
        exit 2
    fi
fi
make clean > /dev/null
