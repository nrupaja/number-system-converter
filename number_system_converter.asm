# Title:	Number System Converter in MIPS
# Description:	This program takes an input from the user in the form of (Number, Current Base, Base it needs be converted in) and displays the output accordingly.
# Date:		05/15/2022

.data	
	input: .space 100
    	n: .space 100
   	convertedAr: .space 100
    	zeroFloat: .float 0.0
   	oneFloat: .float 1.0

	heading: .asciiz "NUMBER SYSTEM CONVERTER\n"
 	dash: .asciiz "====================================\n"
 	lineDash: .asciiz "\n------------------------------------\n\n"
	
	userInput: .asciiz "\nEnter a number to convert:  "
	originalBase: .asciiz "Base of the number entered: "
	convertedBase: .asciiz "Base to convert the number to: "
	colon: .asciiz ":-"
	resultText: .asciiz "Result: "
	
	convertedText1: .asciiz "Conversion from base "
	convertedText2: .asciiz " to base "
	newLine: .asciiz "\n"
	
	runAgainText: .asciiz "Choose (1 = Run Again | 2 = Convert the same number to another base | 3 = Exit):  "

.text
main:
	li $v0, 4
	la $a0, dash
	syscall
	
	li $v0, 4
	la $a0, heading
	syscall
	
	li $v0, 4
	la $a0, dash
	syscall
			
	lwc1 $f4, zeroFloat	
	lwc1 $f8, oneFloat	
	j again

again:
	li $v0, 4
	la $a0, userInput
	syscall

	la $a0, input
	li $a1, 100
	li $v0, 8
	syscall

numberInformation:
	addi $s0, $zero, 0
	addi $s1, $zero, 0
	addi $s2, $zero, 0
	addi $t1, $zero, 0

numberInformationLoop:
	lbu $t2, input($t1)
	beq $t2, '\n', nullWasFound
	beq $t2, '.', decimalWasFound	

	addi $s2, $s2, 1	
	addi $t1, $t1, 1		

	j numberInformationLoop	

decimalWasFound:
	addi $s1, $zero, 1

nullWasFound:
	add $s0, $zero, $t1

inputBase:
	li $v0, 4
	la $a0, originalBase
	syscall

	li $v0, 5
	syscall
	move $s3, $v0

outputBase:
	add.s $f0, $f4, $f4	

	li $v0, 4
	la $a0, convertedBase
	syscall

	li $v0, 5
	syscall
	move $s4, $v0

	bne $s3, $s4, setFactor	

setFactor:
	jal checkPower			

convertInputToNumber:
	addi $t0, $zero, 0		

convertInputToNumberLoop:
	lbu $t1, input($t0)		
	beq $t1, '\n', convertInputToNumberEnd	

	sb $t1, n($t0)		
	addi $t0, $t0, 1		
	j convertInputToNumberLoop	

convertInputToNumberEnd:
	sb $t1, n($t0)		

beginConversion:
	li $v0, 4
	la $a0, lineDash
	syscall
	
	li $v0, 4
	la $a0, convertedText1
	syscall

	li $v0, 1
	la $a0, ($s3)
	syscall

	li $v0, 4
	la $a0, convertedText2
	syscall

	li $v0, 1
	la $a0, ($s4)
	syscall
	
	li $v0, 4
	la $a0, colon
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall

	bnez $s7, powerRelationBegin

	add $a0, $zero, $s3	
	add $a1, $zero, $s0	

	jal arrayToDecimal	

	beq $s4, 10, printConvertedNumber	

	add $a0, $s4, 0		
	add $a1, $s1, 0		
	jal decToAny		

	j printConvertedNumberArray	

powerRelationBegin:
	beq $s3, $s7, iBaseIsRoot
	beq $s4, $s7, oBaseIsRoot	

neitherIsRoot:
	jal powerToBin		

convertedNumberToNumber:
	addi $t0, $zero, 0	
				
convertedNumberToNumberLoop:
	lbu $t1, convertedAr($t0)		
	beqz $t1, convertedNumberToNumberEnd		
	beq $t1, '\n', convertedNumberToNumberEnd	

	sb $t1, n($t0)		
	addi $t0, $t0, 1		
	j convertedNumberToNumberLoop	

convertedNumberToNumberEnd:
	sb $t1, n($t0)		

iBaseIsRoot:
	jal binToPower		
	j printConvertedNumberArray	

oBaseIsRoot:
	jal powerToBin			
	j printConvertedNumberArray	

printConvertedNumberArray:
	li $v0, 4
	la $a0, resultText
	syscall

	li $v0, 4
	la $a0, convertedAr($t4) 
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall

	j runAgain

printConvertedNumber:
	li $v0, 4
	la $a0, resultText
	syscall

	li $v0, 2
	add.s $f12, $f0, $f4
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	j runAgain
	
runAgain:
	li $v0, 4
	la $a0, lineDash
	syscall 
	
	li $v0, 4
	la $a0, runAgainText
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	blez $t1, exit
	beq $t1, 1, again
	beq $t1, 2, outputBase
	beq $t1, 3, exit
	syscall	

charToInt:
checkDigit:
	bge $a0, '0', maybeDigit	

checkCapital:
	bge $a0, 'A', maybeCapital	

checkLowercase:
	bge $a0, 'a', maybeLowercase	


charToIntFailed:
	j exit	

maybeDigit:
	bgt $a0, '9', checkCapital	
	sub $v0, $a0, '0'		
	jr $ra				

maybeCapital:
	bgt $a0, 'Z', checkLowercase	
	sub $t0, $a0, 'A'		
	addi $v0, $t0, 10		
	jr $ra			

maybeLowercase:
	bgt $a0, 'z', charToIntFailed	
	sub $t0, $a0, 'a'		
	addi $v0, $t0, 10		
	jr $ra	
						
intToCharFunction:
	bgt $a0, 9, intToCharLetter		

intToCharNumber:
	add $v0, $a0, '0'	
	jr $ra			

intToCharLetter:
	addi $t0, $a0, -10
	add $v0, $t0, 'A'	
	jr $ra		


powerFunction:
	add.s $f14, $f4, $f8		
	mtc1 $a0, $f6			
	cvt.s.w $f6, $f6		

checkExponent:
	bge $a1, $zero, implementPowerFunction	
	div.s $f6, $f8, $f6	
	mul $a1, $a1, -1	

implementPowerFunction:
	add $t0, $zero, 0	

powerFunctionLoop:
	beq $t0, $a1, endPowerFunction	
	mul.s $f14, $f14, $f6

	add $t0, $t0, 1
	j powerFunctionLoop	

endPowerFunction:
	jr $ra				

checkPower:
	add $s7, $zero, 2
	addi $sp, $sp, 4	
	sw $ra, 0($sp)		

checkPowerWhileLoop:
	bgt $s7, $s3, checkPowerZero	
	bgt $s7, $s4, checkPowerZero	

	move $a2, $s3		
	jal checkPowerHelp
	move $s5, $v0		

	bnez $s5, checkPower2nd
		
	add $s7, $s7, 1		
	j checkPowerWhileLoop

checkPower2nd:
	move $a2, $s4		
	jal checkPowerHelp	
	move $s6, $v0		

	bnez $s6, endCheckPower	

	add $s7, $s7, 1		
	j checkPowerWhileLoop

checkPowerZero:
	addi $s7, $zero, 0	

endCheckPower:
	lw $ra, 0($sp)			
	addi $sp, $sp, -4		
	jr $ra				

checkPowerHelp:
	addi $t1, $zero, 1	
	addi $sp, $sp, 4	
	sw $ra, 0($sp)		

checkPowerHelpLoop:
	add $a0, $s7, $zero	
	add $a1, $zero, $t1	
	jal powerFunction	
	cvt.w.s $f14, $f14	
	mfc1 $t2, $f14		

	bgt $t2, $a2 checkPowerHelpZero		
	beq $t2, $a2 checkPowerHelpFound	

	addi $t1, $t1, 1	
	j checkPowerHelpLoop	

checkPowerHelpFound:
	add $v0, $zero, $t1	

	lw $ra, 0($sp)			
	addi $sp, $sp, -4		
	jr $ra				

checkPowerHelpZero:
	addi $v0, $zero, 0

	lw $ra, 0($sp)			
	addi $sp, $sp, -4		
	jr $ra			

arrayToDecimal:
	add $t1, $zero, $zero
	add $s3, $zero, $a0
	add $s0, $zero, $a1

	addi $sp, $sp, 4
	sw $ra, 0($sp)		

beforeDecimal:
	lbu $t2, n($t1)		
	beq $t1, $s0, afterDecimal	

	add $a0, $zero, $t2	
	jal charToInt		
	mtc1 $v0, $f10		
	cvt.s.w $f10, $f10	

	add $a0, $zero, $s3	
	sub $t4, $s0, $t1	
	subi $a1, $t4, 1	
	jal powerFunction	

	mul.s $f2, $f14, $f10	
	add.s $f0, $f0, $f2

	addi $t1, $t1, 1
	j beforeDecimal		

afterDecimal:
	bne $t2, '.', endArrayToDecimal	
	addi $t1, $t1, 1	

afterDecimalLoop:
	lbu $t2, n($t1)	
	beq $t2, '\n', endArrayToDecimal	

	add $a0, $zero, $t2	
	jal charToInt		
	mtc1 $v0, $f10		
	cvt.s.w $f10, $f10	

	add $a0, $zero, $s3	
	sub $a1, $s0, $t1	
	jal powerFunction

	mul.s $f2, $f14, $f10	
	add.s $f0, $f0, $f2

	addi $t1, $t1, 1	
	j afterDecimalLoop	

endArrayToDecimal:
	lw $ra, 0($sp)			
	addi $sp, $sp, -4		
	jr $ra				
	
decToAny:
	add $s4, $a0, 0		
	add $s1, $a1, 0		

	addi $sp, $sp, 4	
	sw $ra, 0($sp)		

	beqz $s1, beginDecToAnyConversion
		
decToNumHasDecimal:
	add $a0, $zero, $s4
	addi $a1, $zero, 6	
	jal powerFunction	

	mul.s $f0, $f0, $f14	

beginDecToAnyConversion:
	add.s $f2, $f0, $f4	
	cvt.w.s $f2, $f2	
	mfc1 $t0, $f2		

	add $t1, $zero, $s4			
	addi $t2, $zero, 0		
	addi $t4, $zero, 99			
	sb $t2, convertedAr($t3)	
	addi $t4, $zero, 98			
	sb $t2, convertedAr($t4)

	beqz $t0, endDecToAny			

decToAnyConversionLoop:
	beqz $t0, decToAnyLoop2Check
	addi $t4, $t4, -1		
	rem $t2, $t0, $t1		

	add $a0, $zero, $t2		
	addi $sp, $sp, 4		
	sw $t0, 0($sp)			
	jal intToCharFunction		
	move $t5, $v0			
	lw $t0, 0($sp)			
	addi $sp, $sp, -4		

	sb $t5, convertedAr($t4)	

	div $t0, $t0, $t1
	
	j decToAnyConversionLoop	

decToAnyLoop2Check:
	bne $s1, 1, endDecToAny		
	add $t5, $zero, 98		

decToAnyLoop2:
	beq $t5, 92, decToAnyLoop2End	

	add $t6, $t5, -1		
	lb $t7, convertedAr($t6)	
	sb $t7, convertedAr($t5)	

	addi $t5, $t5, -1	
	j decToAnyLoop2			

decToAnyLoop2End:
	addi $t7, $zero, '.'	
	sb $t7, convertedAr($t5)
	j endDecToAny		
			
endDecToAny:
	lw $ra, 0($sp)		
	addi $sp, $sp, -4	
	jr $ra			

powerToBin:
	addi $t1, $zero, 0	
	add $t2, $zero, $s7	
	addi $t3, $zero, 0	
	addi $t5, $zero, 0	

	addi $sp, $sp, 4	
	sw $ra, 0($sp)		

powerToBinLoop:
	lbu $t6, n($t3)	
	beqz $t6, endPowerToBin			
	beq $t6, 10, endPowerToBin		
	beq $t6, '.', powerToBinFoundDecimal	

	add $a0, $t6, $zero	
	jal charToInt		
	move $t0, $v0		

	addi $t4, $s5, -1	

powerToBinLoop2:
	bltz $t4, endPowerToBinLoop	
	rem $t1, $t0, $t2	

	addi $t1, $t1, '0'	
	add $t7, $t5, $t4	
	sb $t1, convertedAr($t7)	
			
	div $t0, $t0, $t2	

	addi $t4, $t4, -1	
	j powerToBinLoop2	

endPowerToBinLoop:
	add $t5, $t5, $s5	
	addi $t3, $t3, 1	
	j powerToBinLoop	

powerToBinFoundDecimal:
	addi $t7, $zero, '.'	
	sb $t7, convertedAr($t5)	

	addi $t5, $t5, 1
	addi $t3, $t3, 1
	j powerToBinLoop

endPowerToBin:
	addi $t4, $zero, 0		
	sb $t4, convertedAr($t5)	

	lw $ra, 0($sp)			
	addi $sp, $sp, -4		
	jr $ra				

binToPower:
	addi $t0, $zero, 0	
	addi $t1, $zero, 0	
	rem $t2, $s2, $s6	

	addi $sp, $sp, 4	
	sw $ra, 0($sp)		

	beqz $t2, binToPowerLoop	

setChunkIndex:
	sub $t2, $s6, $t2	

binToPowerLoop:
	lbu $t3, n($t0)	
	beqz $t3, endBinToPower		
	beq $t3, 10, endBinToPower	
	beq $t3, '.', binToPowerFoundDecimal	
	addi $t4, $zero, 0	

binToPowerLoop2:
	lbu $t3, n($t0)
	bge $t2, $s6, binToPowerLoopEnd	
	beqz $t3, binToPowerLoopEnd	
	beq $t3, 10, binToPowerLoopEnd	

	addi $sp, $sp, 4	
	sw $t0, 0($sp)		

	add $a0, $zero, $t3	
	jal charToInt		
	move $t5, $v0

	add $a0, $zero, $s7
	sub $t6, $s6, $t2
	addi $a1, $t6, -1
	jal powerFunction
	cvt.w.s $f14, $f14
	mfc1 $t6, $f14

	mul $t6, $t6, $t5
	add $t4, $t4, $t6

	lw $t0, 0($sp)	
	addi $sp, $sp, -4	

	addi $t2, $t2, 1
	addi $t0, $t0, 1
	j binToPowerLoop2	

binToPowerLoopEnd:
	addi $sp, $sp, 4	
	sw $t0, 0($sp)		

	add $a0, $zero, $t4	
	jal intToCharFunction	
	move $t5, $v0		

	lw $t0, 0($sp)		
	addi $sp, $sp, -4		
			
	sb $t5 convertedAr($t1)	

	addi $t1, $t1, 1	
	addi $t2, $zero, 0	
	j binToPowerLoop	

binToPowerFoundDecimal:
	addi $t4, $zero, 0
	sb $t4, convertedAr($t1)	

	addi $t1, $t1, 1	
	addi $t0, $t0, 1	
	j binToPowerLoop	

endBinToPower:
	addi $t4, $zero, 0		
	sb $t4, convertedAr($t1)	

	lw $ra, 0($sp)			
	addi $sp, $sp, -4		
	jr $ra			
		
exit:
	li $v0, 10
	syscall