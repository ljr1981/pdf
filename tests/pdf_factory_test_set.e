note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_FACTORY_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	pdf_factory_creation_tests
			-- Factory creation testing
		note
			design: "Please take note of the {PDF_FACTORY}.dispose, which negated the need to call destroy."
			testing:  "execution/isolated", "execution/serial",
						"covers/{PDF_FACTORY}.make",
						"covers/{PDF_FACTORY}.make_us_std",
			          	"covers/{PDF_FACTORY}.default_create",
						"covers/{PDF_FACTORY}.page_height",
						"covers/{PDF_FACTORY}.page_width"
		local
			l_factory: PDF_FACTORY
		do
				-- default_create
			create l_factory
			assert_booleans_not_equal ("default_create_not_destroyed", True, l_factory.is_destroyed)
			assert_integers_equal ("default_create_page_height", 792, l_factory.page_height)
			assert_integers_equal ("default_create_page_width", 612, l_factory.page_width)
				-- Factory stuff goes here ...
			l_factory.destroy
			assert_booleans_equal ("default_create_destroyed", True, l_factory.is_destroyed)

				-- make
			create l_factory.make ("my_pdf.pdf", 600, 700)
			assert_booleans_not_equal ("make_not_destroyed", True, l_factory.is_destroyed)
			assert_integers_equal ("make_page_height", 600, l_factory.page_height)
			assert_integers_equal ("make_page_width", 700, l_factory.page_width)
				-- Factory stuff goes here ...
			l_factory.destroy
			assert_booleans_equal ("make_destroyed", True, l_factory.is_destroyed)

				-- make_us_std
			create l_factory.make_us_std
			assert_booleans_not_equal ("make_us_std_not_destroyed", True, l_factory.is_destroyed)
			assert_integers_equal ("make_us_std_page_height", 792, l_factory.page_height)
			assert_integers_equal ("make_us_std_page_width", 612, l_factory.page_width)
				-- Factory stuff goes here ...
			l_factory.destroy
			assert_booleans_equal ("make_us_std_destroyed", True, l_factory.is_destroyed)
		end

	pdf_factory_page_tests
			-- Test the facilities of pages in the factory.
		note
			testing: "execution/isolated", "execution/serial"
		local
			l_factory: PDF_FACTORY
			l_page: like {PDF_FACTORY}.page
		do
			create l_factory.make_us_std_with_name ("test.pdf")
			l_page := l_factory.page

			assert_equal ("x_y", [10, 35], [l_page.current_x, l_page.current_y])
			l_page.apply_text ("Line #1 at top-left")
			l_page.crlf
			l_page.crlf
			l_page.indent_one
			assert_equal ("x_y_2", [60, 75], [l_page.current_x, l_page.current_y])
			l_page.apply_text ("Line #3 indented one over.")
			l_page.down_n_lines (3)
			l_page.crlf
			l_page.apply_text ("Line #7 at left-margin.")
			l_page.crlf
			l_page.apply_text ("Line #8 at left-margin. Just below #7 above.")

			l_factory.next_page
			l_page := l_factory.page
			l_page.apply_text ("Page #2")

			l_factory.next_page
			l_page := l_factory.page
			l_page.apply_text ("Page #3")

			l_factory.next_page
			l_page := l_factory.page
			l_page.apply_text ("Page #4")

			l_factory.destroy
		end

end


