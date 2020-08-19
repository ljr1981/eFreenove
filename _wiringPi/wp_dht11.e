note
	description: "Representation of a DHT11 Sensor Reader"
	EIS: "name=specifications", "protocol=pdf",
			"src=https://components101.com/sites/default/files/component_datasheet/DHT11-Temperature-Sensor.pdf"

class
	WP_DHT11

inherit
	WP_BASE

	WP_CONSTANTS
		undefine
			default_create
		end

feature -- Access

feature -- Measurement

	temperature: REAL_64
			-- What is the temperature measurement?
			-- Celcius (Centigrade).
		do
			Result := dht_temperature (dht)
		end

	temperature_fahrenheit: REAL_64
			-- What is the temperature measurement?
			-- Fahrenheit.
		do
			Result := temperature * (9/5) + 32
		end

	humidity: REAL_64
			-- What is the humidity measurement?
		do
			Result := dht_humidity (dht)
		end

feature -- Status report

	is_sensor_okay: BOOLEAN
			-- Is the sensor okay?
		do
			last_sensor_status_value := dht_readdht11 (dht, DHT11_pin)
			Result := last_sensor_status_value = DHTLIB_OK_const
		end

	sensor_status: STRING
			-- What is the status of the `dht' sensor?
		do
			inspect
				last_sensor_status_value
			when 0 then
				Result := "OKAY"
			when -1 then
				Result := "ERROR CHECKSUM"
			when -2 then
				Result := "ERROR TIMEOUT"
			when -999 then
				Result := "INVALID VALUE"
			else
				Result := "UNKNOWN"
			end
		end

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

feature {NONE} -- Implementation: Access

	dht: POINTER
			-- A DHT11 Sensor Object.
		once
			Result := new_dht
		end

	last_sensor_status_value: INTEGER
			-- The last return value of the DHT11 sensor.

feature {NONE} -- Implementation: Constants

	DHT11_pin: INTEGER = 0
			-- The DHT11 sensor pin to read from.

	DHTLIB_OK_const: INTEGER = 0
	DHTLIB_ERROR_CHECKSUM_const: INTEGER = -1
	DHTLIB_ERROR_TIMEOUT_const: INTEGER = -2
	DHTLIB_INVALID_VALUE_const: INTEGER = -999


feature {NONE} -- Implementation: Initialization

	new_dht: POINTER
			-- Create a new DHT object.
		external
			"C++ inline use <DHT.hpp>"
		alias
			"[
			return new DHT
			]"
		end

feature {NONE} -- Implementation: Status Report

	dht_readDHT11 (a_object: like dht; a_pin: like DHT11_pin): INTEGER
			-- Read the DHT11 to ensure working properly.
		external
			"C++ inline use <DHT.hpp>"
		alias
			"[
			return ((DHT *)$a_object)->readDHT11($a_pin)
			]"
		end

	dht_temperature (a_object: like dht): REAL_64
			-- Read temperature from DHT11.
		external
			"C++ inline use <DHT.hpp>"
		alias
			"[
			return ((DHT *)$a_object)->temperature
			]"
		end

	dht_humidity (a_object: like dht): REAL_64
			-- Read humidity from DHT11.
		external
			"C++ inline use <DHT.hpp>"
		alias
			"[
			return ((DHT *)$a_object)->humidity
			]"
		end

end
