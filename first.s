     AREA     apcode, CODE, READONLY
	 EXPORT __main
     IMPORT __cos
     IMPORT __sin	 
     IMPORT printMsg2p
	 
pi EQU	0x40490fdb
		
       ENTRY
__main FUNCTION
	
        MOV R4, #1500 ;	no of iterations
		VLDR.F32 S25, =360 
		VLDR.F32 S22, =10 ; SOME CONSTANT b=10
	   LDR			R5,=pi
	   VMOV.F32		S26,R5  ; s26 = pi
	   VDIV.F32     S27,S26,S25 ; S27 = pi/360;
	   MOV R6, #1 ;  ;LET i
spiral1	VMOV.F32 S28,R6; s28=i
        VCVT.F32.U32 S28,S28 ; converts floating point to integer
        VMUL.F32  S29,S28,S27  ;S29 (t)= i*pi/360
        VMOV.F32 R0,S29; mov t to R0 to pass as a parameter to cos and sin functions
		BL __cos
        VMOV.F32 S10,R0 ; S10 = cost
        VMOV.F32 R0,S29;		
		BL __sin
		VMOV.F32 S21,R0 ; S21 = sint
        VMUL.F32  S30,S22,S29 ; r=bt
		VMUL.F32 S15,S30,S10; x = btcost
        VMUL.F32 S16,S30,S21; y = btsint
		VMOV.F32 S11,S15 ;x1
        VMOV.F32 S12,S16  ;y1 
		VCVT.S32.F32 S15,S15,#16 ; converting floating point in x to 16 bit fixed point
		VCVT.S32.F32 S16,S16,#16 ; converting floating point in y to 16 bit fixed poin 
		VMOV.F32 R0,S15  ; mov x to ro to print
		VMOV.F32 R1,S16   ; mov y to r1 to print
		BL  printMsg2p
		ADD R6,#1  ; increment i
		CMP R4,R6  ; compare i with n till no of iterations reached
		BNE spiral1
		               
	
         MOV R4, #2000 ;	no of iterations
		 VLDR.F32 S25, =360
        		
		 VLDR.F32 S22, =3 ; SOME CONSTANT b=3
	    LDR			R5,=pi
	    VMOV.F32		S26,R5  ; s26 = pi
	    VDIV.F32     S27,S26,S25 ; S27 = pi/360;
	    MOV R6, #1 ;  ;LET i
spiral2	VMOV.F32 S28,R6;
        VCVT.F32.U32 S28,S28 
        VMUL.F32  S29,S28,S27  ;S29 (t)= i*pi/360
        VMOV.F32 R0,S29;
		BL __cos
        VMOV.F32 S10,R0 ; S10 = cost
        VMOV.F32 R0,S29;		
		BL __sin
		VMOV.F32 S21,R0  ; S21 = sint
        VMUL.F32  S30,S22,S29 ;  r=bt
		VMUL.F32 S15,S30,S10;  x = btcost
		VLDR.F32 S2, =500  ; SOME CONSTANT C for the second spiral to have some other origin
		VADD.F32 S15,S15,S2;   x = btcost+c
        VMUL.F32 S16,S30,S21;  y = btsint
		VADD.F32 S16,S16,S2;    y = btsint+c
		VMOV.F32 S1,S15 ;x2
        VMOV.F32 S2,S16 ;y2
		VCVT.S32.F32 S15,S15,#16 ; converting floating point in x to 16 bit fixed point
		VCVT.S32.F32 S16,S16,#16 ; converting floating point in y to 16 bit fixed point
		VMOV.F32 R0,S15  ; mov x to ro to print
		VMOV.F32 R1,S16   ; mov y to r1 to print
		BL  printMsg2p
		ADD R6,#1  ; increment i
		CMP R4,R6  ; compare i with n till no of iterations reached
		BNE spiral2
		
               ;VLDR.F32 S11,=28.7912  ; s11=x1
			   ;VLDR.F32 S12,=-172     ; s12=y1
			   ;VLDR.F32 S1,=505.451   ;s1=x2
			   ;VLDR.F32 S2,=448.135   ;s2=y2
		       VSUB.F32 S3,S2,S12 ; y2-y1
               VSUB.F32 S4,S1,S11 ;   x2-x1
			   VDIV.F32 S5,S3,S4 ; SLOPE m
				VMOV.F32 S6,S11 ; S6=x1
				VLDR.F32 S13,=2  ; x1 is incremented by 5 everytime till it reaches x2 
straight_line   VSUB.F32 S7,S6,S11  ;x-x1
			   VMUL.F32 S7,S5 ; m(x-x1)
			   VADD.F32 S8,S7,S12 ;y=m(x-x1)+y1
			   VMOV.F32 S7,S6 
		     VCVT.S32.F32 S7,S7,#16  ; S7=x
			 VCVT.S32.F32 S8,S8,#16  ;S8=y
		     VMOV.F32 R0,S7   ;mov x in S7 to ro to print
		      VMOV.F32 R1,S8  ; mov y in S8 to r1 to print
		BL  printMsg2p
		VADD.F32 S6,S13  ; x1 is incremented by 5 everytime till it reaches x2 
		VCMP.F32 S6 ,S1  ;x1 is compared with x2
		VMRS.F32		APSR_nzcv, FPSCR
        BLT 	straight_line	
		
STOP    B STOP                              ; stop program
     
     ENDFUNC
     END	 