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

	text_widget_tests
			-- New test routine
		note
			testing:  "covers/{PDF_TEXT_WIDGET}.text", "covers/{PDF_TEXT_WIDGET}.convertible_features",
			          "covers/{PDF_TEXT_WIDGET}.set_text", "execution/isolated",
			          "covers/{PDF_TEXT_WIDGET}.make_from_json", "execution/serial"
		local
			l_widget: PDF_TEXT_WIDGET
		do
			create l_widget
			assert_strings_equal ("text_widget_default_json", text_widget_default_json, l_widget.json_out)
		end

end


