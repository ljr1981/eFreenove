note
	description: "WiringPi Constants"
	EIS: "src=~/Freenove_Kit/Tutorial.pdf"
	see_more: "See class notes at the end of this class text."

expanded class
	WP_CONSTANTS

feature -- Common

	One_second_const: INTEGER_64 = 1_000_000_000
			-- 1 million nano-seconds = 1 second.

	Env: EXECUTION_ENVIRONMENT
			-- Access to sleep (delay)
		once
			create Result
		end

feature -- Blink specific

	LED_pin_0_const: INTEGER = 0
			-- Access to GPIO pin 0 (WiringPi) 11 (Physical) 17 (BCM or BroadCom).
			-- For Blink tutorial project only.

feature -- Button & LED specific

	buttonPin_const: INTEGER = 1
			-- button Pin based on Freenove chapter task.

feature -- Pin Modes

	pin_modes: ARRAY [INTEGER]
			-- List of `pin_modes' defined in WiringPi.
		once
			Result := <<
						pin_mode_INPUT_const,
						pin_mode_OUTPUT_const,
						pin_mode_PWM_OUTPUT_const,
						pin_mode_GPIO_CLOCK_const,
						pin_mode_SOFT_PWM_OUTPUT_const,
						pin_mode_SOFT_TONE_OUTPUT_const,
						pin_mode_PWM_TONE_OUTPUT_const
					>>
		ensure
			count: Result.count = 7 -- modes total (0-6)
		end

	pin_mode_INPUT_const: INTEGER = 0
			-- Pin-mode for INPUT.

	pin_mode_OUTPUT_const: INTEGER = 1
			-- Pin-mode for OUTPUT.

	pin_mode_PWM_OUTPUT_const: INTEGER = 2
			-- PWM (Pulse-width Modulation) OUTPUT.

	pin_mode_GPIO_CLOCK_const: INTEGER = 3
			--GPIO (General-purpose Input/Output) CLOCK.

	pin_mode_SOFT_PWM_OUTPUT_const: INTEGER = 4
			-- Software-based PWM (Pulse-width Modulation) OUTPUT.

	pin_mode_SOFT_TONE_OUTPUT_const: INTEGER = 5
			-- Software-based TONE OUTPUT.

	pin_mode_PWM_TONE_OUTPUT_const: INTEGER = 6
			-- PWM (Pulse-width Modulation) TONE OUTPUT.

feature -- High-Low Constants

	HIGH_const: INTEGER = 1
			-- Raise the voltage (i.e. "on").

	LOW_const: INTEGER = 0
			-- Lower the voltage (i.g. "off").

feature -- // Pull up/down/none

	PUD_OFF_const: INTEGER = 0
	PUD_DOWN_const: INTEGER = 1
	PUD_UP_const: INTEGER = 2

feature -- Constants

	BASE_const: INTEGER = 64
			-- Base pin constant.

	ms_to_ns_multiplier: INTEGER = 1_000_000
			-- milliseconds-to-nanoseconds multiplier.
			-- (e.g. 1_000_000 ns = 1 millisecond)

note
	documentation: "[
		These constants are based on several sources:
		
		1. The <wiringPi.h> file.
		2. The <Blink.c> example code file.

		]"

end
