note
	description: "WiringPi Constants"
	EIS: "src=~/Freenove_Kit/Tutorial.pdf"
	see_more: "See class notes at the end of this class text."

expanded class
	WP_CONSTANTS

feature -- Common

	One_second_const: INTEGER_64 = 1_000_000_000
			-- 1 million nano-seconds = 1 second.

feature -- Blink specific

	LED_pin_0_const: INTEGER = 0
			-- Access to GPIO pin 0 (WiringPi) 11 (Physical) 17 (BCM).
			-- For Blink tutorial project only.

feature -- Button & LED specific

	buttonPin_const: INTEGER = 1

feature -- Pin Modes

	INPUT_const: INTEGER = 0
			-- Pin-mode for INPUT.

	OUTPUT_const: INTEGER = 1
			-- Pin-mode for OUTPUT.

	HIGH_const: INTEGER = 1
			-- Raise the voltage (i.e. "on").

	LOW_const: INTEGER = 0
			-- Lower the voltage (i.g. "off").

feature -- // Pull up/down/none

	PUD_OFF_const: INTEGER = 0
	PUD_DOWN_const: INTEGER = 1
	PUD_UP_const: INTEGER = 2

note
	documentation: "[
		These constants are based on several sources:
		
		1. The <wiringPi.h> file.
		2. The <Blink.c> example code file.

		]"

end
