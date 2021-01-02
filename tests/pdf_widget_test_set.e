note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_WIDGET_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_widget_tests
			-- New test routine
		note
			testing:  "covers/{PDF_WIDGET}.make",
						"covers/{PDF_WIDGET}.make_from_json",
						"covers/{PDF_WIDGET}.json_out",
						"covers/{PDF_WIDGET}.has_error",
						"covers/{PDF_WIDGET}.error_message",
						"covers/{PDF_WIDGET}.type",
						"covers/{PDF_WIDGET}.set_type"
		local
			l_widget: PDF_WIDGET
		do
		-- Creations with nothing special ...
			create l_widget
			assert_strings_equal ("default_json_out", default_json_out, l_widget.json_out)
			print (l_widget.error_message)
			assert_32 ("no_error_1", not l_widget.has_error)
			create l_widget.make
			assert_strings_equal ("make_default_json_out", default_json_out, l_widget.json_out)
			assert_32 ("no_error_2", not l_widget.has_error)
			create l_widget.make_from_json (make_from_json_json_out_default)
			assert_strings_equal ("make_from_json_json_out_default", make_from_json_json_out_default, l_widget.json_out)
			assert_32 ("no_error_3", not l_widget.has_error)
		-- Creations with non-default settings ...
			create l_widget.make_from_json (make_from_json_1)
			assert_strings_equal ("make_from_json_1", make_from_json_1, l_widget.json_out)
			assert_32 ("no_error_4", not l_widget.has_error)
		-- Tests errors
			l_widget.set_type ("blah")
			assert_strings_equal ("is_blah", "blah", l_widget.type_attached)
			assert_32 ("has_blah_error", l_widget.has_error)
			assert_strings_equal ("err_msg_1", err_msg_1, l_widget.error_message)
			l_widget.set_type ("label")
			assert_32 ("no_error_5", not l_widget.has_error)
		end

feature {NONE} -- Test support JSON

		-- The json_out should match the default_create
	default_json_out: STRING = "[
{"text":null,"type":null,"widget_id":null,"inside_border_padding":0,"outside_border_padding":0,"minimum_height":0,"minimum_width":0}
]"

		-- The json_out should match the call to make result
	make_from_json_json_out_default: STRING = "[
{"text":null,"type":null,"widget_id":"1","inside_border_padding":0,"outside_border_padding":0,"minimum_height":0,"minimum_width":0}
]"

		-- The json_out should match whatever non-default json was passed in
	make_from_json_1: STRING = "[
{"text":"label_text","type":"label","widget_id":"1","inside_border_padding":3,"outside_border_padding":3,"minimum_height":20,"minimum_width":100}
]"

	err_msg_1: STRING = "[
Type: blah
Text: label_text
WID: 1
min Ht/Wid: 20,100
Padding In/Out: 3,3

]"

end


