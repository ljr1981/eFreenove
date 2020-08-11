note
	description: "Abstract notion of an Application Harness for WPi applications"
	design: "[
		The goal is to hook the WiringPi C API to a Root Application
		in such a way that it is properly initialized and ready, but
		only one time per application.
		
		We defer this class to force Clients into inheritance rather
		than the "has-a" object-model.
		]"

deferred class
	WP_APP_HARNESS

inherit
	ANY

	WP_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Implementation

	Wpi: WP_BASE
			-- Access to Wrapped C API WiringPi features.
		note
			design: "[
				This feature is once'd because we always want
				to ensure the wiringPi C API is always initialized 
				before it is used. See `default_create' of {WP_BASE}.
				]"
		once
			create Result
		end

end
