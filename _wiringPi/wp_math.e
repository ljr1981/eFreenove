note
	description: "Abstract Math Operations"

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

	microseconds_to_nanoseconds (a_ms: INTEGER): INTEGER_64
			-- 1_000ns = 1ms?
			-- ms = 1M/second (1_000_000)
			-- ns = 1B/second (1_000_000_000)
			-- ns/ms = 1_000_000_000 / 1_000_000 = 1_000
		do
			Result := a_ms * ms_to_ns_multiplier
		end

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
