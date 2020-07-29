note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TESTING_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_of_autotest
			-- New test routine
		do
			assert ("not_implemented", False)
		end

end


