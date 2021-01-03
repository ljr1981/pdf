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
	set_boxes (no_conversion)
end

]"

	frozen page_spec_json_1: STRING
			-- Potential {PDF_PAGE_SPEC} json.
		note
			not_prettified: "because it is used to test against `emittted' json."
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":null,"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}
]"
		end

	frozen page_spec_json_2: STRING
			-- Potential {PDF_PAGE_SPEC} json.
		note
			not_prettified: "because it is used to test against `emittted' json."
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":[],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}
]"
		end

	frozen page_spec_1: PDF_PAGE_SPEC
			-- Example #1 of a page spec.
		note
			design: "[
				See `report_spec_1_data_json' for more.
				
				In the above json-based "data" we find refs to "my_box_N" and "my_widget_N", where
				the data is expecting this page-spec to have defined these boxes and widgets. That
				is--this page-spec needs to define 3 EV_BOXes and 3 EV_WIDGETs.
				
				How, is the question.
				
				Ultimately, a {PDF_PAGE} will be built from a {PDF_PAGE_SPEC}. The page will have
				the actual EV_things, whereas the page-spec as the spec-things (usualy json). So,
				what does a box-spec and widget-spec look like?
				
				Define: Box-spec
				Define: Widget-spec
				
				Note that boxes can be nested and widgets are just widgets, whose relation to a
				box is specified in the data (yes?).
				]"
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
		-- Start adding box-specs
		-- Start adding widget-specs
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

	frozen page_spec_3_json: STRING
			-- Potential {PDF_PAGE_SPEC} json, including box and widget specs.
		note
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{
  "name": "page_spec_3",
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
  "margin_right": 11,
  "boxes": [
    {
      "b1": [
        {
          "name": "my_box_1"
        },
        {
          "parent": null
        },
        {
          "type": "vertical"
        },
        {
          "layout": [
            {
              "minimum_size": 0
            }
          ]
        }
      ]
    },
    {
      "b2": [
        {
          "name": "my_box_2"
        },
        {
          "parent": null
        },
        {
          "type": "horizontal"
        },
        {
          "layout": [
            {
              "minimum_size": 0
            }
          ]
        }
      ]
    },
    {
      "b3": [
        {
          "name": "my_box_3"
        },
        {
          "parent": null
        },
        {
          "type": "vertical"
        },
        {
          "layout": [
            {
              "minimum_size": 0
            }
          ]
        }
      ]
    }
  ]
}
]"
		end

	frozen page_spec_3: PDF_PAGE_SPEC
			-- Example #3 of a page spec.
		once
			create Result.make_from_json (page_spec_3_json)
		end

	frozen report_spec_1: PDF_REPORT_SPEC
			-- Report spec #1
		once
			create Result
			Result.set_name ("report_spec_1")
			Result.set_output_file_name ("my.pdf")
			Result.page_specs.force (page_spec_1)
		end

	frozen report_spec_1_json_1: STRING
			-- Potential {PDF_REPORT_SPEC} json string.
			-- boxes and widgets are null
		note
			not_prettified: "because it is used to test against `emittted' json."
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{"name":"report_spec_1","output_file_name":"my.pdf","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":null,"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"
		end

	frozen report_spec_1_json_2: STRING
			-- Potential {PDF_REPORT_SPEC} json string.
			-- boxes and widgets are empty JSON_ARRAYs
		note
			not_prettified: "because it is used to test against `emittted' json."
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{"name":"report_spec_1","output_file_name":"my.pdf","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":[],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"
		end

	frozen report_spec_1_data_json: STRING
			-- Possible "data" for `report_spec_1_json_1' (i.e. same as `report_spec_1').
		note
			prettified: "because it is used to test loading."
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{
  "d1": [
    {
      "page_spec": "page_spec_1"
    },
    {
      "box": "my_box_1"
    },
    {
      "widget": "my_widget_1"
    },
    "TEXT1"
  ],
  "d2": [
    {
      "page_spec": "page_spec_1"
    },
    {
      "box": "my_box_2"
    },
    {
      "widget": "my_widget_1"
    },
    "TEXT2"
  ],
  "d3": [
    {
      "page_spec": "page_spec_1"
    },
    {
      "box": "my_box_3"
    },
    {
      "widget": "my_widget_1"
    },
    "TEXT3"
  ]
}
]"
		end

	report_spec_1_data_json_check: STRING = "[
{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"cell":{"sub_items":[{"sub_items":null,"parent":null,"text":"TEST_TEXT_FOR_TEXT_WIDGET","expandable":true,"offset_x":0,"offset_y":0,"height":0,"width":0,"inside_border_padding":0,"outside_border_padding":0,"limit":1}],"parent":null,"expandable":true,"offset_x":0,"offset_y":0,"height":0,"width":0,"inside_border_padding":0,"outside_border_padding":0,"limit":0},"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}
]"

	report_spec_1_make_from_json_code_string: STRING = "[
check attached json_string_to_json_object (a_json) as al_object then
	set_name (json_object_to_string_attached ("name", al_object))
	set_output_file_name (json_object_to_string_attached ("output_file_name", al_object))
	fill_arrayed_list_of_detachable_any ("page_specs", al_object, page_specs, agent (a_object: JSON_VALUE): PDF_PAGE_SPEC do create Result.make_from_json_value (a_object) end)
end

]"

	frozen report_spec_2_json_string: STRING
			-- Possible {PDF_REPORT_SPEC} json
		note
			not_prettified: "because it is used to test against `emittted' json."
			EIS: "name=json_parser", "src=https://jsonparser.org/"
		once
			Result := "[
{"name":"report_spec_1","output_file_name":"my.pdf","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":null,"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11},{"name":"page_spec_2","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":null,"height":612,"width":792,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"
		end


	frozen report_spec_2: PDF_REPORT_SPEC
			-- Report spec #2
		once
			create Result
			Result.set_name ("report_spec_1")
			Result.set_output_file_name ("my.pdf")
			Result.page_specs.force (page_spec_1)
			Result.page_specs.force (page_spec_2)
		end

	frozen report_spec_3: PDF_REPORT_SPEC
			-- Report spec #3
		once
			create Result
			Result.set_name ("report_spec_3")
			Result.set_output_file_name ("my.pdf")
			Result.page_specs.force (page_spec_3)
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

feature {NONE} -- PDF_DATA Test Support

	empty_data_json: STRING = "[
{
  "widgets": [],
  "data": []
}
]"

	frozen data_json_1: STRING
		note
			design: "[
				In the following, you will find a json structure like:
				
					"data":[{"1":{"datum":[{"tex ... }
				
				The "data" shows you where the list of datum starts.
				Each datum item is numbered serially, starting at 1, 2, 3, ...
				Each datum item is a labeled JSON_ARRAY, named "datum".
				Each datum item is an array of elements describing the datum.
				
				Therefore, the first datum item starts with:
				
					{"1":{"datum":[{"text":"my_tex ... }
				
				The second datum item starts with:
				
					{"2":{"datum":[{"text":"my_tex ... }
				
				Each successive datum will have a new and unique serial number,
				where datum are serialized starting at 1 and advancing by one
				for each new datum in the data.
				
				It is important to understand this when comparing to example/test
				JSON strings found below (e.g. `Datum_json_1' and so on in the next
				feature group, "PDF_DATUM Test Support")
				]"
		once
			Result := "[
{
  "widgets": [
    {
      "text": "label_text",
      "type": "label",
      "widget_id": "1",
      "inside_border_padding": 3,
      "outside_border_padding": 3,
      "minimum_height": 20,
      "minimum_width": 100
    }
  ],
  "data": [
    {
      "1": {
        "datum": [
          {
            "text": "my_text_1"
          },
          {
            "size": 10
          },
          {
            "font_face": [
              "Courier",
              1,
              2
            ]
          }
        ]
      }
    },
    {
      "2": {
        "datum": [
          {
            "text": "my_text_2"
          },
          {
            "size": 10
          },
          {
            "font_face": [
              "Courier",
              1,
              2
            ]
          }
        ]
      }
    }
  ]
}
]"
		end

feature {NONE} -- PDF_DATUM Test Support

	frozen datum_json_1: STRING = "[
{
  "datum": [
    {
      "text": "my_text"
    },
    {
      "size": 10
    },
    {
      "font_face": [
        "Courier",
        1,
        2
      ]
    }
  ]
}
]"

	frozen datum_json_1_with_error: STRING
			-- An erroneous version of a datum item.
		note
			error: "[
				The error is in the font_face values of 9 and 9.
				]"
		once
			Result := "[
{
  "datum": [
    {
      "text": "my_text"
    },
    {
      "size": 10
    },
    {
      "font_face": [
        "Courier",
        9,
        9
      ]
    }
  ]
}
]"
		end

	frozen datum_json_1_with_font_name_error: STRING
			-- An erroneous font name version of a datum item.
		note
			error: "[
				The error is in the font_face name being empty
				]"
		once
			Result := "[
{
  "datum": [
    {
      "text": "my_text"
    },
    {
      "size": 10
    },
    {
      "font_face": [
        "",
        0,
        0
      ]
    }
  ]
}
]"
		end

	Datum_json_with_widget_id_1: STRING = "[
{
  "datum": [
    {
      "text": "my_text"
    },
    {
      "size": 10
    },
    {
      "wid": 1
    }
  ]
}
]"


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

	report_spec_json_1: STRING = "[
{"name":"MY_REPORT_1","output_file_name":"my.pdf","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":[],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"

	report_spec_json_2: STRING = "[
{"name":"MY_REPORT_1","output_file_name":"my.pdf","page_specs":[{"name":"page_spec_1","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":null,"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}]}
]"

	report_spec_json_prettified: STRING = "[
{
  "name": "MY_REPORT_1",
  "output_file_name":"my.pdf",
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
      "margin_right": 11,
      "boxes": null
    }
  ]
}
]"

end
