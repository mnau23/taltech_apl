	.global main
	.text
	.ent main
main:
	# configure PORTA as digital
	lui	$2,%hi(ANSELA)
	sw	$0,%lo(ANSELA)($2)
	
	# initialize VAR LD0
	lui	$2,%hi(TRISACLR)
	li	$3,0x1
	sw	$3,%lo(TRISACLR)($2)
	
	# assign to VAR LD0
	lui	$2,%hi(LATASET)
	li	$3,0x1
	sw	$3,%lo(LATASET)($2)
.lbl1:
	j	.lbl1
	nop
	
	.end	main
	
	.section	.config_BFC02FFC, code, keep, address(0xBFC02FFC) 
	.word	0x7FFFFFFB 
	.section	.config_BFC02FF8, code, keep, address(0xBFC02FF8)
	.word	0xFF74FD5B 
	.section	.config_BFC02FF4, code, keep, address(0xBFC02FF4) 
	.word	0xFFF8FFD9 
	.section	.config_BFC02FF0, code, keep, address(0xBFC02FF0) 
	.word	0xCFFFFFFF
