note
	description: "Summary description for {PDF_TEST_SUPPORT_CONST}."
	EIS: "name=json_prettifier", "src=https://jsonparser.org/"

deferred class
	PDF_TEST_SET_SUPPORT

inherit
	TEST_SET_SUPPORT

	PDF_CONST
		undefine
			default_create
		end

feature {NONE}  -- PDF_SPEC Support

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

	frozen page_spec_1: PDF_PAGE_SPEC
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

	frozen page_spec_2: PDF_PAGE_SPEC
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

	frozen report_spec_1: PDF_REPORT_SPEC
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
	"data": %"[
				{"d1":"page_spec":"page_spec_1","type":"text"}
				]%"
}
]"

	frozen report_spec_2: PDF_REPORT_SPEC
			-- Report spec #2
		once
			create Result
			Result.set_name ("report_spec_1")
			Result.page_specs.force (page_spec_1)
			Result.page_specs.force (page_spec_2)
		end

	vbox_json: STRING
			-- Potential data representing an {EV_VERTICAL_BOX} layout.
		note
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{
  "items": null,
  "parent": null,
  "expandable": true,
  "offset_x": 0,
  "offset_y": 0,
  "height": 0,
  "width": 0,
  "inside_border_padding": 0,
  "outside_border_padding": 0,
  "limit": 0
}
]"
		end

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

feature {NONE} -- PDF_WIDGET Support

	text_widget_default_json: STRING
			-- Potential data representing an {EV_LABEL} text-widget.
		note
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{
  "sub_items": null,
  "parent": null,
  "text": null,
  "expandable": true,
  "offset_x": 0,
  "offset_y": 0,
  "height": 0,
  "width": 0,
  "inside_border_padding": 0,
  "outside_border_padding": 0,
  "limit": 1
}
]"
		end

feature {NONE} -- PDF_BOX Test Support

	page_json_with_cell_items: STRING
			-- A {PDF_PAGE_SPEC} json string with partial-`cell' data.
		note
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{
  "name": "page_spec_1",
  "font_color": [
    0,
    0,
    0
  ],
  "font_face": [
    "Sans",
    0,
    0
  ],
  "cell": {
    "sub_items": [
      {
        "sub_items": null,
        "parent": null,
        "text": "TEST_TEXT_FOR_TEXT_WIDGET",
        "expandable": true,
        "offset_x": 0,
        "offset_y": 0,
        "height": 0,
        "width": 0,
        "inside_border_padding": 0,
        "outside_border_padding": 0,
        "limit": 1
      }
    ],
    "parent": null,
    "expandable": true,
    "offset_x": 0,
    "offset_y": 0,
    "height": 0,
    "width": 0,
    "inside_border_padding": 0,
    "outside_border_padding": 0,
    "limit": 0
  },
  "height": 792,
  "width": 612,
  "indent_size": 50,
  "font_size": 10,
  "margin_top": 16,
  "margin_bottom": 13,
  "margin_left": 11,
  "margin_right": 11
}
]"
	end

	report_spec_json: STRING = "[
{"name":"MY_REPORT_1","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"

	report_spec_json_prettified: STRING = "[
{
  "name": "MY_REPORT_1",
  "page_specs": [
    {
      "name": "page_spec_1",
      "font_color": [
        0,
        0,
        0
      ],
      "font_face": [
        "Sans",
        0,
        0
      ],
      "height": 792,
      "width": 612,
      "indent_size": 50,
      "font_size": 10,
      "margin_top": 16,
      "margin_bottom": 13,
      "margin_left": 11,
      "margin_right": 11
    }
  ]
}
]"

end
