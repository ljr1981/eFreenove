note
	description: "Reprentations of an MPU6050 Attitude Sensor"
	purpose: "[
		The MPU6050 is a general purpose attitude sensor, sensing
		change of axis (x,Y,Z) and acceleration. General uses
		include robotics like quad-copter drones, where the chip
		is used to maintain level flight and attitude control.
		]"

class
	WP_MPU6050

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize and test connection.
		do
			accelgyro_initialize (accelgyro)
			if accelgyro_test_connection (accelgyro) then
				print ("MPU6050 connection successful%N")
			else
				print ("MPU6050 connection failed%N")
			end
		end

feature -- Access

	accelgyro: POINTER
			-- Once'd access to a `new_MPU6050'.
		once
			Result := new_MPU6050
		end

	new_MPU6050: POINTER
			-- Create a new MPU6050 controller object.
		external
			"C++ inline use <MPU6050.h>"
		alias
			"[
			return new MPU6050 ();
			]"
		end

feature -- Measurement

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

	accelgyro_initialize (a_object: POINTER)
			-- Initialize the MPU6050.
		external
			"C++ inline use <MPU6050.h>"
		alias
			"((MPU6050 *)$a_object)->initialize()"
		end

	accelgyro_test_connection (a_object: POINTER): BOOLEAN
			-- True if the MPU6050 connection is good.
		external
			"C++ inline use <MPU6050.h>"
		alias
			"((MPU6050 *)$a_object)->testConnection()"
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

end
