=	1		a
+	1	2	t0
=	t0		b
Label	 	 	L3
==	a	2	t1
IfFalse	t1	goto	L0
=	3		a
goto	 	 	L2
Label	 	 	L0
=	4		a
goto	 	 	L2
Label	 	 	L2
=	5		b
param	 	a	0	 
call	 	print	1