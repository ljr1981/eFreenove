note
	description: "Sample Code - Stepping Motor"
	design: "[
		See Freenove Tutorial Chapter 16 - Stepping Motor

		The goal is to turn the stepper motor clockwise and then counter-clockwise.

		Compare to /Code/C_Code/16.1.1_SteppingMotor/SteppingMotor.c in the C_code folder of Freenove.
		
		See desig notes at the bottom of this class.
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
			rotate_motor_by_degrees (360) -- rotating 360° clockwise, a total of 2048 steps in a circle, namely, 512 cycles.
			rotate_motor_by_degrees (-360) -- rotating 360° counter-clockwise
			rotate_motor_by_degrees (90)
			rotate_motor_by_degrees (-45)
			rotate_motor_by_degrees (45)
			rotate_motor_by_degrees (-90)
		end

feature {NONE} -- Implementation: Operations

	rotate_motor_by_degrees (a_degrees: INTEGER)
			-- Rotate stator-motor `a_degrees' in `clockwise' or `counter_clockwise' direction.
		require
			valid_degrees: (-360 |..| 360).has (a_degrees)
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

note
	design: "[
		You will find this code appears to be much more complex
		than the C in the SteppingMotor.c file. Why?
		
		Like any good Object-Oriented code, our goal is reuse.
		To get to reusable code, we refactor. Factoring out
		reusable code features generally results in more code,
		not less. However, it also means that it takes less
		code to accomplish a given job when viewed from the API.
		
		Such is the case here!
		
		Examine the `make' feature below and compare it to the
		'main' feature of the StepperMotor.c file. The two look
		deceptively similar, but they are not.
		
		1. Where is the call to wiringPiSetup();
		2. Where is the for-loop setting the pinMode?
		3. Where is the while-loop that run endlessly?
		
		Let's handle these in turn.
		
		First--where is wiringPiSetup?
		------------------------------
		The actual call to wiringPiSetup can be found in the WP_BASE class.
		Calling this feature is required before using any of the wiringPi
		library features. The WP_BASE class, together with the WP_APP_HARNESS
		class are design to ensure this call is made without any help from
		the programmer (e.g. so YOU do not forget to make the call yourself).
		
		Each of the wrapped-C wiringPi features in Eiffel is given knowledge
		of this requirement. Each feature requires the wiringPiSetup to
		have been already called. Having this guarentee means your code
		can inherit from the WP_APP_HARNESS with full assurance that the
		setup task will always be handled without fail.
		
		Second--Where is the pinMode for-loop?
		--------------------------------------
		This setup of the pin modes for each motor pin is handled in
		the `prepare_pins'. We don't need to know how this happens. We
		only want to know that it does happen. The details matter for
		those who are interested, but for the Client, no knowledge of
		how is required. So, we wrap this pin-prep in a feature and
		then simply call it. The name of the feature is enough to tell
		you the appropriate story.
		
		Finally--where is the endless while-loop?
		-----------------------------------------
		The endless while-loop is an annoying contrivance! Having to
		press Control+C from the keyboard to make the motor and program
		stop is mildly annoying. So, instead, we skip the entire 'loop'
		construct and just go for rotation of the motor.
		
		So, if you want to rotate a motor, why not just call it
		`rotate_motor_by_degrees'? The feature name tells the proper
		story and at the level of our main program routine, that is
		all we care about. Now, if we want to know "how" this rotation
		happens, we have a single feature to "dig-into" to understand.
		
		THIS reason is the primary reason why the C code is not a very
		good teacher. It does not isolate the ideas or tasks into
		discrete "chunks" that we can understand and examine in isolation.
		In the C code, we're left to wonder where one task ends and
		another begins or if the tasks are woven together, where we
		cannot easily tear them apart.
		
		The Eiffel features, like `rotate_motor_by_degrees' allows us
		to not only understand at a high level (feature name), but 
		properly isolates "what-is-happening" and "how" within the
		feature.
		
		If we then examine the rotate feature, we see even better
		story-telling in the code (i.e. we call it "Self-Documentation").
		Here, we see three actions: Print, Move, Sleep.
		
		The print is self-evident as is the sleep (pausing our action).
		
		The most interesting part is the `move_steps'. What precisely is
		`move_steps'? Well, from the name, we understand we are "moving"
		and we surmise that we are moving by something called "steps".
		
		Moreover, we can clearly see that moving steps involves a direction
		based on degrees, something to do with 3ms, and a number of degrees
		expressed as "cycles" (whatever those are).
		
		To understand the story (purpose) of each of the feature arguments,
		we turn to the features being called, such as: `direction', `Minimum_ms_3',
		and `degrees_as_cycles'. An examination of each of these will further
		reveal the "story-of-the-code".
		
		For example, in `direction', we learn that it is either `Clockwise' (1)
		or `Counter_clockwise' (0) and choosing which one is based on whether
		the `a_degrees' passed in is positive or negative, as computed by
		`degrees_is_clockwise' or not.
		
		The `Minimum_ms_3' feature tells us the story not only in its name,
		but in its comment. Here we see that 3 is the minimum number of
		microseconds to pause the cycling of the motor stator.
		
		Finally, we learn from `degrees_as_cycles' that 1-degree of turn
		is equal to 0.703125 cycles. Our motor turning cannot do fractional
		cycles, so we compute fractional-cycles and then truncate to just
		the integer cycle value and use it.
		
		An interesting aside question would be: Is truncation our only or
		even our best choice in this case? Not at all! We could do a
		more typical computation where 0.5 or less gets a truncation, whereas
		> 0.5 results in a truncated value + 1.
		
		SUMMARY
		=======
		The code is far more complex in Eiffel because doing so ultimately
		leads to better understanding, better organization, and better and
		more opportunities for reusable code. In fact, one could refactor
		this code into more reusable classes. For example: One might create
		a WP_STEPPER_MOTOR class with all of these features. That class
		might be dedicated to a particular motor and controller, which
		would give rise to still more classes (generic and specialized).

		]"

end
