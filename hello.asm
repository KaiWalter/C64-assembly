// Commodore 64 Hello World Program
// Displays "HELLO WORLD" on the screen via BASIC Print routine
// Also demonstrates writing directly to screen memory

BasicUpstart2(start)

// Assembler constants for special memory locations
.const CLEAR_SCREEN_KERNAL_ADDR = $E544     // Kernal routine to clear screen
.const PRINT_STRING_BASIC_ADDR = $AB1E      // Kernal routine to print text
.const SCREEN_START = $0400                 // The start of c64 screen memory
.const SCREEN_DIRECT_START = SCREEN_START + $0100 // Direct write location

// Program variables/strings
str_to_print: .text @"HELLO WORLD!\$00"      // null terminated string for BASIC print
str_to_poke: .text @"hello direct\$00"     // null terminated string for direct write

* = $1000 "Main Program"
start:
	// Clear screen - leave cursor at upper left
	jsr CLEAR_SCREEN_KERNAL_ADDR

	// Method 1: Call BASIC routine to print string
	// String will appear at upper left after clear screen
	lda #<str_to_print           // LSB of address of string to print
	ldy #>str_to_print           // MSB of address of string to print
	jsr PRINT_STRING_BASIC_ADDR  // Call Kernal routine to print the string

	// Method 2: Write directly to screen memory
	ldx #0                       // Use X register as loop index, start at 0
DirectLoop:
	lda str_to_poke,x            // Put a byte from string into accumulator
	beq Done                     // If the byte was 0 then we're done
	sta SCREEN_DIRECT_START,x    // Store the byte to screen memory
	inx                          // Increment to next byte and next screen location
	jmp DirectLoop               // Go back for next byte

Done:
	rts                          // Program done, return to BASIC
