  AREA     cos_fun, CODE, READONLY
     EXPORT __sin	 
     IMPORT printMsg
		 
pi EQU	0x40490fdb	 
       ENTRY
__sin  FUNCTION	
       PUSH         {R4-R12,LR} 	
       VMOV.F32		S20, R0  ;Provide x to calculate cosx
	   VLDR.F32		S18, = 2;

	   LDR			R6,=pi
	   VMOV.F32		S6,R6  ; s6 = pi
	   VMUL.F32		S6,S6,S18 ; s6 = 2pi
GT_two_pi	   VCMP.F32		S20,S6  ; compare x, 2pi
	           VMRS.F32		APSR_nzcv, FPSCR ;Copy Floating point status registers into normal status registers 
		       BLT			ITER_var  ; if x < 2pi branch to iter_val
	           VSUB.F32		S20,S6    ; if x > 2pi , s20 = s20 - s6 = x-2pi 
		       B			GT_two_pi	   
ITER_var	   LDR		R3, = 100 ; loop variable
	   VMUL.F32		S1,S20,S20 ;Copying x^2 to S1
	   VNMUL.F32	S2,S20,S20 ;Copying -x^2 to S2
	   VMUL.F32     S2,S2,S20 ; S2 = -x^3
	   VMOV.F32		S30,S20    ;The Value of sinx after each iterarion is stored in S30
	   VLDR.F32		S19, = 1;
	   VLDR.F32		S3, = 3	;

lOOP    VMUL.F32        S18,S18,S3 ; calculate 3!,5!,7!......
     	VDIV.F32		S4,S2,S18 ; s4 = s2 / s18 => -x^3/3! , x^4/4!, ....
	    VADD.F32		S30,S4   ; Calculate new iteration value s30 = s30 + s4 ;
	    VADD.F32		S3,S19 	; Denominator Value s3 = s3 + s19 
	    VMUL.F32		S18,S3	; Factorial s18 = s18 * s3
	    VADD.F32		S3,S19 	; Denominator Value
	    VNMUL.F32	S2,S1 	;
	   SUB			R3,#1
	   CMP			R3,#0	;compare if maimum iteration is reached 
	   BNE 			lOOP	;Goto Next iteration if maximum iteration is not reached
Stop    VCVTR.S32.F32 S30,S30
		VMOV.F32		R0,S30
	   POP          {R4-R12,LR}
		BX LR
	 
     ENDFUNC
	 END