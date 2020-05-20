t0
LDR R0,=t0

t0
t1
LDR R1,=t1

a
LDR R2,=a

t1
a
t2
LDR R3,=t2

q
LDR R4,=q

t2
t3
LDR R5,=t3

t3
q
t4
LDR R6,=t4

c
LDR R7,=c

t4
d
LDR R8,=d

c
d
		AREA     ARMex, CODE, READONLY
		ENTRY                   ; Mark first instruction to execute

		.text

start:
		LDR R0,=t0
		MUL R0,#9,#8
		LDR R1,=t1
		ADD R1,R0,#6
		LDR R2,=a
		LDR R2,=a
		MOV R2,R1
		MOV R2,#25
		LDR R3,=t2
		POW R3,#9,#2
		LDR R4,=q
		LDR R4,=q
		MOV R4,R3
		LDR R5,=t3
		MUL R5,#2,#7
		LDR R6,=t4
		ADD R6,R5,R4
		LDR R7,=c
		LDR R7,=c
		MOV R7,R6
		LDR R8,=d
		LDR R8,=d
		MOV R8,R7
		PUSH {R8}
		BL print

stop:
		MOV      r0, #0x18      ; angel_SWIreason_ReportException
		LDR      r1, =0x20026   ; ADP_Stopped_ApplicationExit
		SVC      #0x123456      ; ARM semihosting (formerly SWI)

		.data
t0: 0
t1: 0
a: 0
t2: 0
q: 0
t3: 0
t4: 0
c: 0
d: 0

