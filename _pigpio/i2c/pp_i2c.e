note
	description: "Access to PIGPIO I2C Related Functions"
	warnings: "[
		Ensure that your project includes the libpgpio Eiffel library.
		]"
	design: "[
		The features of this class wrap some (and someday all) of the
		I2C-related features of the libpgpio library class
		]"

class
	PP_I2C

inherit
	PIGPIO_FUNCTIONS_API

feature -- Initialization

	initialize_gpio
			-- Initialization of the GPIO.
		local
			l_return: INTEGER
		do
			l_return := gpio_initialise
			if l_return < 0 then
				last_error := ["initialize error", l_return]
			end
		end

feature -- Shutdown

	terminate_gpio
			-- Termination of the GPIO.
		do
			gpio_terminate
		end

feature -- Access

feature -- Measurement

feature -- Status report

	last_error: detachable TUPLE [error_msg: STRING; error_no: INTEGER]

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

end
