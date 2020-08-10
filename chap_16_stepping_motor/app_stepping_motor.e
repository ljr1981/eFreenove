note
	description: "Sample Code - Stepping Motor"
	design: "[
		See Freenove Tutorial Chapter 16 - Stepping Motor

		The goal is to turn the stepper motor clockwise and then counter-clockwise.

		Compare to /Code/C_Code/16.1.1_SteppingMotor/SteppingMotor.c in the C_code folder of Freenove.
		]"

class
	APP_STEPPING_MOTOR

inherit
	WP_ULN2003_STEPPER

create
	{TEST_SET_SUPPORT} default_create,
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			print ("Program is starting ... %N")
			prepare_pins
			rotate_motor_by_degrees (360) -- rotating 360° clockwise, a total of 2048 steps in a circle, namely, 512 cycles.
			rotate_motor_by_degrees (-360) -- rotating 360° counter-clockwise
			rotate_motor_by_degrees (90)
			rotate_motor_by_degrees (-45)
			rotate_motor_by_degrees (45)
			rotate_motor_by_degrees (-90)
		end

end
