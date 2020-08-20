note
	description: "Ultrasonic Ranging Sensor Application"

class
	APP_ULTRA

inherit
	WP_APP_HARNESS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			l_ultra: WP_HCSR04
			l_distance_cm: REAL
			l_start,
			l_end: TIME
		do
			create l_ultra
			create l_start.make_now
			
			across
				1 |..| 10_000 as ic -- about 65 seconds (1 minute) total read-time.
			loop
				print ("CM: " + l_ultra.getSonar.out + "%N")
				wpi.delayMicroseconds (1_000)
			end

			create l_end.make_now
			print ("Start: " + l_start.out + "%N")
			print ("End: " + l_end.out + "%N")
			print ("Total = " + (l_end.fine_seconds - l_start.fine_seconds).out + " seconds%N")
		end

end
