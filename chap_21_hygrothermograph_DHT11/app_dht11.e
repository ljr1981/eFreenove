note
	description: "DHT11 Temp/Humidity Sensor Application"

class
	APP_DHT11

inherit
	WP_APP_HARNESS

create
	make

feature {NONE} -- Initialization

	make
			-- An application to record 100 humidity/temp measurements.
		local
			l_dht: WP_DHT11
			l_env: EXECUTION_ENVIRONMENT
			l_file: PLAIN_TEXT_FILE
			l_datetime: DATE_TIME
		do
			create l_dht
			create l_env
			create l_file.make_create_read_write ("dht11_data.txt")

			across
				1 |..| 100 as ic
			loop
				create l_datetime.make_now
				if l_dht.is_sensor_okay then
					print ("Humidity is: " + l_dht.humidity.out + "%N")
					print ("Temperature is: " + l_dht.temperature_fahrenheit.out + "F%N")
					l_file.put_new_line
					l_file.put_string ("DT: " + l_datetime.out + "%TH: " + l_dht.humidity.out + "%T T(f):" + l_dht.temperature_fahrenheit.out)
				else
					print ("Sensor status: " + l_dht.sensor_status + "%N")
					l_file.put_new_line
					l_file.put_string ("DT: " + l_datetime.out + "%TSensor status: " + l_dht.sensor_status)
				end
				if not ic.is_last then
					l_env.sleep (One_second_const * 5)
				end
			end

			l_file.close
		end

end
