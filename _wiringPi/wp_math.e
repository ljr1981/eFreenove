note
	description: "Abstract notion of Math Operations"
	design: "[
		Various useful math functions related to wiringPi.
		]"

deferred class
	WP_MATH

inherit
	ANY

	WP_CONSTANTS
		undefine
			default_create
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

	milliseconds_to_nanoseconds (a_ms: INTEGER): INTEGER_64
			-- Convert `a_ms' (milliseconds) to nanoseconds.
		note
			EIS: "name=google_search_conversion",
					"src=https://www.google.com/search?ei=U7syX9qwFIfu_QbRz5bwCQ&q=convert+nanoseconds+to+milliseconds&oq=convert+nanoseconds+to+milliseconds&gs_lcp=CgZwc3ktYWIQAzICCAAyAggAMgIIADICCAAyAggAMgIIADICCAAyBAgAEB4yBAgAEB4yBggAEAUQHjoHCAAQRxCwAzoECAAQDToGCAAQDRAeOggIABANEAUQHlCFxghY3MgIYP_MCGgBcAB4AIABjQGIAa4CkgEDMi4xmAEAoAEBqgEHZ3dzLXdpesABAQ&sclient=psy-ab&ved=0ahUKEwiapvHWvZPrAhUHd98KHdGnBZ4Q4dUDCAw&uact=5"
		do
			Result := a_ms * ms_to_ns_multiplier
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

end
