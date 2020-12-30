note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_DOC_EXAMPLES

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_writer_example_1
			-- Example of a basic PDF_WRITER being used.
		note
			testing:  "covers/{PDF_WRITER}.make_from_json",
						"covers/{PDF_WRITER}.load_data",
			          	"execution/isolated", "execution/serial"
			description: "[
				We want to show how to use a PDF_WRITER to print a report.
				We create our writer with a report specification which specifies
				overall report specs and specifications for each type of page
				in the report (e.g. size, portrait/landscape, and so on). There
				are also specifcations for box-layouts for each page as well as
				widgets to be used by the data items.
				
				Run this test and the output PDF will be "my.pdf"
				
				Note that `report_spec_3' ultimately uses `page_spec_3_json'.
				Take a look at `page_spec_3_json' as an example of how to
				structure page, box, and widget specifications.
				]"
		local
			l_writer: PDF_WRITER
		do
			create l_writer.make_from_json (report_spec_3.json_out)
			l_writer.load_data (report_spec_1_data_json)
			l_writer.output_pdf
		end

end


