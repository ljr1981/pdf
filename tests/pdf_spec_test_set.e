﻿note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_SPEC_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	tuple_building
			-- Total aside from PDF-stuff
		note
			purpose: "[
				So, I ran into an issue with the JSON_EXT library where it was trying to build-out a
				TUPLE using calls to `put_*'. These calls were failing because a `default_create' of a
				TUPLE fails to set up the appropriate number of items. So, one has to get creative.
				
				It turns out that recent changes to Eiffel grammar help us with the notation (below).
				
				The basic idea is to load a TUPLE from an ARRAY. After creating our ARRAY of an
				arbitrary set of INTEGER items, we then begin loading them as "item-tuples" into
				iterative instances of our `l_tuple'.
			]"
		local
			l_tuple: TUPLE
			l_array: ARRAY [ANY]
		do
				-- Our source array
			l_array := (1 |..| 3).as_array

				-- Start adding items to successive TUPLE instances using plus
			create l_tuple 								-- First, create our base TUPLE
			⟳ item:l_array ¦ 							-- Then--for each array item ...
				check attached l_tuple then				-- Ensure `l_tuple' is attached
					l_tuple := l_tuple.plus (item)		-- Add the array item
				end
			⟲ 											-- Do this until `l_array' is exhausted.

				-- Test to ensure each item is what we expect ...
				-- In this project SCOOP is turned on, so we care about the separate-ness
			assert_32 ("tuple_items_equal_array_items", ∀ ic: 1 |..| l_array.count ¦
																	attached l_tuple and then
																	attached l_tuple.item (ic) as al_item
																	and then al_item = ic)
		end

	report_spec_test
			-- Test {PDF_PAGE_SPEC}
		note
			testing: "covers/{PDF_PAGE_SPEC}.make_from_json",
						"covers/{PDF_PAGE_SPEC}.json_out",
						"execution/isolated",
						"execution/serial"
		local
			l_spec: PDF_REPORT_SPEC
		do
				-- Ensure that the specification produces the right JSON string
			l_spec := report_spec_1.twin
			assert_strings_equal ("report_spec_1_json_1", report_spec_1_json_1, l_spec.json_out)

				-- Ensure that the code-generator produces what we think make-from-json will need.
			assert_strings_equal ("report_spec_1_make_from_json_code_string", report_spec_1_make_from_json_code_string, l_spec.generated_make_from_json_code (l_spec))

				-- Now, create a page from a specification and ensure the JSON output is correct.
			create l_spec.make_from_json (report_spec_1_json_1)
			assert_strings_equal ("report_spec_1_json_2", report_spec_1_json_2, l_spec.json_out)
		end

	page_spec_test
			-- Test {PDF_PAGE_SPEC}
		note
			testing: "covers/{PDF_PAGE_SPEC}.make_from_json",
						"covers/{PDF_PAGE_SPEC}.json_out",
						"execution/isolated",
						"execution/serial"
		local
			l_spec: PDF_PAGE_SPEC
		do
				-- Ensure that the specification produces the right JSON string
			l_spec := page_spec_1.twin
			assert_strings_equal ("page_spec_json_1", page_spec_json_1, l_spec.json_out)

				-- Ensure that the code-generator produces what we think make-from-json will need.
			assert_strings_equal ("make_from_json_code", page_spec_1_make_from_json_code_string, l_spec.generated_make_from_json_code (l_spec))

				-- Now, create a page from a specification and ensure the JSON output is correct.
			create l_spec.make_from_json (page_spec_json_1)
			assert_strings_equal ("page_spec_json_2", page_spec_json_2, l_spec.json_out)
		end

	pdf_EV_test
			-- Low-level test using Eiffel Vision2 as basis for page layout.
		note
			testing: "covers/{PDF_FACTORY}.make_us_std_with_name",
						"covers/{PDF_FACTORY}.page",
						"covers/{PDF_FACTORY}.destroy",
						"covers/{PDF_PAGE}.set_default_margins",
						"covers/{PDF_PAGE}.set_current_x",
						"covers/{PDF_PAGE}.set_current_y",
						"covers/{PDF_PAGE}.apply_text",
						"execution/isolated",
						"execution/serial"
		local
			l_win: EV_WINDOW
			l_cell: EV_CELL
				-- Margins
			l_top, l_left, l_right, l_bottom: EV_CELL
			l_mainbox: EV_VERTICAL_BOX
			l_midbox: EV_HORIZONTAL_BOX
				-- Boxes
			l_vbox1,
			l_vbox2,
			l_vbox3: EV_VERTICAL_BOX
			l_text1,
			l_text2: EV_LABEL
				-- PDF Page
			l_factory: PDF_FACTORY
			l_page: like {PDF_FACTORY}.page
		do
				-- Factory
			create l_factory.make_us_std_with_name ("vbox1.pdf")
			l_page := l_factory.page
			l_page.set_default_margins

				-- creation Content
			create l_win
			create l_cell
			create l_top; create l_left; create l_right; create l_bottom
			create l_mainbox; create l_midbox
			create l_vbox1
			create l_vbox2
			create l_vbox3

				-- Page structure
			l_win.extend (l_cell)
			l_cell.extend (l_mainbox)
			l_mainbox.extend (l_top)
			l_mainbox.extend (l_midbox)
			l_mainbox.extend (l_bottom)
			l_midbox.extend (l_left)
			l_midbox.extend (l_vbox1)
			l_midbox.extend (l_right)

				-- Content boxes
			l_vbox1.extend (l_vbox2)
			l_vbox1.extend (l_vbox3)

				-- Sizing
			l_top.set_minimum_height (l_page.margin_top)
			l_left.set_minimum_width (l_page.margin_left)
			l_mainbox.set_minimum_size (us_8_by_11_page_width, us_8_by_11_page_height)
			l_vbox1.set_minimum_size (us_8_by_11_page_width - l_page.margin_left - l_page.margin_right, us_8_by_11_page_height - l_page.margin_top - l_page.margin_bottom)

				-- Text
			create l_text1.make_with_text ("TEXT_1")
			create l_text2.make_with_text ("TEXT_2")
			l_vbox2.extend (l_text1)
			l_vbox3.extend (l_text2)
			l_win.set_position (0, 0)
			l_win.show

				-- Apply to PDF
			l_page.set_current_x (l_text1.screen_x)
			l_page.set_current_y (l_text1.screen_y + l_text1.font.height_in_points)
			l_page.apply_text ("X: " + l_text1.screen_x.out + ", Y: " + l_text1.screen_y.out)

			l_page.set_current_x (l_text2.screen_x)
			l_page.set_current_y (l_text2.screen_y + l_text2.font.height_in_points)
			l_page.apply_text ("X: " + l_text2.screen_x.out + ", Y: " + l_text2.screen_y.out)

			l_factory.next_page				-- Create a new page from the "factory".
			l_page := l_factory.page		-- Set our page
			l_page.set_font_name ("Courier")-- Prove we can reset font-name
			l_page.set_font_size (10.8)		--	... and the point-size
			traverse (l_mainbox, l_page)	-- Iterate "mainbox", printing items on "page".
											--	(this replaces code above in "Apply to PDF")

				-- Just to prove that we have the correct "edge"
			l_page.set_current_x (l_vbox1.screen_x)
			l_page.set_current_y (l_vbox1.screen_y + 50)
			l_page.apply_text ("| <-- interior vbox left-edge.")

			l_factory.destroy

		end

	report_test_1
			-- Build a report by hand (later using json-data).
		note
			testing:  "execution/isolated", "execution/serial"
			test_design: "[
				The `report_spec_2' feature has the "hand-built" code. Normally, this object
				would be created from an input JSON stream. In this case, we construc the object
				by hand-coding it.
				
				In this first test, all we want is a PDF file with two blank pages, where
				one page is portrait and the second is landscape.
				]"
		local
			l_report: PDF_REPORT_SPEC
		do
			l_report := report_spec_2.twin
			assert_strings_equal ("report_spec_2_json_string", report_spec_2_json_string, l_report.json_out)
			assert_integers_equal ("two_page_specs", 2, l_report.page_specs.count)
		end

feature {NONE} -- Support

	traverse (a_box: EV_BOX; a_page: PDF_PAGE)
			-- Iterate into `a_box', printing its items on `a_page'.
		note
			design: "[
				A new version of this is coming! The idea will be to iterate
				over all of the items contained in `a_box' and then apply them
				to `a_page' using predefined functions, possibly agents. All
				of this will most likely be held in a PDF_REPORT_WRITER and a
				PDF_REPORT_STREAMER set of classes. They will get code from
				the PDF_FACTORY, perhaps reusing it (perhaps not). Either way,
				the job of report writing/streaming will be held at a very
				high-level away from Cairo, where this all began (see wrap_cairo).
				]"
		local
			l_text: detachable STRING_32
		do
			⟳ widget: a_box.new_cursor ¦
				a_page.set_current_x (widget.screen_x)
				a_page.set_current_y (widget.screen_y)
				if attached {EV_TEXT_COMPONENT} widget as al_component then
					l_text := al_component.text
				elseif attached {EV_LABEL} widget as al_label then
					l_text := al_label.text
					a_page.set_current_y (al_label.screen_y + al_label.font.height_in_points)
				end
				if attached l_text then
					a_page.apply_text (l_text)
				end
				if attached {EV_BOX} widget as al_box then
					traverse (al_box, a_page)
				end
			⟲
		end

end

