note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_BOX_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	vbox_test
			-- New test routine
		note
			testing:  "covers/{PDF_VERTICAL_BOX}.make_from_json", "execution/isolated", "execution/serial"
		local
			l_report: PDF_REPORT_SPEC
			l_page: PDF_PAGE_SPEC
			l_box: PDF_VERTICAL_BOX
			l_text: PDF_TEXT_WIDGET
		do
			l_page := page_spec_1.twin
			l_page.extend (create {PDF_VERTICAL_BOX})
			create l_text
			l_text.set_text ("TEST_TEXT_FOR_TEXT_WIDGET")
			l_page.cell.extend (l_text)
			assert_32 ("box_has_text", l_page.cell.sub_items.has (l_text))
			assert_32 ("box_weak_reference_parent_on_text", attached l_text.parent as al_parent and then al_parent.item ~ l_page.cell)
			assert_strings_equal ("page_json", page_json, l_page.json_out)

--			create l_report.make_from_json (l_page.json_out)
			create l_report
			l_report.set_page_specs (create {ARRAYED_LIST [PDF_PAGE_SPEC]}.make_from_array (<<l_page>>))
			l_report.set_name ("MY_REPORT_1")
			assert_strings_equal ("report_json", report_json, l_report.json_out)
		end

end


