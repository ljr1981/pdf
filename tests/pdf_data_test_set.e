note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_DATA_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_data_tests
			-- New test routine
		note
			testing:  "covers/{PDF_DATA}.make_from_json",
						"execution/serial"
		local
			l_data: PDF_DATA
		do
			create l_data
			create l_data.make
		end

end


