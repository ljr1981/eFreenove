note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"
	ca_ignore: "CA085" -- Unneeded helper variable "l_app" in general_test is actually needed.

class
	APP_BUTTON_LED_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	general_test
			-- New test routine
		note
			testing: "execution/serial"
			testing: "covers/{APP_BUTTON_LED}"
		local
			l_app: APP_BUTTON_LED
		do
			create l_app
			assert_integers_equal ("blah", 0, l_app.led_pin_0_const)
			l_app.dit_dah_queue.force ('.')
			l_app.dit_dah_queue.force ('.')
			l_app.dit_dah_queue.force ('.')
			assert_characters_equal ("S", 'S', l_app.translate_dit_dah_queue_to_letter)
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


