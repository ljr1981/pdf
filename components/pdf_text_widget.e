note
	description: "Representation of a PDF_TEXT_WIDGET"
	design: "[
		Applies text with formatting to a host-PDF_BOX (cell/vert/horz).
		
		The basic idea is that this widget is named and json-data specifies
		the name as the target widget. Therefore, the code creates a new instance
		of this class when it detects json-data that specifies it as the target.
		
		Before that--a json-layout-spec states a box-with-widget specification,
		which creates the overall page-layout structure for json-data to fill.
		
		See {PDF_DOCS} design note for more.
		]"

class
	PDF_TEXT_WIDGET

inherit
	PDF_WIDGET


	JSE_AWARE
		undefine
			default_create
		end

create
	default_create,
	make_from_json_value,
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		do
			check attached json_string_to_json_object (a_json) as al_object then
				-- set_items (no_conversion)
				set_offset_x (json_object_to_integer_32 ("offset_x", al_object))
				set_offset_y (json_object_to_integer_32 ("offset_y", al_object))
				set_height (json_object_to_integer_32 ("height", al_object))
				set_width (json_object_to_integer_32 ("width", al_object))
				set_inside_border_padding (json_object_to_integer_32 ("inside_border_padding", al_object))
				set_outside_border_padding (json_object_to_integer_32 ("outside_border_padding", al_object))
				-- set_expandable ()
				set_limit (json_object_to_integer_32 ("limit", al_object))
				-- set_parent (no_conversion)
			end
		end

end
