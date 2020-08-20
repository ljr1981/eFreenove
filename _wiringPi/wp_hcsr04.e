note
	description: "Representation of an HC-SR04 Ultrasonic Ranging Module"
	EIS: "name=specification_1", "src=https://www.electroschematics.com/wp-content/uploads/2013/07/HCSR04-datasheet-version-1.pdf"
	EIS: "name=specification_2", "src=https://www.electroschematics.com/wp-content/uploads/2013/07/HC-SR04-datasheet-version-2.pdf"

class
	WP_HCSR04

inherit
	WP_BASE
		redefine
			default_create
		end

	WP_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			--<Precursor>
			-- Set pin modes
		do
			Precursor {WP_BASE}
			set_pin_modes
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

	getSonar: REAL
			-- Get distance to current "target" in fractional centimeters (cm).
		do
			Result := dht_getSonar (EchoPin_const, TrigPin_const, Timeout_const)
		end

feature -- Constants

	TrigPin_const: INTEGER = 4

	EchoPin_const: INTEGER = 5

	MAX_DISTANCE_const: INTEGER = 220

	Timeout_const: INTEGER
			--
		once
			Result := MAX_DISTANCE_const * 60
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation: Status Report

	pulseIn (a_pin, a_level, a_timeout: INTEGER): INTEGER
			-- Compute ranging-pulse IN from device.
		external
			"C inline use <wiringPi.h>"
		alias
			"[
			#include <sys/time.h>
			{
			   struct timeval tn, t0, t1;
			   long micros;
			   gettimeofday(&t0, NULL);
			   micros = 0;
			   
			   int pin = $a_pin;
			   int level = $a_level;
			   int timeout = $a_timeout;
			   
			   while (digitalRead(pin) != level)
			   {
			      gettimeofday(&tn, NULL);
			      if (tn.tv_sec > t0.tv_sec) micros = 1000000L; else micros = 0;
			      micros += (tn.tv_usec - t0.tv_usec);
			      if (micros > timeout) return 0;
			   }
			   gettimeofday(&t1, NULL);
			   while (digitalRead(pin) == level)
			   {
			      gettimeofday(&tn, NULL);
			      if (tn.tv_sec > t0.tv_sec) micros = 1000000L; else micros = 0;
			      micros = micros + (tn.tv_usec - t0.tv_usec);
			      if (micros > timeout) return 0;
			   }
			   if (tn.tv_sec > t1.tv_sec) micros = 1000000L; else micros = 0;
			   micros = micros + (tn.tv_usec - t1.tv_usec);
			   return micros;
			}
			]"
		end

feature {NONE} -- Implementation: Settings

	set_pin_modes
			-- Setup pin modes.
		do
			pinmode (TrigPin_const, pin_mode_OUTPUT_const)
			pinmode (EchoPin_const, pin_mode_INPUT_const)
		end

	dht_getSonar (a_echoPin, a_trigPin, a_timeout: INTEGER): REAL
			-- Get the measurement result of ultrasonic module with unit: cm
		local
			l_pingTime, l_distance: REAL
		do
			digitalWrite (a_trigPin, HIGH_const) -- send 10 μs HIGH level to trigPin
			delayMicroseconds (10) -- μs
			digitalWrite (a_trigPin, LOW_const) -- then lower it.

			l_pingTime := pulseIn (a_echoPin, HIGH_const, a_timeout) -- Read pulse-time of `a_echoPin'
			l_distance := l_pingTime * 340.0 / 2.0 / 10000.0 -- Calculate distance with sound speed 340m/s

			Result := l_distance
		end

end
