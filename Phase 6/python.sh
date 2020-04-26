#!/bin/bash
if [[ $# -eq 0 ]]; then
    echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py [-option]"
    exit 2
fi
make > /dev/null
if [[ $# -eq 2 ]]; then
    if [[ $1 == "-S" ]] || [[ $1 == "-s" ]]; then 
        if test -f "$2"; then
            fbname=$(basename "$2" .py).S
            cat $2 | ./python.out | python opt1.py | python compile.py > $fbname
        else
            echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py [-option]"
            make clean > /dev/null
            exit 2
        fi
    else
        if [[ $1 != "-S" ]] || [[ $1 != "-s" ]]; then
                echo -e "python: \033[1;31m error: \033[0m wrong option\nusage: ./python.sh [-option] <inputfile>.py [-option]"
                make clean > /dev/null
                exit 2
        else
            if test -f "$1"; then
                fbname=$(basename "$1" .py).S
                cat $1 | ./python.out | python opt1.py | python compile.py > $fbname
            else
                echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py [-option]"
                make clean > /dev/null
                exit 2
            fi
        fi  
    fi
else
    if test -f "$1"; then
        cat $1 | ./python.out | python opt1.py | python compile.py
    else
        echo -e "python: \033[1;31m error: \033[0m no input file\nusage: ./python.sh [-option] <inputfile>.py [-option]"
        make clean > /dev/null
        exit 2
    fi
fi
make clean > /dev/null