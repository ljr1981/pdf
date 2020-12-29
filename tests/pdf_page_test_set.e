note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_PAGE_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	page_prep_cell_tests
			-- Test the `cell_prep' feature on {PDF_PAGE}.
		note
			testing:  "covers/{PDF_PAGE}.prep_cell",
						"covers/{PDF_PAGE}.cell",
						"covers/{PDF_PAGE}.box_ref_attached",
						"covers/{PDF_PAGE}.box_ref",
						"covers/{PDF_PAGE}.box_name",
						"covers/{PDF_WRITER}.make",
						"covers/{PDF_WRITER}.first_cr_page",
						"covers/{PDF_WRITER}.destroy",
						"execution/isolated",
						"execution/serial"
		local
			l_writer: PDF_WRITER
			l_page: PDF_PAGE
		-- testing locals
			l_child_box,
			l_parent_box: EV_BOX
		do
		-- prep for page
			create l_writer.make ("page_prep_cell_test.pdf", us_8_by_11_page_height, us_8_by_11_page_width)
			create l_writer.make_from_json (report_spec_3.json_out)
			l_writer.first_cr_page
		-- grab first page
			l_page := l_writer.current_cr_page_attached
		-- start testing page
			l_parent_box := l_page.cell
			l_child_box := l_page.box_ref_attached (l_parent_box, "mbox")
			assert_strings_equal ("mbox", "mbox", l_page.box_name (l_child_box))
		-- prove mbox has midbox
			l_parent_box := l_page.box_ref_attached (Void, "mbox")
			l_child_box := l_page.box_ref_attached (l_parent_box, "midbox")
			assert_strings_equal ("midbox", "midbox", l_page.box_name (l_child_box))
		-- finish things off ...
			l_writer.destroy
		end

	page_prep_cell_tests_with_box_specs
			-- Test creation of a {PDF_PAGE} with `boxes'
		note
			testing:  "covers/{PDF_PAGE}.prep_cell",
						"covers/{PDF_WRITER}.make",
						"covers/{PDF_WRITER}.first_cr_page",
						"covers/{PDF_WRITER}.destroy",
						"execution/isolated",
						"execution/serial"
		local
			l_writer: PDF_WRITER
			l_page: PDF_PAGE
		do
		-- prep for page
			create l_writer.make_from_json (report_spec_3.json_out)
			l_writer.first_cr_page
		-- grab first page
			l_page := l_writer.current_cr_page_attached
			assert_integers_equal ("has_3_boxes", 3, l_page.boxes.count)
			assert_integers_equal ("has_3_widgets", 3, l_page.widgets.count)
		-- does the prep_cell result in boxes from page-spec?

		end

end


