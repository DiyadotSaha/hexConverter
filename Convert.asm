##########################################################################
# Created by: Saha, Diya
# 	      dsaha4
#             24 May 2020
#
# Assignment: Lab 4: Sorting Integers 
# 		     CSE 12, Computer Systems and Assembly Language
#		     UC Santa Cruz, Spring 2020
#
# Description:  
#	This program access hex numbers from program arguments and 
#	converts the hexs to intergers and prints to the screen. 
#	It also sorts the integers in ascending order and prints them
#	on the screen. 
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################
# PSEUDOCODE
# printprogargs
#	loops through the prog arguments
#	prints out all arguments 
# printloop
#	prints the converted integers
#	store converted integer into array 
# calcloop 
#	loads each byte one by one 
#	if byte=num 
#		do conversion for num 
#	if byte=alpha 
#		do conversion for alpha 
# outloop
#	swapcounter = 0 
#	innerloop  
#		counter from (0, last element)
# 		num1 = firstelement array 
#		num2 = secondelelement array
#		if 
#	   		num1 > num2 then swap 
#	   		swapcounter +=1
#		else 
#			move on to the next two elements
#	if swap counter =0 
#		all awapping done 
#		exit out of the loop 
#	else 
#		go back to outerloop  
#	printFinal
#		loops through the array 
#		array now sorted 
#		print each element 
#	exit out of program 
##########################################################################
# REGISTER USAGE
# $zero: null value 	(used to represent a null value)
# $a0:   printing	(used to store interger input)
# $v0: 	 printing	(used in syscall)
# $s0:   index for the array
# $s1:   contains $a1 -> addresses 
# $s2:   temp register used for printing sorted values 
# $s4:	 stores array value for comparison and swapping 
# $s5: 	 stores number of program arguments  
# $s6: 	 stores a copy of $s5
# $t2:   stores array value for comparison and swapping
# $t0:   used as multiple counters  
# $t1: 	 used as multiple counters   
# $t3:   calculation for conversion 
# $t4:   calculation for conversion 
# $t5:   used as counter for printing 
# $t6: 	 checking whether hex byte is num/alpha 
# $t9: 	 storing 32 to end of the array  
##########################################################################

.data 
	proArgs: .asciiz "Program arguments:\n"
	intValue: .asciiz "Integer Values:\n"
	sortVal: .asciiz "Sorted Values:\n"
	space: .asciiz " "
	newline: .asciiz "\n"
	#message: .asciiz "\n in sort array :" # used for testing
	#message2: .asciiz "\n printing array: "
	myArray: .align 4
		.space 32					# because max arguments are 8 and 4 for each int
.text
	move 	$t1 $zero 					# initializing t1 to store 0
	move 	$s5 $a0						# store # args into s5 
	add 	$s6 $s5 $zero					# copies $s5 into $s6 
	move 	$s1 $a1 					# copies $a1 into a1
	li 	$v0 4			
	la 	$a0 proArgs					# printing label for progargs			
	syscall
	printprogargs:						#-got--from--TA's------demo----------
		beq 	$t1 $s5 end				# if counter = #porgargs
		beq	$t1 $zero nospace2 
		li 	$v0 4
		la 	$a0 space				# print space			
		syscall 
		nospace2: 
		li 	$v0 4
		lw 	$a0 ($a1)      				# address of the string to print
		syscall
		addi 	$a1 $a1 4				# increment register by 4
		addi 	$t1 $t1 1				# increment counter by 1 
		b printprogargs 
	end: 							#-got--from--TA's------demo----------
	li 	$v0 4 
	la 	$a0 newline					# print new line 
	syscall
	li 	$v0 4	
	la 	$a0 newline					# print new line 
	syscall
	li 	$v0 4
	la 	$a0 intValue					# print header 
	syscall	
	move 	$s0 $zero 					# array index counter 
	move 	$t1 $zero 					# initializing t1 to store 0
	printloop:			
		beqz	$t1 donothing 				# if the counter is 0 then do nothing 
		else:  
			sw 	$t4 myArray($s0) 		# store converted int into the array 
			beq 	$t1 1 nospace1
			li 	$v0 4
			la 	$a0 space			#printing space
			syscall
			nospace1: 
			move 	$a0 $t4				# print converted int 	
			li 	$v0 1
			syscall
			addi 	$s0 $s0 4			# increment array by 4
		donothing: 
		beq 	$t1 $s6 done
		addi 	$t1 $t1 1   				#t1 is thse counter of how many numbers i have looped through
		lw 	$t0 ($s1)				#t0 is a addfress of string, not a int value
		addi 	$s1 $s1 4				# next hex num
	move 	$t4 $zero					# set $t4 to zero 
	move 	$t6 $zero 					# set $t6 to zero 
	calcloop:						#---got from LAB DEMO -----
		nop
		lb   	$t3 2($t0)				#hex of each digit
		beq  	$t3 0 printloop				#null termination
		sle	$t6 $t3 0x39				# if less than hex 39 do num
		beq 	$t6 1 ifnum				# if num do num calc
		beqz 	$t6 ifalpha				# if alpha do alpha calc 
	ifnum: 							# for coverting numbers
		addi 	$t0 $t0 1				# incrementing counter 
		subi 	$t3 $t3 0x30	
		mul  	$t4 $t4 16				#0xabc=[(a*16)+b]*16+c=a*16^2+b*16+c
		add  	$t4 $t4 $t3
		b 	calcloop				#---got from LAB DEMO -----
	ifalpha:						# for coverting letter
		addi 	$t0 $t0 1				# incrementing counter
		subi 	$t3 $t3 0x37				# offset with subtraction for letters 	
		mul  	$t4 $t4 16				#0xabc=[(a*16)+b]*16+c=a*16^2+b*16+c
		add  	$t4 $t4 $t3			
		b 	calcloop
	done: 	
	li 	$v0 4
	la 	$a0 newline 					#printing newline
	syscall 
	li 	$v0 4
	la 	$a0 newline 					#printing newline
	syscall
	li 	$v0 4
	la 	$a0 sortVal 					#printing header
	syscall
	move 	$t0 $zero					#index for the loop 
	move 	$s4 $zero 					# current value
	move 	$t2 $zero 					# current next value 
	add 	$t1  $t2 4					# counter for next 
	mul 	$t9 $s5 4					# $t9 checker t9 = 32
	outloop:					
		move 	$t3 $zero				#if swap 0 then completely in acsending order
		move 	$t0 $zero 				# first num counter 
		add 	$t1 $t0 4 				# next num counter
		inloop: 
		beq 	$t1 $t9 swapcheck			# checking if already in acsending order 
		lw 	$s4 myArray($t0)			# store num1 
		lw 	$t2 myArray($t1)			# store num2 
		bge 	$t2 $s4 continue			# compare num1 and num2
		swap: 
			addi	$t3 $t3 1			#
			sw 	$t2 myArray($t0)		# swap num1
			sw 	$s4 myArray($t1)		# swap num2 
		continue: 
		addi 	$t0 $t0 4				# increment first counter 
		addi 	$t1 $t1 4				# increment second counter 
		b 	inloop
	swapcheck: 
		beqz 	$t3 endF				# if in acsending order then end 
		b 	outloop
	endF:
	move 	$t5 $zero 					# initializing for printing 
	move 	$s2 $zero 
	sub 	$t4 $t9 4 					# initializing for printing 
	printFinal: 
		beq 	$t5 $t9 exit 				# if counter = 32 exit
		lw 	$s2 myArray($t5)			# store from array
		beq 	$t5 $zero nospace
		li 	$v0 4
		la 	$a0 space 				#printing space
		syscall
		nospace: 
		li 	$v0 1
		move 	$a0 $s2					# print num 
		syscall	
		addi 	$t5 $t5 4				# increment by 4 	 	
		b printFinal
	exit: 	
		li 	$v0 4 
		la 	$a0 newline				# print new line 
		syscall						
		li 	$v0 10
    	  	syscall						# exit the program --------------------
#--Testing--using---print--statements-	
#		li $v0 4
#		la $a0 message
#		syscall
#		move $a0 $s4
#		li $v0 1
#		syscall
#		li 	$v0 4
#		la 	$a0 space 				#printing space
#		syscall
#		move $a0 $t2
#		li $v0 1
#		syscall
#		li 	$v0 4
#		la 	$a0 space 				#printing space
#		syscall
#--Testing--using---print--statements-
	