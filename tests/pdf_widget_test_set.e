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
			testing:  "covers/{PDF_WIDGET}",
						"covers/{PDF_WIDGET}.make",
						"covers/{PDF_WIDGET}.make_from_json"
		local
			l_widget: PDF_WIDGET
		do
			create l_widget
			create l_widget.make
		end

end


