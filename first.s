     AREA     cos_fun, CODE, READONLY
	 EXPORT __main
     IMPORT __cos
     IMPORT __sin	 
     IMPORT printMsg2p
	 
pi EQU	0x40490fdb
		
       ENTRY
__main FUNCTION
	
        MOV R4, #6000 ;	no of iterations
		VLDR.F32 S25, =360 
		VLDR.F32 S22, =5  ; SOME CONSTANT b=5
	   LDR			R5,=pi
	   VMOV.F32		S26,R5  ; s26 = pi
	   VDIV.F32     S27,S26,S25 ; S27 = pi/360;
	   MOV R6, #1 ;  ;LET i
spiral	VMOV.F32 S28,R6;
        VCVT.F32.U32 S28,S28 
        VMUL.F32  S29,S28,S27  ;S29 (t)= i*pi/360
        VMOV.F32 R0,S29;
		BL __cos
        MOV R6,R0		
		BL __sin
		MOV R7,R0
        VMUL.F32  S30,S22,S29 ; r=bt
		VMOV.F32  R8,S30 ;
		MUL R0,R6,R8; x = btcost
        MUL R1,R7,R8; y = btsint
		BL  printMsg2p
		ADD R6,#1
		CMP R4,R6
		BNE spiral
STOP    B STOP                              ; stop program
     
     ENDFUNC
     END	 