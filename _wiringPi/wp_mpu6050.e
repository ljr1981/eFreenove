note
	description: "Reprentations of an MPU6050 Attitude Sensor"
	purpose: "[
		The MPU6050 is a general purpose attitude sensor, sensing
		change of axis (x,Y,Z) and acceleration. General uses
		include robotics like quad-copter drones, where the chip
		is used to maintain level flight and attitude control.
		]"
	EIS: "name=mpu6050_specifications",
			"src=https://components101.com/sensors/mpu6050-module"

class
	WP_MPU6050

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Initialize and test connection.
		do
			Precursor
			accelgyro_initialize (accelgyro)
		end

feature -- Access

feature -- Measurement

feature -- Status report

	is_good_connection: BOOLEAN
			-- Do we have good connection to MPU6050?
		do
			Result := accelgyro_test_connection (Accelgyro)
		end

	read_motion_buffer: TUPLE [ax, ay, az, gx, gy, gz: INTEGER_16]
			-- Read buffered acceleration and attitude on XYZ-axis data.
		local
			l_ax, l_ay, l_az, l_gx, l_gy, l_gz: INTEGER_16
		do
			accelgyro_getmotion6 (Accelgyro, $l_ax, $l_ay, $l_az, $l_gx, $l_gy, $l_gz)
			Result := [l_ax, l_ay, l_az, l_gx, l_gy, l_gz]
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

	accelgyro: POINTER
			-- Once'd access to a `new_MPU6050'.
		once
			Result := new_MPU6050
		end

feature {NONE} -- Implementation: Initialization

	new_MPU6050: POINTER
			-- Create a new MPU6050 controller object.
		external
			"C++ inline use <MPU6050.h>"
		alias
			"[
			return new MPU6050 ();
			]"
		end

	accelgyro_initialize (a_object: POINTER)
			-- Initialize the MPU6050.
		external
			"C++ inline use <MPU6050.h>"
		alias
			"((MPU6050 *)$a_object)->initialize()"
		end

feature {NONE} -- Implementation: Status Report

	accelgyro_test_connection (a_object: POINTER): BOOLEAN
			-- True if the MPU6050 connection is good.
		external
			"C++ inline use <MPU6050.h>"
		alias
			"((MPU6050 *)$a_object)->testConnection()"
		end

feature {NONE} -- Implementation: Basic Operations

	accelgyro_getmotion6 (a_object: POINTER; ax, ay, az, gx, gy, gz: TYPED_POINTER [INTEGER_16])
			-- Get six motion measurements (XYZ for accelleration and attitude).
		external
			"C++ inline use <MPU6050.h>"
		alias
			"[
				((MPU6050 *)$a_object)->getMotion6($ax, $ay, $az, $gx, $gy, $gz);
				]"
		end

end
