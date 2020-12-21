note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_SPEC_TEST_SET

inherit
	TEST_SET_SUPPORT

	PDF_CONST
		undefine
			default_create
		end

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
			assert_strings_equal ("report_test_1_json", report_spec_2_json_string, l_report.json_out)
		end

feature {NONE} -- Implementation: Constants

	page_spec_1_make_from_json_code_string: STRING = "[
check attached json_string_to_json_object (a_json) as al_object then
	set_name (json_object_to_string_attached ("name", al_object))
	set_height (json_object_to_integer_32 ("height", al_object))
	set_width (json_object_to_integer_32 ("width", al_object))
	set_indent_size (json_object_to_integer_32 ("indent_size", al_object))
	if attached {like font_color} json_array_to_eiffel_tuple (json_object_to_tuple_as_json_array ("font_color", al_object)) as al_tuple then
		set_font_color (al_tuple)
	end

	if attached {like font_face} json_array_to_eiffel_tuple (json_object_to_tuple_as_json_array ("font_face", al_object)) as al_tuple then
		set_font_face (al_tuple)
	end

	set_font_size (json_object_to_integer_32 ("font_size", al_object))
	set_margin_top (json_object_to_integer_32 ("margin_top", al_object))
	set_margin_bottom (json_object_to_integer_32 ("margin_bottom", al_object))
	set_margin_left (json_object_to_integer_32 ("margin_left", al_object))
	set_margin_right (json_object_to_integer_32 ("margin_right", al_object))
end

]"

	page_spec_json: STRING = "[
{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}
]"

	page_spec_1: PDF_PAGE_SPEC
			-- Example #1 of a page spec.
		once
			create Result
			Result.set_name ("page_spec_1")
			Result.set_font_color ([0, 0, 0])
			Result.set_font_face (["Sans", {CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_normal, {CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_normal])
			Result.set_font_size (10)
			Result.set_size (US_portrait)
			Result.set_indent_size (50)
			Result.set_margin_bottom ({PDF_CONST}.default_margin_bottom)
			Result.set_margin_left ({PDF_CONST}.default_margin_left)
			Result.set_margin_right ({PDF_CONST}.default_margin_right)
			Result.set_margin_top ({PDF_CONST}.default_margin_top)
		end

	page_spec_2: PDF_PAGE_SPEC
			-- Example #2 of a page spec.
		once
			create Result
			Result.set_name ("page_spec_2")
			Result.set_font_color ([0, 0, 0])
			Result.set_font_face (["Sans", {CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_normal, {CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_normal])
			Result.set_font_size (10)
			Result.set_size (US_landscape)
			Result.set_indent_size (50)
			Result.set_margin_bottom ({PDF_CONST}.default_margin_bottom)
			Result.set_margin_left ({PDF_CONST}.default_margin_left)
			Result.set_margin_right ({PDF_CONST}.default_margin_right)
			Result.set_margin_top ({PDF_CONST}.default_margin_top)
		end

	report_spec_1: PDF_REPORT_SPEC
			-- Report spec #1
		once
			create Result
			Result.set_name ("report_spec_1")
			Result.page_specs.force (page_spec_1)
		end

	report_spec_1_json: STRING = "[
{"name":"report_spec_1","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"

	report_spec_1_make_from_json_code_string: STRING = "[
check attached json_string_to_json_object (a_json) as al_object then
	set_name (json_object_to_string_attached ("name", al_object))
	fill_arrayed_list_of_detachable_any ("page_specs", al_object, page_specs, agent (a_object: JSON_VALUE): PDF_PAGE_SPEC do create Result.make_from_json_value (a_object) end)
end

]"

	report_spec_2_json_string: STRING = "[
{"name":"report_spec_1","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11},{"name":"page_spec_2","font_color":[0,0,0],"font_face":["Sans",0,0],"height":612,"width":792,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"

		-- Test data in JSON format ...
	report_json_data_string: STRING = "[
{
	"name": "report_1_name",
	"item": "..."
}
]"

	report_spec_2: PDF_REPORT_SPEC
			-- Report spec #2
		once
			create Result
			Result.set_name ("report_spec_1")
			Result.page_specs.force (page_spec_1)
			Result.page_specs.force (page_spec_2)
		end

	vbox_json: STRING = "[
{"items":null,"parent":null,"expandable":true,"offset_x":0,"offset_y":0,"height":0,"width":0,"inside_border_padding":0,"outside_border_padding":0,"limit":0}
]"
 	vbox_make_from_json_code_string: STRING = "[
check attached json_string_to_json_object (a_json) as al_object then
	set_items (no_conversion)
	set_offset_x (json_object_to_integer_32 ("offset_x", al_object))
	set_offset_y (json_object_to_integer_32 ("offset_y", al_object))
	set_height (json_object_to_integer_32 ("height", al_object))
	set_width (json_object_to_integer_32 ("width", al_object))
	set_inside_border_padding (json_object_to_integer_32 ("inside_border_padding", al_object))
	set_outside_border_padding (json_object_to_integer_32 ("outside_border_padding", al_object))
	-- set_expandable ()
	set_limit (json_object_to_integer_32 ("limit", al_object))
	set_parent (no_conversion)
end

]"

end

