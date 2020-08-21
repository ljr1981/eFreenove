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
	WP_ULN2003_STEPPER -- is this still needed in view of `motor' feature?

create
	{TEST_SET_SUPPORT} default_create,
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			print ("Program is starting ... %N")

			motor.prepare_pins

			motor.rotate_by_degrees (360) -- rotating 360° clockwise, a total of 2048 steps in a circle, namely, 512 cycles.
			motor.rotate_by_degrees (-360) -- rotating 360° counter-clockwise
			motor.rotate_by_degrees (90)
			motor.rotate_by_degrees (-45)
			motor.rotate_by_degrees (45)
			motor.rotate_by_degrees (-90)
		end

feature {NONE} -- Implementation

	motor: WP_ULN2003_STEPPER
			-- Access to motor code and electronics.
		once
			create Result
		end

end
