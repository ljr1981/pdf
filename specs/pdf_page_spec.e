note
	description: "PDF_PAGE Specification"

class
	PDF_PAGE_SPEC

inherit
	PDF_SPEC

create
	default_create,
	make_from_json,
	make_from_json_value

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		do
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
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := <<
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING_8]
			--<Precursor>
		do
			Result := <<
						"name",
						"height",
						"width",
						"indent_size",
						"font_color",
						"font_face",
						"font_size",
						"margin_top",
						"margin_bottom",
						"margin_left",
						"margin_right"
						>>
		end

feature -- Access

	type: STRING = "page"

	height: INTEGER

	width: INTEGER

	indent_size: INTEGER

	font_color: TUPLE [r,g,b: INTEGER]
			--
		attribute
			Result := [0,0,0]
		end

	font_face: TUPLE [name: STRING; slant, weight: INTEGER]
			--
		attribute
			Result := ["Sans", {CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_normal, {CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_normal]
		end

	font_size: INTEGER

	margin_top: INTEGER

	margin_bottom: INTEGER

	margin_left: INTEGER

	margin_right: INTEGER

	cell: PDF_VERTICAL_BOX
			--
		attribute
			create Result
		end

feature -- Settings

	set_size (t: TUPLE [h, w: INTEGER])
			-- Set `height' and `width'.
		do
			set_height (t.h)
			set_width (t.w)
		end

	set_height (n: INTEGER)
			-- Set `height' to `n'.
		do
			height := n
		ensure
			set: height = n
		end

	set_width (n: INTEGER)
			-- Set `width' to `n'.
		do
			width := n
		ensure
			set: width = n
		end

	set_indent_size (n: INTEGER)
			--
		do
			indent_size := n
		ensure
			set: indent_size = n
		end

	set_font_color (t: like font_color)
			--
		do
			font_color := t
		ensure
			set: font_color ~ t
		end

	set_font_face (t: like font_face)
			--
		do
			font_face := t
		ensure
			set: font_face ~ t
		end

	set_font_size (n: INTEGER)
			--
		do
			font_size := n
		ensure
			set: font_size = n
		end

	set_margin_top (n: INTEGER)
			--
		do
			margin_top := n
		ensure
			set: margin_top = n
		end

	set_margin_bottom (n: INTEGER)
			--
		do
			margin_bottom := n
		ensure
			set: margin_bottom = n
		end

	set_margin_left (n: INTEGER)
			--
		do
			margin_left := n
		ensure
			set: margin_left = n
		end

	set_margin_right (n: INTEGER)
			--
		do
			margin_right := n
		ensure
			set: margin_right = n
		end

end
