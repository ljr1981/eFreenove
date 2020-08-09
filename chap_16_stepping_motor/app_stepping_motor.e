note
	description: "Sample Code - Stepping Motor"
	design: "[
		See Freenove Tutorial Chapter 16 - Stepping Motor

		The goal is to turn the stepper motor clockwise and then counter-clockwise.

		Compare to ... in the C_code folder of Freenove.
		]"

class
	APP_STEPPING_MOTOR

inherit
	WP_APP_HARNESS

create
	{TEST_SET_SUPPORT} default_create,
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			print ("Program is starting ... %N")

			prepare_pins

			rotate (360) -- rotating 360° clockwise, a total of 2048 steps in a circle, namely, 512 cycles.
			rotate (-360) -- rotating 360° counter-clockwise
			rotate (90)
			rotate (-45)
			rotate (45)
			rotate (-90)
		end

feature {NONE} -- Implementation: Operations

	rotate (a_degrees: INTEGER)
			-- Rotate stator-motor `a_degrees' in `clockwise' or `counter_clockwise' direction.
		do
			print ("Rotating " + a_degrees.out + "%N")
			move_steps (direction (a_degrees), minimum_ms_3, degrees_as_cycles (a_degrees.abs))
			env.sleep (microseconds_to_nanoseconds (500)) -- delay 500ms
		end

	direction (a_degrees: INTEGER): INTEGER
			-- What is `direction' of `a_degrees'? (`clockwise' or `counter_clockwise')
		do
			if degrees_is_clockwise (a_degrees) then
				Result := clockwise
			else
				Result := counter_clockwise
			end
		end

	degrees_is_clockwise (a_degrees: INTEGER): BOOLEAN
			-- Is `a_degrees' positive or clockwise?
		do
			Result := a_degrees >= 0
		end

	degrees_as_cycles (a_degrees: INTEGER): INTEGER
			-- 512 cycles = 360° or 0.703125 cycles per 1°
		do
			Result := (a_degrees / cycles_per_degree).truncated_to_integer
		end

	prepare_pins
			-- Prepare `motor_pins' for OUTPUT.
		do
			across -- Set each pin for OUTPUT ...
				motor_pins as ic
			loop
				wpi.pinMode (ic.item, wpi.OUTPUT_const)
			end
		end

	move_steps (a_direction, a_microseconds, a_steps: INTEGER)
			-- Continuous rotation function, the parameter steps.
			--	specifies the rotation cycles, every four steps is a cycle.
		do
			across
				1 |..| a_steps as ic
			loop
				move_one_period (a_direction, a_microseconds)
			end
		end

	motor_stop
			-- Function used to stop rotating
		do
			across
				motor_pins as ic
			loop
				wpi.digitalWrite (ic.item, wpi.low_const)
			end
		end

	move_one_period (a_direction, a_microseconds: INTEGER)
			-- As for four phase stepping motor, four steps is a cycle.
			--	The function is used to drive the stepping motor clockwise
			-- or anticlockwise to take four steps.
			-- NOTE: The delay can not be less than 3ms, otherwise it will
			--	exceed speed limit of the motor
		require
			three_or_more_ms: a_microseconds >= minimum_ms_3
			clockwise_or_counter: (<<clockwise, counter_clockwise>>).has (a_direction)
		local
			l_hi_lo: INTEGER
		do
			across
				1 |..| 4 as j
			loop
				across
					1 |..| 4 as i
				loop
					if a_direction = 1 then
						if counter_clockwise_step [j.item] = (1 |<< (i.item - 1)) then
							l_hi_lo := wpi.high_const
						else
							l_hi_lo := wpi.low_const
						end
					else
						if clockwise_step [j.item] = (1 |<< (i.item - 1)) then
							l_hi_lo := wpi.high_const
						else
							l_hi_lo := wpi.low_const
						end
					end
					wpi.digitalwrite (motor_pins [i.item], l_hi_lo)
					--print ("motorPin " + motor_pins [i.item].out + ", " + wpi.digitalRead (motor_pins [i.item]).out + "%N")
				end
				--print ("Step cycle!%N")
				env.sleep (microseconds_to_nanoseconds (a_microseconds))
			end
		end

	microseconds_to_nanoseconds (a_ms: INTEGER): INTEGER_64
			-- 1_000ns = 1ms?
			-- ms = 1M/second (1_000_000)
			-- ns = 1B/second (1_000_000_000)
			-- ns/ms = 1_000_000_000 / 1_000_000 = 1_000
		do
			Result := a_ms * ms_to_ns_multiplier
		end

feature {NONE} -- Implementation: Constants

	minimum_ms_3: INTEGER = 3
			-- The minimum microseconds to pause motor.

	cycles_per_degree: REAL = 0.703125
			-- 0.703125 cycles per 1° (360° / 512 cycles)

	clockwise: INTEGER = 1
			-- Representation of `clockwise' rotation vs. `counter_clockwise'.

	counter_clockwise: INTEGER = 0
			-- Representation of `counter_clockwise' rotation vs. `clockwise'.

	ms_to_ns_multiplier: INTEGER = 1_000_000
			-- ns/ms = 1_000_000_000 / 1_000_000 = 1_000

	env: EXECUTION_ENVIRONMENT
			-- Access to the {EXECUTION_ENVIRONMENT}.
		once
			create Result
		end

	motor_pins: ARRAY [INTEGER]
			-- Define pins connected to four phase ABCD of stepper
		note
			design: "[
				These are the pins on the GPIO IAW wiringPi pin-numbering.
				A "four-phase". Each pin is connected to a stator-pair.
				
				IN1, IN2, IN3, IN4 represent A, B, C, D stator phases of the
				ULN2003 Stepper.
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
			EIS: "name=stator_motor_description", "src=https://www.galco.com/comp/prod/moto-ac.htm#:~:text=The%%20stator%%20then%%20is%%20the,on%%20the%%20AC%%20motor's%%20shaft."
			EIS: "name=ULN2003_stepper", "src=https://components101.com/motors/28byj-48-stepper-motor"
			EIS: "name=data_sheet", "src=https://components101.com/sites/default/files/component_datasheet/28byj48-step-motor-datasheet.pdf"
			EIS: "name=pull_in_out_torque", "src=https://www.kollmorgen.com/en-us/developer-network/pull-and-pull-out-torque/"
		once
			Result := <<1, 4, 5, 6>>
		end

	counter_clockwise_step: ARRAY [INTEGER]
			-- Define power supply order for coil for rotating counter-clockwise
		once
			Result := <<0x01, 0x02, 0x04, 0x08>>
		end

	clockwise_step: ARRAY [INTEGER]
			-- Define power supply order for coil for rotating clockwise
		once
			Result := <<0x08, 0x04, 0x02, 0x01>>
		end

;end
