note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_DATUM_GROUP_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_datum_group_tests
			-- New test routine
		note
			testing:  "covers/{PDF_DATUM_GROUP}.make_from_json",
						"covers/{PDF_DATUM_GROUP}.make",
						"execution/isolated",
						"execution/serial"
		local
			l_group: PDF_DATUM_GROUP
		do
			create l_group
			assert_strings_equal ("default_create_json_out", default_create_json_out, l_group.json_out)
			create l_group.make
			assert_strings_equal ("make_json_out", make_json_out, l_group.json_out)
			create l_group.make_from_json (data_group_json_1)
			assert_strings_equal ("make_from_json_json_out", make_from_json_json_out, l_group.json_out)
		end

feature {NONE} -- Implementation: Test Support

	default_create_json_out: STRING = "[
{"page_spec_name":null,"datums":null}
]"

	make_json_out: STRING = "[
{"page_spec_name":null,"datums":null}
]"

	make_from_json_json_out: STRING = "[
{"page_spec_name":"page_spec_1","datums":[{"text":"my_text","font_face":["Courier",1,2],"widget_id":null,"size":10}]}
]"

end


