note
	description: "WP_PCF8574 Wrapper of pcf8574.h"

deferred class
	WP_PCF8574

inherit
	ANY

	WP_CONSTANTS

feature -- Initialization

	setup
			-- Perform setup of PCF8574 Controller.
		do
			print ("pcf8574Setup (" + BASE_const.out + ", " + pcf8574_address_const.out + ")%N")
			pcf8574Setup (BASE_const, pcf8574_address_const)
		end

feature {NONE} -- Implementation: Intitialization

	pcf8574Setup (a_pin_base, a_i2c_address: INTEGER)
			--
		external
			"C inline use <pcf8574.h>"
		alias
			"[
				pcf8574Setup ($a_pin_base, $a_i2c_address);
				]"
		end

feature -- Constants

	pcf8574_address_const: INTEGER
			-- I2C address constant as hex (integer) value
		note
			setup: "[
				The RPi4B I2C interface is disabled by default. Ensure
				you have it enabled and installed first. 
				
				STEP #1: Use the:
				
					sudo raspi-config
					
					to access the RPi4B Configuration Tool and select option
					
					#5 Interfacing Options (Configure connections to peripher) -> P5 I2C -> Yes -> Yes
					
					Then restart your Rpi4B for enabling to be set.
				
				STEP #2: Check proper enabling, using the:
				
					lsmod | grep i2c
					
					If the I2C module has been started, you will see a list of items like:
					
					i2c_bcm2708		4770	0
					i2c_dev			5859	0
					
					Where "bcm" stands for Broadcom CPU Model. For example, on the machine
					this code was built on, the lsmod piped to grep i2c returned:
					
					i2c_bcm2835            16384  0
					i2c_dev                16384  0
					
				STEP #3: Get I2C tools using the following command:
				
				sudo apt-get install i2c-tools
				
				STEP #4: Inspect what I2C devices are present by address (see below):
				
				i2cdetect -y 1
				
				Resulting in:
				
				    0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
				00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
				10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
				20: -- -- -- -- -- -- -- 27 -- -- -- -- -- -- -- -- 
				30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
				40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
				50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
				60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
				70: -- -- -- -- -- -- -- --				
				
				FUN FACT: The above result was obtained with a PCF8574 controller
				attached to a 1602A LCD 2-line display until. Therefore, this
				is why the Result is presently set to 0x27 hex. The
				alternate value (shown) is per the Freenove Tutorial documentation
				which states that the PCF8574A address will show up at 0x37
				]"
		once
			Result := 0x27 -- Alternate = 0x3F
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

invariant
	invariant_clause: True -- Your invariant here

end
