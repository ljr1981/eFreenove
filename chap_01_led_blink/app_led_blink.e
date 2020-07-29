note
	description: "Sample Code - LED Blink"
	design: "[
		See Freenove Tutorial Chapter 1 - LED
		
		The goal is to blink an LED 10 times (1 second on and 1 second off).
		
		Compare to Blink.c in the C_code folder of Freenove.
		]"

class
	APP_LED_BLINK

inherit
	WP_APP_HARNESS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		local
			l_env: EXECUTION_ENVIRONMENT
		do
			create l_env

			print ("LED Blink 10 times across 20 seconds ...%N")

			wpi.pinMode (LED_pin_0_const, OUTPUT_const)

			across
				1 |..| 10 as ic
			loop
				print (ic.item.out + " on ")

				wpi.digitalWrite (led_pin_0_const, HIGH_const)

				l_env.sleep (One_second_const)
				print ("off ")

				wpi.digitalWrite (LED_pin_0_const, LOW_const)

				l_env.sleep (One_second_const)
				print ("%N")
			end
			print ("Finished!%N")
		end

end
