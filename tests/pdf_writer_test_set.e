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
			testing:  "covers/{PDF_WRITER}",
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

		-- Load {PDF_REPORT_SPEC} specification
			create l_writer.make_from_json (report_spec_2.json_out)
			assert_32 ("has_report_spec", attached l_writer.report_spec)
			assert_integers_equal ("has_two_page_specs", 2, l_writer.report_spec_attached.page_specs.count)
			check attached l_writer.report_spec_attached.page_specs [1] as al_page_spec_1 then
				assert_strings_equal ("page_spec_1_name", "page_spec_1", al_page_spec_1.name)
			end

			l_writer.load_data (report_spec_1_data_json)
			assert_integers_equal ("three_datum", 3, l_writer.last_data_json_object_attached.count)
			if attached l_writer.last_data_json_object_attached.item (create {JSON_STRING}.make_from_string ("d1")) as al_value then
				assert_strings_equal ("d1_json", "[{%"box%":%"my_box_1%"},{%"widget%":%"my_widget_1%"},%"TEXT1%"]", al_value.representation)
			end
		end

end


