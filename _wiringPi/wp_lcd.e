note
	description: "Text-based LCD driver per WiringPi Library"
	EIS: "name=description", "src=http://wiringpi.com/dev-lib/lcd-library/"

	warnings: "[
		See the `lcdPrint' and `lcdPrintf' features for more.
		]"

deferred class
	WP_LCD

inherit
	ANY

	WP_CONSTANTS

feature -- Header Code

	lcdHome (a_handle: like lcd_handle)
			-- "Home" the LCD cursor.
			-- extern void lcdHome        (const int fd) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdHome ($a_handle)"
		end

	lcdClear (a_handle: like lcd_handle)
			-- extern void lcdClear       (const int fd) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdClear ($a_handle)"
		end

	lcdDisplay (a_handle: like lcd_handle; a_state: INTEGER)
			-- extern void lcdDisplay     (const int fd, int state) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdDisplay ($a_handle, $a_state)"
		end

	lcdCursor (a_handle: like lcd_handle; a_state: INTEGER)
			-- extern void lcdCursor      (const int fd, int state) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdCursor ($a_handle, $a_state)"
		end

	lcdCursorBlink (a_handle: like lcd_handle; a_state: INTEGER)
			-- extern void lcdCursorBlink (const int fd, int state) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdCursorBlink ($a_handle, $a_state)"
		end

	lcdSendCommand (a_handle: like lcd_handle; a_command: CHARACTER)
			-- extern void lcdSendCommand (const int fd, unsigned char command) ;
			-- We need use cases in order to understand this in context.
		external
			"C inline use <lcd.h>"
		alias
			"lcdSendCommand ($a_handle, $a_command)"
		end

	lcdPosition (a_handle: like lcd_handle; a_x, a_y: INTEGER)
			-- set Position of Cursor at `a_x', `a_y'.
			-- extern void lcdPosition    (const int fd, int x, int y) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdPosition ($a_handle, $a_x, $a_y)"
		end

	lcdCharDef (a_handle: like lcd_handle; a_index: INTEGER; a_char: CHARACTER)
			-- CharDef at `a_index' using `a_char'?
			-- extern void lcdCharDef     (const int fd, int index, unsigned char data [8]) ;
			-- We need use cases in order to understand this in context.
		external
			"C inline use <lcd.h>"
		alias
			"lcdCharDef ($a_handle, $a_index, $a_char)"
		end

	lcdPutchar (a_handle: like lcd_handle; a_char: CHARACTER)
			-- Put `a_char' at current Cursor location on LCD Display.
			-- extern void lcdPutchar     (const int fd, unsigned char data) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdPutchar ($a_handle, $a_char)"
		end

	lcdPuts (a_handle: like lcd_handle; a_string: STRING)
			-- Put `a_string' on LCD Display.
			-- extern void lcdPuts        (const int fd, const char *string) ;
		external
			"C inline use <lcd.h>"
		alias
			"lcdPuts ($a_handle, $a_string)"
		end

	lcdPrintf (a_handle: like lcd_handle; a_format: STRING; a_hour, a_minute, a_second: INTEGER)
			-- Print `a_message' to LCD Display.
			-- extern void lcdPrintf      (const int fd, const char *message, ...) ;
		note
			warning: "[
				Try as I may, I could not get this external C code call to 
				work as-is. Instead I opted to create the lcdPrint (below).
				]"
		external
			"C inline use <lcd.h>"
		alias
			"lcdPrintf ($a_handle, $a_format, $a_hour, $a_minute, $a_second)"
		end

	lcdPrint (a_handle: like lcd_handle; a_message: STRING_8; a_line: INTEGER)
			-- Print `a_message' as a string of chars on `l_handle' device.
		note
			warning: "[
				Based on issues with lcdPrintf, I opted to create this feature
				and utilize the lcdPutChar feature instead. The `lcdPrintf' was
				having very strange behavior, where it was printing Asian characters
				in Right-to-Left format instead of the ASC-II 8-bit characters
				it was being sent. There may be a bug in the wiringPiDev LCD.c
				code that I cannot determine.
				
				Instead of trying to fix it, I have a suitable work-around using
				the lcdPutChar and going across the characters of `a_message' on
				`a_line', starting at charcter column #1 (always). There may be
				useful variants, but there are no use-cases yet to create them.
				For now, this feature will be the go-to printing-at-line function.
				]"
			design: "[
				The present design is dependent on the LCD1602A in several ways:
				
				1. It is a two line display, so `a_line' must be 1 or 2.
				2. It is a 16-col display, so (thankfully) characters in `a_message'
					beyond 16 are not displayed (or wrapped-around from line 1 to 2).
				]"
			history: "[
				2020-08-24: I tried having this feature make a direct call on lcdPrintf
					(see above), but this did not work. The prinf of the wiringPiDev
					LCD.c code prints Asian characters in Right-to-Left format instead
					of ASC-II characters Left-to-Right. Obviously, there is something
					wrong with the translation of Eiffel STRING_8 characters of `a_message'
					and the printf. So, the temporary solution is to use lcdPrintChar
					sending each character of `a_message', moving the cursor position
					with each character sent.
				]"
		do
			across
				a_message as ic_char
			until
				ic_char.cursor_index > 16
			loop
				lcdPosition (a_handle, ic_char.cursor_index - 1, a_line - 1)
				lcdPutChar (a_handle, ic_char.item)
			end
		end

	lcdInit (a_rows, a_cols, a_bits, a_rs, a_strobe, a_d0, a_d1, a_d2, a_d3, a_d4, a_d5, a_d6, a_d7: INTEGER): INTEGER
			-- extern int  lcdInit (const int rows, const int cols, const int bits,
			--	const int rs, const int strb,
			--	const int d0, const int d1, const int d2, const int d3, const int d4,
			--	const int d5, const int d6, const int d7) ;
		note
			design: "[
				a_rows		How many rows in the display (e.g. 1-2-4)
				a_cols		How many columns in the display (e.g. 16)
				a_bits		How many bits per character (e.g. 4-bits)
				a_rs		Instruction/Data Register Selection 
				a_strobe	Enable Signal
				a_d0-7		8 data pins (this example only uses first 4)
				]"
		external
			"C inline use <lcd.h>"
		alias
			"[
				return lcdInit ($a_rows, $a_cols, $a_bits, $a_rs, $a_strobe, $a_d0, $a_d1, $a_d2, $a_d3, $a_d4, $a_d5, $a_d6, $a_d7);
				]"
		end

feature -- Constants

	RS_const: INTEGER once Result := BASE_const + 0 end
	RW_const: INTEGER once Result := BASE_const + 1 end
	EN_const: INTEGER once Result := BASE_const + 2 end
	LED_const: INTEGER once Result := BASE_const + 3 end
	D4_const: INTEGER once Result := BASE_const + 4 end
	D5_const: INTEGER once Result := BASE_const + 5 end
	D6_const: INTEGER once Result := BASE_const + 6 end
	D7_const: INTEGER once Result := BASE_const + 7 end
		-- The "BASE_const +" is 64 + n, where 64 is
		-- binary 0b01000000, which is a shift. The Freenove
		-- documentation does not appear to explain the
		-- reason this 64-bit set to 1 is required.

feature -- Access

	lcd_handle: INTEGER
		-- A handle (pointer) to the LCD device on the I2C bus.

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
