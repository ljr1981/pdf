note
	description: "A page box where items are arranged vertically."
	design: "[
		Widget items in the box can arrange themselves either top-down
		or bottom-up.
		]"

class
	PDF_VERTICAL_BOX

inherit
	PDF_BOX

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
				-- set_sub_items (no_conversion)
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
