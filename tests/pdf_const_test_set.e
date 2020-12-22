note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_CONST_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	constants_tests
			-- Testing of {PDF_CONST}
		note
			testing:  "execution/isolated", "execution/serial",
						"covers/{PDF_CONST}.US_8_by_11_page_width",
						"covers/{PDF_CONST}.US_8_by_11_page_height"
		local
			l_item: PDF_CONST
		do
			create l_item
			assert_integers_equal ("US_8_by_11_page_width", 612, l_item.US_8_by_11_page_width)
			assert_integers_equal ("US_8_by_11_page_height", 792, l_item.US_8_by_11_page_height)
		end

end


