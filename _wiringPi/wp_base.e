note
	description: "Wrapped WiringPi C Functions."
	ca_ignore: "CA088" -- Mergeable feature clauses for Status Report is actually not true.

class
	WP_BASE

inherit
	ANY
		redefine
			default_create
		end

	WP_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			--<Precursor>
			-- Initialize with `wiringPiSetup'.
		require else
			not_initialized: not is_wiringpi_initialized
		do
			Precursor
			initialize_wiringpi
		ensure then
			is_initialized: is_wiringpi_initialized
		end

feature -- Status Report

	is_wiringpi_initialized: BOOLEAN
			-- Has the `wiringPiSetup' been called?

feature -- Basic Operations

	initialize_wiringpi
			-- Initialize `wiringPiSetup'.
		require
			not_initialized: not is_wiringpi_initialized
		do
			wiringPiSetup
			is_wiringpi_initialized := True
		ensure
			setup: is_wiringpi_initialized
		end

feature {NONE} -- WiringPi Setup

	wiringPiSetup
			-- `wiringPiSetup'
		require
			not_initialized: not is_wiringpi_initialized
		external
			"C signature use <wiringPi.h>"
		alias
			"wiringPiSetup"
		end

feature -- WiringPi Wraps

	pinMode (a_wpi_pin_number, a_pin_mode:INTEGER)
			-- Set `pinMode' to `a_wpi_pin_number' with `a_pin_mode'
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
			valid_mode: is_valid_pin_mode (a_pin_mode)
		external
			"C signature (int, int) use <wiringPi.h>"
		alias
			"pinMode"
		end

	digitalWrite (a_wpi_pin_number, a_hi_lo: INTEGER)
			-- Write `a_hi_lo' (digital 1 or 0) to `a_wpi_pin_number'.
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
			valid_hi_lo: is_valid_hi_lo (a_hi_lo)
		external
			"C signature (int, int) use <wiringPi.h>"
		alias
			"digitalWrite"
		end

	digitalRead (a_wpi_pin_number: INTEGER): INTEGER
			-- Read hi-lo value of `a_wpi_pin_number'.
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
		external
			"C signature (int): int use <wiringPi.h>"
		alias
			"digitalRead"
		end

	pullUpDnControl (a_wpi_pin_number, a_pull_up_down_off: INTEGER)
			-- Set `pullUpDnControl' on `a_wpi_pin_number' for `a_pull_up_down_off'.
		require
			valid_setup: is_wiringpi_initialized
			valid_pin: is_valid_wpi_pin_number (a_wpi_pin_number)
			valid_pud: is_valid_pud (a_pull_up_down_off)
		external
			"C signature (int, int) use <wiringPi.h>"
		alias
			"pullUpDnControl"
		end

	softPwmCreate (a_pin_number, a_low, a_high: INTEGER)
			-- Create a softwarebased PWM for `a_pin_number' between `a_low' and `a_high' value.
		require
			valid_setup: is_wiringpi_initialized
		external
			"C signature (int, int, int) use <wiringPi.h>"
		alias
			"softPwmCreate"
		end

feature -- Status Report

	is_valid_wpi_pin_number (a_value: INTEGER): BOOLEAN
			--
		do
			Result := (0 |..| 20).has (a_value)
		end

	is_valid_pin_mode (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid "pin mode"?
		do
			Result := (0 |..| 6).has (a_value)
		end

	is_valid_hi_lo (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid HIGH or LOW?
		do
			Result := (<<LOW_const, HIGH_const>>).has (a_value)
		end

	is_valid_pud (a_value: INTEGER): BOOLEAN
			-- Is `a_value' a valid OFF, UP, DOWN?
		do
			Result := (<<PUD_OFF_const, PUD_UP_const, PUD_DOWN_const>>).has (a_value)
		end

note
	analysis_notes: "[
		Take note of the "Analyze" tool in the Eiffel Studio toolbar.
		This tool is a code analyzer, which works very well. However,
		it does tend to get a little strict, so we use "ca_ignore" note
		clauses (see top of class) to turn off analysis assertions
		on a class-by-class basis. I tend to leave comments on each
		"ignore" so that the reader is not left to wonder why.
		]"

end
