note
	description: "Abstract notion of a ULN2003 Stepper Motor"

deferred class
	WP_ULN2003_STEPPER

inherit
	WP_STEPPER_MOTOR

feature -- Constants

	motor_pins: ARRAY [INTEGER]
			-- Define pins connected to four phase ABCD of stepper
		note
			design: "[
				These are the pins on the GPIO in-accordance-with (IAW) wiringPi pin-numbering.
				Each pin is presumed to be connected to a stator-pair.
				
				For example: IN1, IN2, IN3, IN4 represent A, B, C, D stator phases of the
				ULN2003 Stepper. See specification example below.
				]"
			specifications: "[
				28BYJ-48 Stepper Motor Technical Specifications
				Rated Voltage: 5V DC
				Number of Phases: 4
				Stride Angle: 5.625°/64
				Pull in torque: 300 gf.cm
				Insulated Power: 600VAC/1mA/1s
				Coil: Unipolar 5 lead coil
				]"
			EIS: "name=wiringPi_pins", "src=http://wiringpi.com/pins/special-pin-functions/" -- see section Pins 0-6
			EIS: "name=stator_motor_description", "src=https://www.galco.com/comp/prod/moto-ac.htm#:~:text=The%%20stator%%20then%%20is%%20the,on%%20the%%20AC%%20motor's%%20shaft."
			EIS: "name=ULN2003_stepper", "src=https://components101.com/motors/28byj-48-stepper-motor"
			EIS: "name=data_sheet", "src=https://components101.com/sites/default/files/component_datasheet/28byj48-step-motor-datasheet.pdf"
			EIS: "name=pull_in_out_torque", "src=https://www.kollmorgen.com/en-us/developer-network/pull-and-pull-out-torque/"
		once
			Result := <<1, 4, 5, 6>>
		end

	counter_clockwise_step: ARRAY [INTEGER]
			--<Precursor>
		once
			Result := <<0x01, 0x02, 0x04, 0x08>>
		end

	clockwise_step: ARRAY [INTEGER]
			--<Precursor>
		once
			Result := <<0x08, 0x04, 0x02, 0x01>>
		end


end
