note
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
			across
				l_array as ic
			from
				create l_tuple -- First, create our base TUPLE
			loop -- Then--for each `l_array' item of type ANY ...
				if attached l_tuple then -- Do an attachment check to satisfy Void-safety ...
					l_tuple := l_tuple.plus (ic.item) -- Use the facility of `{TUPLE}.plus' to make a new TUPLE, replacing our old one
				end
			end -- Do this until `l_array' is exhausted.

				-- Test to ensure each item is what we expect ...
				-- In this project SCOOP is turned on, so we care about the separate-ness
			across
				1 |..| l_array.count as ic
			loop
				if attached l_tuple as al_tuple and then attached al_tuple.item (ic.item) as al_tuple_item then
					separate al_tuple_item as sic do
						if attached {INTEGER} sic as al_sic then
							assert_integers_equal ("ic_item_" + ic.item.out, ic.item, al_sic)
						end
					end
				end
			end
		end

	report_spec_test
			-- Test {PDF_PAGE_SPEC}
		note
			testing: "covers/{PDF_PAGE_SPEC}.make_from_json",
			"execution/isolated",
			"execution/serial"
		local
			l_spec: PDF_REPORT_SPEC
		do
				-- Ensure that the specification produces the right JSON string
			l_spec := report_spec_1.twin
			assert_strings_equal ("report_spec_1_json", report_spec_1_json, l_spec.json_out)

				-- Ensure that the code-generator produces what we think make-from-json will need.
			assert_strings_equal ("report_spec_1_make_from_json_code_string", report_spec_1_make_from_json_code_string, l_spec.generated_make_from_json_code (l_spec))

				-- Now, create a page from a specification and ensure the JSON output is correct.
			create l_spec.make_from_json (report_spec_1_json)
			assert_strings_equal ("report_spec_1_json", report_spec_1_json, l_spec.json_out)
		end

	page_spec_test
			-- Test {PDF_PAGE_SPEC}
		note
			testing: "covers/{PDF_PAGE_SPEC}.make_from_json",
			"execution/isolated",
			"execution/serial"
		local
			l_spec: PDF_PAGE_SPEC
		do
				-- Ensure that the specification produces the right JSON string
			l_spec := page_spec_1.twin
			assert_strings_equal ("page_spec_json", page_spec_json, l_spec.json_out)

				-- Ensure that the code-generator produces what we think make-from-json will need.
			assert_strings_equal ("make_from_json_code", page_spec_1_make_from_json_code_string, l_spec.generated_make_from_json_code (l_spec))

				-- Now, create a page from a specification and ensure the JSON output is correct.
			create l_spec.make_from_json (page_spec_json)
			assert_strings_equal ("make_from_json", page_spec_json, l_spec.json_out)
		end

	pdf_cell_test
			-- Test of PDF_CELL
		local
			l_vbox: PDF_VERTICAL_BOX
		do
			create l_vbox
--			assert_strings_equal ("vbox_json", vbox_json, l_vbox.json_out)

--			assert_strings_equal ("make_from_json_code", vbox_make_from_json_code_string, l_vbox.generated_make_from_json_code (l_vbox))
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
			l_vbox: PDF_VERTICAL_BOX
			l_text: PDF_TEXT_WIDGET
		do
			l_report := report_spec_2.twin
			assert_strings_equal ("report_spec_2_json_string", report_spec_2_json_string, l_report.json_out)
			assert_integers_equal ("two_page_specs", 2, l_report.page_specs.count)
		end

end

