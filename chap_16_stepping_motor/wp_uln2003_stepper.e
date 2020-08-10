note
	description: "Abstract notion of a ULN2003 Stepper Motor"

deferred class
	WP_ULN2003_STEPPER

inherit
	WP_STEPPER_MOTOR

feature -- Constants

	motor_pins: ARRAY [INTEGER]
			-- Define pins connected to four phase ABCD of stepper
		once
			Result := <<1, 4, 5, 6>>
		end

	counter_clockwise_step: ARRAY [INTEGER]
			--<Precursor>
		once
			Result := <<0x01, 0x02, 0x04, 0x08>>
		end

	clockwise_step: ARRAY [INTEGER]
			--<Precursor>
		once
			Result := <<0x08, 0x04, 0x02, 0x01>>
		end


end
