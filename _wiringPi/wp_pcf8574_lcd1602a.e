note
	description: "Representation of a 2-line LCD Display controlled by a PCF8574 Controller"
	warnings: "[
		There are issues with {WP_LCD} (see its class notes)
		]"

class
	WP_PCF8574_LCD1602A

inherit
	WP_PCF8574

	WP_LCD

	WP_CONSTANTS

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

invariant
	invariant_clause: True -- Your invariant here

end
