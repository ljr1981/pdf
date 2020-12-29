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
		local
			l_page_spec: PDF_PAGE_SPEC
		do
			l_page_spec := page_spec_3.twin
			assert_integers_equal ("three_box_specs", 3, l_page_spec.boxes.count)
			assert_integers_equal ("three_widget_specs", 3, l_page_spec.widgets.count)
		end

end


