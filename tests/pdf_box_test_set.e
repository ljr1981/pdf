note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_BOX_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	vbox_test
			-- New test routine
		note
			testing:  "covers/{PDF_REPORT_SPEC}.set_page_specs",
						"covers/{PDF_REPORT_SPEC}.set_name",
						"covers/{PDF_REPORT_SPEC}.json_out",
						"covers/{PDF_REPORT_SPEC}.make_from_json",
						"execution/isolated",
						"execution/serial"
		local
			l_report_spec: PDF_REPORT_SPEC
			l_page_spec: PDF_PAGE_SPEC
		do
				-- These "page_specs" are not the same because they do not have the same purpose.
			assert_strings_not_equal ("page_specs", page_json_with_cell_items, page_spec_json)

			l_page_spec := page_spec_1.twin

			create l_report_spec.make_from_json (report_spec_json_prettified)
			assert_strings_equal ("report_json", report_spec_json, l_report_spec.json_out)

			create l_report_spec
			l_report_spec.set_page_specs (create {ARRAYED_LIST [PDF_PAGE_SPEC]}.make_from_array (<<l_page_spec>>))
			l_report_spec.set_name ("MY_REPORT_1")
			assert_strings_equal ("report_json", report_spec_json, l_report_spec.json_out)
		end

end


