note
	description: "Sample Code - Button & LED"
	design: "[
		See Freenove Tutorial Chapter 2 - Button & LED
		
		The goal is to turn the LED on and off using a button.
		
		Compare to ... in the C_code folder of Freenove.
		]"
	ca_ignore: "CA023" 	-- Unneded parenthese - it turns out these parentheses are needed!
						-- attached (create {TIME}.make_now) as al_now (see `turn_on_off')

class
	APP_BUTTON_LED

inherit
	WP_APP_HARNESS

create
	{TEST_SET_SUPPORT} default_create,
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			print ("Program is starting ... %N")
			print ("%NType code for STOP, CTRL+C, or double-click to end%N")
			print ("%N")
			print (morse_alphabet)
			print ("%N")
			print ("%N")

			wpi.pinMode (LED_pin_0_const, OUTPUT_const)			--; //Set ledPin to output
			wpi.pinMode (buttonPin_const, INPUT_const)			--; //Set buttonPin to input

			wpi.pullUpDnControl (buttonPin_const, PUD_UP_const)	--; //pull up to HIGH level

			from
				dit_dah_queue.wipe_out
				letters.wipe_out
			until
				is_stop
			loop
				turn_on_off
			end
		end

feature {NONE} -- Implementation

	has_button_cycled_on_to_off: BOOLEAN
			--
		do
			Result := not is_button_down and then has_duration
		end

	turn_on_off
			-- Turn LED on or off depending on button press.
		do
			if is_turn_LED_on then
				turn_LED_on
			elseif is_turn_LED_off then
				turn_LED_off
			elseif has_button_cycled_on_to_off then
				if is_dit (last_duration) then
					set_dit
				elseif is_dah (last_duration) then
					set_dah
				elseif is_click then
					tap_count := tap_count + 1
				end
				reset_up_down
			end

			if attached last_up_alt as al_up and then
				attached (create {TIME}.make_now) as al_now and then
				last_duration_nano_seconds (al_up, al_now) > (dah * 4)
			then
				last_up_alt := Void
				print (" " + translate_dit_dah_queue_to_letter.out + "%N")
				dit_dah_queue.wipe_out
			end
		end

feature {NONE} -- Button + LED Coordination

	set_dit
			-- set "."
		do
			print (".")
			dit_dah_queue.force ('.')
			reset_tap_count
		end

	set_dah
			-- set "-"
		do
			print ("-")
			dit_dah_queue.force ('-')
			reset_tap_count
		end

	is_turn_led_on: BOOLEAN
			--
		do
			Result := is_button_down and then not attached last_down
		end

	is_turn_led_off: BOOLEAN
			-- Is LED off with proper flags?
		do
			Result := not is_button_down and then attached last_down and then not attached last_up
		end

	is_click: BOOLEAN
			-- Has user "clicked" (fast-button-up-down)
		do
			Result := last_duration < dit
		end

	reset_up_down
			-- Void-out last_down and last_up.
		do
			last_down := Void
			last_up := Void
		end

	reset_tap_count
			--
		do
			tap_count := 0
		end

	tap_count: INTEGER
			-- How many successive `is_click's has user made recently?

	is_button_down: BOOLEAN
			-- From hardware, measue if button pin is LOW, yes?
		do
			Result := wpi.digitalRead (buttonPin_const) = LOW_const
		end

	turn_led_on
			-- Turn the LED on at hardware level and set flags.
		require
			not_down: not attached last_down
			not_up: not attached last_up
		do
			wpi.digitalWrite (LED_pin_0_const, HIGH_const)
			create last_down.make_now
			last_up := Void
		ensure
			down: attached last_down
			not_up: not attached last_up
		end

	turn_led_off
			-- Turn the LED off at hardware level and set flags.
		require
			down: attached last_down
			not_up: not attached last_up
		do
			wpi.digitalWrite (LED_pin_0_const, LOW_const)
			create last_up.make_now
			create last_up_alt.make_now
		ensure
			down: attached last_down
			up: attached last_up
			alt: attached last_up_alt
		end

	has_duration: BOOLEAN
			-- Has both last_down and last_up
		do
			Result := attached last_down and then attached last_up
		end

feature {NONE} -- Morse Code

	-- https://morsecode.world/international/timing.html
	-- dit = 1 unit
	-- dah = 3 units
	-- intra-char space = 1 unit (dit)	(space between dits-and-dahs in char)
	-- inter-char space = 3 units (dah)	(space between chars in a word)
	-- word-space = 7 units (dits)		(space between words in a sentence)

	-- t-dit (time for 1 dit or unit) = 60/50 = 1.2 seconds @ 1 wpm
	-- t-dah = t-dit x 3 = 1.2 x 3 = 3.6 seconds

	-- PARIS = ".--. .- .-. .. .../" = 50 units

	wpm: INTEGER = 10
			-- How many words-per-minute are we calibrating for?

	dit: INTEGER_64
			-- A `dit' (dot) in nanoseconds/milliseconds
			-- dit = 120_000_000 @ 10 wpm
		once
			Result := (1.2 / wpm * One_second_const).truncated_to_integer_64
		end

	dah: INTEGER_64
			-- A 'dah' (dash) in nanoseconds
			-- dah = 360_000_000 @ 10 wpm
		once
			Result := dit * 3
		end

	last_down: detachable TIME
			-- Last time the button was DOWN.

	last_up: detachable TIME
			-- Last time the button was UP.

	last_up_alt: detachable TIME
			-- The last time the button was UP.
			-- Used to determine letter-gaps or char-gapping.

	last_duration: INTEGER_64
			-- Duration in nanoseconds between `last_down' and `last_up'.
		require
			start: attached last_down
			stop: attached last_up
		do
			if attached {TIME} last_up as al_up and then attached {TIME} last_down as al_down then
				Result := last_duration_nano_seconds (al_down, al_up)
			end
		end

	last_duration_nano_seconds (a_start, a_end: TIME): INTEGER_64
		do
			Result := ((a_start.fine_seconds - a_end.fine_seconds) * One_second_const).truncated_to_integer_64.abs
		ensure
			abs: Result >= 0
		end

	is_dit (a_value: like last_duration): BOOLEAN
			-- Is the `a_value' time-duration indicative of a `dit'?
			-- (e.g. between the duration of a dit and a dah?)
		do
			Result := (a_value >= dit) and then (a_value <= dah)
		end

	is_dah (a_value: like last_duration): BOOLEAN
			-- Is the `a_value' time-duration indicative of a `dah'?
			-- (e.g. between the duration of a dah and a (double-dah - dit)?)
		do
			Result := (not is_dit (a_value)) and then (a_value >= dah) and then (a_value < (dah + dah - dit))
		end

	morse_alphabet: STRING = "[
A .- / B -... / C -.-. / D -.. / E . / F ..-. / G --. / H .... / I .. / 
J .--- / K -.- / L .-.. / M -- / N -. / O --- / P .--. / Q  --.- / R.-. /
S ... / T - / U ..- / V ...- / W .-- / X -..- / Y -.-- / Z --..

STOP = ... / - / --- / .--. /
		]"

	dit_dah_queue: ARRAYED_LIST [CHARACTER]
			-- A received list of dits-and-dahs.
		attribute
			create Result.make (100)
		end

	letters: ARRAYED_LIST [CHARACTER]
			-- A list of letters tapped out.
		attribute
			create Result.make (100)
		end

	translate_dit_dah_queue_to_letter: CHARACTER
			-- Translate the dits-and-dahs to a letter (if possible)
		local
			l_dit_dah: STRING
		do
			create l_dit_dah.make_empty
			across
				dit_dah_queue as ic
			loop
				l_dit_dah.append_character (ic.item)
			end
			if l_dit_dah.same_string (".-") then
				Result := 'A'
			elseif l_dit_dah.same_string ("-...") then
				Result := 'B'
			elseif l_dit_dah.same_string ("-.-.") then
				Result := 'C'
			elseif l_dit_dah.same_string ("-..") then
				Result := 'D'
			elseif l_dit_dah.same_string (".") then
				Result := 'E'
			elseif l_dit_dah.same_string (".") then
				Result := 'F'
			elseif l_dit_dah.same_string ("..-.") then
				Result := 'G'
			elseif l_dit_dah.same_string ("--.") then
				Result := 'H'
			elseif l_dit_dah.same_string ("..") then
				Result := 'I'
			elseif l_dit_dah.same_string (".---") then
				Result := 'J'
			elseif l_dit_dah.same_string ("-.-") then
				Result := 'K'
			elseif l_dit_dah.same_string (".-..") then
				Result := 'L'
			elseif l_dit_dah.same_string ("--") then
				Result := 'M'
			elseif l_dit_dah.same_string ("-.") then
				Result := 'N'
			elseif l_dit_dah.same_string ("---") then
				Result := 'O'
			elseif l_dit_dah.same_string (".--.") then
				Result := 'P'
			elseif l_dit_dah.same_string ("--.-") then
				Result := 'Q'
			elseif l_dit_dah.same_string (".-.") then
				Result := 'R'
			elseif l_dit_dah.same_string ("...") then
				Result := 'S'
			elseif l_dit_dah.same_string ("-") then
				Result := 'T'
			elseif l_dit_dah.same_string ("..-") then
				Result := 'U'
			elseif l_dit_dah.same_string ("...-") then
				Result := 'V'
			elseif l_dit_dah.same_string (".--") then
				Result := 'W'
			elseif l_dit_dah.same_string ("-..-") then
				Result := 'X'
			elseif l_dit_dah.same_string ("-.--") then
				Result := 'Y'
			elseif l_dit_dah.same_string ("--..") then
				Result := 'Z'
			else
				Result := '?'
			end
		end

	is_double_click: BOOLEAN
		do
			Result := tap_count >= 2
		end

	is_stop: BOOLEAN
			-- Do we have a STOP?
		local
			l_stop: STRING
		do
			if letters.count <= 4 then
				Result := False
			else
				create l_stop.make (4)
				l_stop.append_character (letters [letters.count - 3])
				l_stop.append_character (letters [letters.count - 2])
				l_stop.append_character (letters [letters.count - 1])
				l_stop.append_character (letters [letters.count])
				Result := l_stop.same_string ("STOP")
			end
			Result := Result or else is_double_click
		end

note
	analysis_notes: "[
		Take note of the "Analyze" tool in the Eiffel Studio toolbar.
		This tool is a code analyzer, which works very well. However,
		it does tend to get a little strict, so we use "ca_ignore" note
		clauses (see top of class) to turn off analysis assertions
		on a class-by-class basis. I tend to leave comments on each
		"ignore" so that the reader is not left to wonder why.
		]"

end
