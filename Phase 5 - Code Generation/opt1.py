from sys import stdin
import re

lines=[]

is_int=lambda x: bool(re.match("[0-9]+", x))

is_float=lambda x: bool(re.match("[0-9]+\.[0-9]+", x))

is_variable= lambda x: bool(re.match("[a-zA-Z_][a-zA-Z0-9_]*", x))

is_str= lambda x: bool(re.match("(\".*\")|(\'.*\')", x))

is_bool = lambda x: x=="True" or x=="False"

is_const = lambda x: is_int(x) or is_bool(x) or is_float(x) or is_str(x)

operators={'+','-','*','/','//','%','in','and','or','|','&','**','^','not','>>','<<',"==","!=",">","<",">=","<="}

for line in stdin:
    temp=line.strip().split("\t")
    if temp!=['']:
        lines.append(temp)


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
        if lines[i][0]=='if' or lines[i][0]=='ifFalse':
            d={}
            continue
        if is_variable(lines[i][1]):
            if lines[i][1] in d:
                changed=1
                lines[i][1]=d[lines[i][1]]

        if is_variable(lines[i][2]):
            if lines[i][2] in d:
                changed=1
                lines[i][2]=d[lines[i][2]]

        if lines[i][0]=='Label':
            d={}

    
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
        
        if lines[i][0]=='if' or lines[i][0]=='ifFalse':
            d={}
            continue

        if is_variable(lines[i][1]):
            if lines[i][1] in d:
                changed=1
                lines[i][1]=d[lines[i][1]]

        if is_variable(lines[i][2]):
            if lines[i][2] in d:
                changed=1
                lines[i][2]=d[lines[i][2]]

        if lines[i][0]=='Label':
            d={}
    
    return changed
        
"""
print("after copy propagation:")
copy_propagation()
print(lines)
"""

def dead_code_elimination():
    flag=None
    i=0
    while i<len(lines):
        #print(i,flag)
        #print(lines)

        if lines[i][3] == flag:
            del lines[i]
            flag=None

        if((lines[i][0] == 'if' and lines[i][1]=='False') or (lines[i][0] == 'ifFalse' and lines[i][1]=='True')):
            while lines[i][0] != 'Label':
                del lines[i]
            del lines[i]

        if((lines[i][0] == 'if' and lines[i][1]=='True') or (lines[i][0] == 'ifFalse' and lines[i][1]=='False')):
            flag=lines[i][3]
            del lines[i]
            
        i=i+1

    for i in range(len(lines)):
        for j in range(i+1,len(lines)):
            if j>=len(lines):
                break
            #print(i,j)
            #print(lines[i],lines[j])
            #print(flag,delete)
            
            if(lines[j][0] == 'Label' and lines[j][3] == flag):
                flag=None
            if flag!=None:
                continue
            if(lines[j][0] == 'if' or lines[j][0] == 'ifFalse'):
                flag=lines[j][3]
            if(lines[i][3] == lines[j][1]):
                break
            if(lines[i][0]=="=" and lines[j][0]=="=" and lines[i][3] == lines[j][3]):
                del lines[i]

    i = len(lines)-1
    while i >= 0:
        flag = 0
        #print(lines)
        if lines[i][0] == 'param' or lines[i][0] == 'call' or lines[i][0] == 'Label' or lines[i][0] == 'IfFalse' or lines[i][0] == 'if' or lines[i][0] == 'goto':
            i-=1
            continue
        for j in range(i+1,len(lines)):
            #print(i,j,flag)
            if(lines[i][3] == lines[j][1]):
                flag += 1
            elif lines[j][0] == 'param' and lines[j][3] == lines[i][3]:
                flag += 1
        if flag == 0 :
            del lines[i]
        i-=1

    return 1

changed=1
while changed:
    c1=constant_folding()
    c2=constant_propagation()
    c3=copy_propagation()
    changed=c1 or c2 or c3
    #break

dead_code_elimination()

changed=1 #after dead_code_elimination, we can still do some constant folding, propagation because, some loop blocks like elif and else can sometimes be eliminated. So can evaluate the expressions, propagate contstants,etc
while changed:
    c1=constant_folding()
    c2=constant_propagation()
    c3=copy_propagation()
    changed=c1 or c2 or c3

print('\n'.join(list(map(lambda line:'\t'.join(line),lines))))