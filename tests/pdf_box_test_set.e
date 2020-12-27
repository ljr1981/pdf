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
		do
				-- These "page_specs" are not the same because they do not have the same purpose.
			assert_strings_not_equal ("page_specs", page_json_with_cell_items, page_spec_json)

			l_page := page_spec_1.twin
			l_page.cell.extend (create {EV_VERTICAL_BOX})
			l_page.cell.extend (create {EV_TEXT_FIELD}.make_with_text ("TEST_TEXT_FOR_TEXT_WIDGET"))

			create l_report.make_from_json (report_spec_json_prettified)
			assert_strings_equal ("report_json", report_spec_json, l_report.json_out)

			create l_report
			l_report.set_page_specs (create {ARRAYED_LIST [PDF_PAGE_SPEC]}.make_from_array (<<l_page>>))
			l_report.set_name ("MY_REPORT_1")
			assert_strings_equal ("report_json", report_spec_json, l_report.json_out)
		end

end


