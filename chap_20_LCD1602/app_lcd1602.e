note
	description: "A PIGPIO Version and deprecated WiringPi version of LCD1602"

class
	APP_LCD1602

inherit
	WP_APP_HARNESS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current
		do
			make_wiringpi
		end

	make_wiringpi
			-- Initialize and process on wiringPi library basis.
		note
			design: "[
				The Freenove code has dependencies on <pcf8574.c> and <lcd.h>. The LCD
				code is found in the wiringPiDev library, which is an add-on. This
				requires an additional C-flag for this Eiffel target (see project settings).
				
				See the class {WP_PCF8574_LCD1602A} notes for more.
				]"
		local
			l_lcd: WP_PCF8574_LCD1602A
			l_handle: INTEGER
			l_cpu_string,
			l_time_string: STRING
		do
			create l_lcd

			l_lcd.setup
			across 0 |..| 7 as ic loop
				Wpi.pinmode (l_lcd.base_const + ic.item, pin_mode_OUTPUT_const)
			end
			Wpi.digitalWrite (l_lcd.LED_const, HIGH_const) -- turn on LED on LCD backlight

			Wpi.digitalWrite (l_lcd.RW_const, LOW_const)

			l_handle := l_lcd.lcdInit (2, 16, 4, l_lcd.RS_const, l_lcd.EN_const, l_lcd.D4_const, l_lcd.D5_const,l_lcd.D6_const, l_lcd.D7_const, 0, 0, 0, 0)

			if l_handle = -1 then
				print ("LCD Init Failed%N")
			else -- init success
				l_lcd.lcdHome (l_handle)
				l_lcd.lcdClear (l_handle)
				across
					1 |..| 30 as ic
				loop
					l_cpu_string := "CPU Temp: " + cpu_temperature.out + "F"
					print (l_cpu_string + "%N")
					l_lcd.lcdPrint (l_handle, l_cpu_string, 1)

					l_time_string := "Time: " + (create {TIME}.make_now).out
					print (l_time_string + "%N")
					l_lcd.lcdPrint (l_handle, l_time_string, 2)

					Wpi.delayMilliseconds (1_000)
				end
			end
			Wpi.digitalWrite (l_lcd.LED_const, LOW_const) -- turn off LED on LCD backlight
		end

	make_pigpio
			-- Initialization for `Current'.
		local
			l_i2c: PP_I2C
			l_handle: INTEGER
			l_state: INTEGER
			l_lcd: WP_PCF8574_LCD1602A
		do
			create l_i2c
			print ("Starting PIGPIO LCD1602 ...%N")
			l_i2c.initialize_gpio
			if attached l_i2c.last_error as al_error then
				print ("Error: " + al_error.error_msg + "(" + al_error.error_no.out + ")%N")
			else
				print ("Successful intiailization.%NShutting down%N")

					-- open/close handle to 0x27
				l_handle := l_i2c.i2c_open (1, 0x27, 0)
				print ("LCD deviced opened on bus 1 with handle of " + l_handle.out + " with no flags.%N")
				l_state := l_i2c.i2c_close (l_handle)
				print ("LCD deviced closed on handle " + l_handle.out + " with close state of " + l_state.out + "%N")

				l_i2c.terminate_gpio
				print ("GPIO Termination complete.%N")
			end
			print ("End program.%N")
		end

feature -- Access

feature -- Measurement

	cpu_temperature: DECIMAL
			-- Compute the current CPU temperature in Fahrenheit.
		local
			l_temp: DECIMAL
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_read ("/sys/class/thermal/thermal_zone0/temp")
			l_file.read_stream (l_file.count)
			create l_temp.make_from_string (( (l_file.last_string.to_integer / 1000) * (9/5) + 32).out)
			l_file.close

			l_temp := l_temp * 10
			create l_temp.make_from_string (l_temp.to_integer.out)
			create l_temp.make_from_string (l_temp.to_double.out)
			l_temp := l_temp / 10
			Result := l_temp
		end

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
