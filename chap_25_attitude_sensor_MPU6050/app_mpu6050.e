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
			lax, lay, laz, lgx, lgy, lgz: INTEGER_16
		do
			default_create
			create l_mpu.make
			across
				1 |..| 10 as ic
			loop
				l_mpu.accelgyro_getmotion6 (l_mpu.accelgyro, $lax, $lay, $laz, $lgx, $lgy, $lgz)
				print ("a/g: " + lax.out + ", " + lay.out + ", " + laz.out + " | " + lgx.out + ", " + lgy.out + ", " + lgz.out + "%N" )
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
