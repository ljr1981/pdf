note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_WRITER_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_writer_tests
			-- Tests of the {PDF_WRITER}.
		note
			testing:  "covers/{PDF_WRITER}.make_from_json",
						"covers/{PDF_WRITER}.load_data",
						"execution/isolated",
						"execution/serial"
		local
			l_writer: PDF_WRITER
		do
		-- Create an empty report writer w/destroy --> ??? PDF document
			create l_writer
			l_writer.destroy

		-- Create an empty report writer w/dispose --> ??? PDF document
			create l_writer
			l_writer.dispose

		-- Create an empty "named" report writer w/destroy --> "pdf_writer_tests.pdf" document
			create l_writer.make ("pdf_writer_tests.pdf", us_8_by_11_page_height, us_8_by_11_page_width)
			l_writer.destroy

		-- Create with a {PDF_REPORT_SPEC} specification
			create l_writer.make_from_json (report_spec_3.json_out)
			assert_32 ("has_report_spec", attached l_writer.report_spec)
			assert_integers_equal ("has_one_page_specs", 1, l_writer.report_spec_attached.page_specs.count)
			check attached l_writer.report_spec_attached.page_specs [1] as al_page_spec_3 then
				assert_strings_equal ("page_spec_3_name", "page_spec_3", al_page_spec_3.name)
				assert_32 ("cbox", attached l_writer.current_cr_page_attached.box_ref (Void, "cbox"))
				assert_32 ("cboxes_equal", l_writer.current_cr_page_attached.cbox ~ l_writer.current_cr_page_attached.box_ref_attached (Void, "cbox"))
				assert_32 ("has_my_box_1", attached l_writer.current_cr_page_attached.box_ref (Void, "my_box_1"))
				assert_32 ("has_my_box_2", attached l_writer.current_cr_page_attached.box_ref (Void, "my_box_2"))
				assert_32 ("has_my_box_3", attached l_writer.current_cr_page_attached.box_ref (Void, "my_box_3"))
			end
			assert_integers_equal ("has_1_page_templates", 1, l_writer.page_templates.count)

		-- Load report data from json
			l_writer.load_pdf_data (data_json_1)

			assert_32 ("not_has_json_input_error", not l_writer.has_json_input_error)
		end

end


