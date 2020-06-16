	.setcpu		"6502"

	.importzp	ptr1, ptr2, sp
	.import		pushax, incsp1
	.import		_mult_table_plus, _mult_table_minus
	.export		_fast_multiply

        .segment	"CODE"
        ;; Core of the fast multiplier
        ;; given: a in Y register
        ;;        b in A register
        ;; The function returns round(a*b/16) % 256 in A register.
        ;; Beware ! if b == 0, the result will be incorrect
        ;; Nothing else is touched 24-26 cycles (not counting rts)
        ;; The operation is performed in
        .proc fast_multiply
        ;; Second operand is in A, so storing b and -b in ptr1 and ptr2 low bytes
	sta	ptr1            ; 3 cycles
	eor	#$ff            ; 2 cycles
	clc                     ; 2 cycles
	adc	#$01            ; 2 cycles
	sta	ptr2            ; 3 cycles
        ;; Performing final substraction
        lda	(ptr1),Y	; 5-6 cycles - f(a + b)
	sec                     ; 2 cycles
	sbc     (ptr2),Y	; 5-6 cycles - f(a - b)
        rts                     ; 6 cycles
        .endproc

        ;; fast_multiply C interface:
        ;; unsigned char fast_multiply(unsigned char b, unsigned char a);
        ;; b and a are respectively in sp and A register.
        ;; The function returns round(a*b/16) % 256 in A register.
        ;; registers X and Y are used
        .proc   _fast_multiply
        ;; Some initialization (needed once if chaining multiplications)
        ldy	#>_mult_table_plus
        sty	ptr1+1
        ldy	#>_mult_table_minus
        sty	ptr2+1

        ;; Moving a to Y and loading b in A
        tay
        ldx     #0
        lda     (sp,X)

        ;; Actually performing the operation
        jsr fast_multiply
	;; Removing parameters from the stack
	jsr incsp1
	rts
        .endproc
