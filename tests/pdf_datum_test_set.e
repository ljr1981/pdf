note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_DATUM_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_datum_tests
			-- New test routine
		note
			testing:  "covers/{PDF_DATUM}.make_from_json",
						"covers/{PDF_DATUM}.make",
						"execution/serial"
		local
			l_datum: PDF_DATUM
		do
			create l_datum
			l_datum.do_nothing
			create l_datum.make
			l_datum.do_nothing
		-- Normal json load ...
			create l_datum.make_from_json (datum_json_1)
			assert_32 ("datum_json_1_no_error", not l_datum.has_font_face_error)
			assert_strings_equal ("data_json_good_result", data_json_good_result, l_datum.json_out)
		-- Json load with font_face enum error ...
			create l_datum.make_from_json (datum_json_1_with_error)
			assert_32 ("datum_json_1_with_error", l_datum.has_font_face_error)
			assert_strings_equal ("datum_json_error_result_1", datum_json_error_result, l_datum.json_out)
			check has_error_text: attached l_datum.error_text as al_error_text then
				assert_strings_equal ("datum_json_enum_error_tuple", "[Courier,9,9]", al_error_text)
			end
		-- Json load with font_face empty name error ...
			create l_datum.make_from_json (datum_json_1_with_font_name_error)
			assert_32 ("datum_json_1_with_error", l_datum.has_font_face_error)
			assert_strings_equal ("datum_json_error_result_2", datum_json_error_result, l_datum.json_out)
			check has_error_text: attached l_datum.error_text as al_error_text then
				assert_strings_equal ("datum_json_name_error_tuple", "[,0,0]", al_error_text)
			end
		end

feature {NONE} -- JSON Test Strings

	data_json_good_result: STRING = "[
{"text":"my_text","font_face":["Courier",1,2],"size":10}
]"

	datum_json_error_result: STRING = "[
{"text":"my_text","font_face":null,"size":10}
]"

end


