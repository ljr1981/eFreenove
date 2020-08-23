note
	description: "A PIGPIO Version (vs deprecated WiringPi) of LCD1602"

class
	APP_LCD1602

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			l_i2c: PP_I2C
		do
			create l_i2c
			print ("Starting PIGPIO LCD1602 ...%N")
			l_i2c.initialize_gpio
			if attached l_i2c.last_error as al_error then
				print ("Error: " + al_error.error_msg + "(" + al_error.error_no.out + ")%N")
			else
				print ("Successful intiailization.%NShutting down%N")
				l_i2c.terminate_gpio
				print ("GPIO Termination complete.%N")
			end
			print ("End program.%N")
		end

feature -- Access

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
