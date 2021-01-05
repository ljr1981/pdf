note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_BOX_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_box_tests
			-- PDF_BOX Tests
		note

		local
			l_box: PDF_BOX
		do
		-- Quickly demo that empty-creations cause no JSON-related errors.
			create l_box
			assert_32 ("no_error_default_create", not l_box.has_json_input_error)
			assert_strings_equal ("default_create_json_result", default_create_json_result, l_box.json_out)
			create l_box.make
			assert_32 ("no_error_make", not l_box.has_json_input_error)
			assert_strings_equal ("make_json_result", make_json_result, l_box.json_out)
		-- Demo that a 3-box JSON spec causes no JSON-related errors.
			create l_box.make_from_json (box_json_1)
			assert_32 ("no_error_make_from_json", not l_box.has_json_input_error)
			assert_strings_equal ("make_with_json_json_result", make_with_json_json_result, l_box.json_out)
		end

feature {NONE} -- PDF_BOX Test Support

	default_create_json_result: STRING = "[
{"name":null,"parent":null,"type":null,"layout":null}
]"

	make_json_result: STRING = "[
{"name":null,"parent":null,"type":null,"layout":null}
]"

	make_with_json_json_result: STRING = "[
{"name":"my_box_1","parent":null,"type":"vertical","layout":{"minimum_size":0}}
]"

end


