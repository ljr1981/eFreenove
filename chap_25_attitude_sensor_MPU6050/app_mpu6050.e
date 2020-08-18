note
	description: "Access and read an MPU6050 Attitude Sensor."

class
	APP_MPU6050

inherit
	WP_APP_HARNESS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			l_mpu: WP_MPU6050
			l_readings: TUPLE [ax, ay, az, gx, gy, gz: INTEGER_16]
		do
			default_create
			create l_mpu
			if l_mpu.is_good_connection then
				print ("MPU6050 connection successful%N")
			else
				print ("MPU6050 connection failed%N")
			end
			across
				1 |..| 10 as ic
			loop
				l_readings := l_mpu.read_motion_buffer
				print ("a/g: " + l_readings.ax.out + ", " + l_readings.ay.out + ", " + l_readings.az.out + " | " + l_readings.gx.out + ", " + l_readings.gy.out + ", " + l_readings.gz.out + "%N" )
			end
		end

feature -- Access

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

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

end
