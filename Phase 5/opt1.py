from sys import stdin
import re

lines=[]

is_int=lambda x: bool(re.match("[0-9]+", x))

is_float=lambda x: bool(re.match("[0-9]+\.[0-9]+", x))

is_variable= lambda x: bool(re.match("[a-zA-Z_][a-zA-Z0-9_]*", x))

is_str= lambda x: bool(re.match("(\".*\")|(\'.*\')", x))

is_bool = lambda x: x=="True" or x=="False"

is_const = lambda x: is_int(x) or is_bool(x) or is_float(x) or is_str(x)

operators={'+','-','*','/','//','%','in','and','or','|','&','**','^','not','>>','<<'}

for line in stdin:
    lines.append(line.strip().split("\t"))

print("before optimization :")
print(lines)

def constant_folding():
    changed=0
    for i in range(len(lines)):
        if lines[i][0] in operators:
            if is_const(lines[i][1]) and is_const(lines[i][2]):
                ans=eval(lines[i][1]+lines[i][0]+lines[i][2])
                changed=1
                lines[i][0]="="
                lines[i][1]=str(ans)
                lines[i][2]=" "
    
    return changed

"""print("after constant folding:")
constant_folding()
print(lines)"""

def constant_propagation():
    d={}
    changed=0
    for i in range(len(lines)):
        if lines[i][0]=='=' and is_const(lines[i][1]) :
            d[lines[i][-1]]=lines[i][1]
            continue

        if is_variable(lines[i][1]):
            if lines[i][1] in d:
                changed=1
                lines[i][1]=d[lines[i][1]]

        if is_variable(lines[i][2]):
            if lines[i][2] in d:
                changed=1
                lines[i][2]=d[lines[i][2]]
    
    return changed
        

"""print("after constant propagation:")
constant_propagation()
print(lines)
"""

def copy_propagation():
    d={}
    changed=0
    for i in range(len(lines)):
        if lines[i][0]=='=' and is_variable(lines[i][1]) and lines[i][2]==' ' :
            d[lines[i][-1]]=lines[i][1]
            continue

        if is_variable(lines[i][1]):
            if lines[i][1] in d:
                changed=1
                lines[i][1]=d[lines[i][1]]

        if is_variable(lines[i][2]):
            if lines[i][2] in d:
                changed=1
                lines[i][2]=d[lines[i][2]]
    
    return changed
        
"""
print("after copy propagation:")
copy_propagation()
print(lines)
"""

def dead_code_elimination():
    #must complete it
    return 1

changed=1
while changed:
    c1=constant_folding()
    c2=constant_propagation()
    c3=copy_propagation()
    changed=c1 or c2 or c3
    #break

dead_code_elimination()

print("after optimization")
print(lines)