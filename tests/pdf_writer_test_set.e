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
			create l_writer
			l_writer.destroy

			create l_writer
			l_writer.dispose
		end

end


