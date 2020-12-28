note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_PAGE_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	page_tests
			-- New test routine
		note
			testing:  "covers/{PDF_PAGE}.make_from_page_spec",
						"execution/isolated",
						"execution/serial"
		local
			l_factory: PDF_FACTORY
			l_page: PDF_PAGE
		-- testing locals
			l_child_box,
			l_parent_box: EV_BOX
		do
		-- prep for page
			create l_factory
			l_page := l_factory.page
			l_page.prep_cell
		-- start testing page
			l_parent_box := l_page.cell
			l_child_box := l_page.box_ref_attached (l_parent_box, "mbox")
			assert_strings_equal ("mbox", "mbox", l_page.box_name (l_child_box))
		-- prove mbox has midbox
			l_parent_box := l_page.box_ref_attached (Void, "mbox")
			l_child_box := l_page.box_ref_attached (l_parent_box, "midbox")
			assert_strings_equal ("midbox", "midbox", l_page.box_name (l_child_box))
		end

end


