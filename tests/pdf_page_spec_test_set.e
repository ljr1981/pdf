note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_PAGE_SPEC_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	page_spec_box_and_widget_spec_tests
			-- Test of box and widget specifications being loaded.
		note
			testing:  "covers/{PDF_PAGE_SPEC}.default_create",
						"covers/{PDF_TEST_SET_SUPPORT}.page_spec_3",
						"covers/{PDF_TEST_SET_SUPPORT}.page_spec_3_json",
						"execution/isolated",
						"execution/serial"
		do
			assert_integers_equal ("three_box_specs", 3, page_spec_3.boxes.count)
		end

end


