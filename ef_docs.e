note
	description: "General Documentation"
	EIS: "name=freenove_ultimate_starter_kit",
			"src=https://www.amazon.com/gp/product/B06W54L7B5/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1"
	EIS: "name=vilros_raspberry_pi_kit",
			"src=https://www.amazon.com/gp/product/B07TKFFCF1/ref=ppx_yo_dt_b_asin_title_o04_s01?ie=UTF8&psc=1"

deferred class
	EF_DOCS

note
	gpio_expander: "[
		The RPi4B GPIO is severely limited in the number of devices that
		can be directly controlled. What is needed and wanted is a item
		called a GPIO Expander (or Extender, depending on your venacular).
		
		The EIS links (following) are for reference purposes. However, if
		certain questions (currently asked) are answered in the affirmative,
		then the selection will be narrowed to a device like the UniPi.
		]"
	EIS: "name=unipi_1", "src=https://www.unipi.technology/unipi-1-1-p36"
	unipi_1_notations: "[
		The most outstanding question is: Does the UniPi 1 have a C/C++ API?
		
		Presently, the documentation and sales literature points at several
		downstream programming SDK APIs, but so far, nothing that points
		directly at C/C++. As we are wrapping C/C++ in Eiffel, we really do
		want a pure C (or C++) API to wrap (preferrably simple C). However,
		with that stated--there are other interesting aspects to the
		downstream SDK API's such as TCP-based and cURL-based. The cURL is
		of particular interest because we have an Eiffel-baed cURL wrapping
		library already, which can be used to directly talk to the cURL-based
		API (EVOK in particular). The TCP is also of interest for a similar
		reason (i.e. we have an Eiffel-based TCP library as well).
		]"
	unipi_1_20200827: "[
		WiringPi is deprecated as of 2019 and will someday break. The EVOK SDK
		(see above) is based on PIGPIO (i.e. pi-GPIO or "pig-pio"), which
		appears to be lower-level that WiringPi. So, ultimately, the code
		must rest on PIGPIO, but for now, WiringPi will do for experimentation.
		It might even be useful for production work as long as we're fixed
		on RPi4B or older equipment. The danger will be upgrades to the RPi
		hardware that create breaking changes to the deprecated WiringPi library.
		]"

end
