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
			testing:  "covers/{PDF_DATA}.default_create",
						"covers/{PDF_DATA}.make",
						"covers/{PDF_DATA}.make_from_json",
						"execution/serial"
		local
			l_data: PDF_DATA
		do
			create l_data.default_create
			create l_data.make
			create l_data.make_from_json (empty_data_json)
			create l_data.make_from_json (data_json_1)
			assert_integers_equal ("one_widget", 1, l_data.widgets.count)
			assert_integers_equal ("two_datum", 2, l_data.data.count)
			assert_strings_equal ("my_text_1", "my_text_1", l_data.data [1].text)
			assert_strings_equal ("my_text_2", "my_text_2", l_data.data [2].text)
		end

end


