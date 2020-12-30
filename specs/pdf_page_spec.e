note
	description: "PDF_PAGE Specification"

class
	PDF_PAGE_SPEC

inherit
	PDF_SPEC
		redefine
			default_create,
			make_from_json_value
		end

create
	default_create,
	make_from_json,
	make_from_json_value

feature {NONE} -- Initialization

	default_create
			--<Precursor>
		do
			Precursor
		end

	make_from_json_value (v: JSON_VALUE)
			--<Precursor>
		do
			default_create
			Precursor (v)
		end

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			not_empty: not a_json.is_empty
			valid_json: attached (create {JSON_PARSER}.make_with_string (a_json)) as al_parser and then al_parser.is_valid
		do
			default_create
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
				boxes := json_object_to_json_array ("boxes", al_object)
				widgets := json_object_to_json_array ("widgets", al_object)
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
						"margin_right",
						"boxes",
						"widgets"
						>>
		end

feature -- Access

	type: STRING = "page"
			--<Precursor>

	height: INTEGER
			-- `height' of page in Points.

	width: INTEGER
			-- `width' of page in Points.

	indent_size: INTEGER
			-- `indent_size' in Points.

	font_color: TUPLE [r,g,b: INTEGER]
			-- RGB `font_color'
		attribute
			Result := [0,0,0]
		end

	font_face: TUPLE [name: STRING; slant, weight: INTEGER]
			-- The `font_face' `name' (font-name), `slant' (italic) and `weight' (bold or not).
			-- See {CAIRO_FONT_*_ENUM_API} classes.
		attribute
			Result := ["Sans", {CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_normal, {CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_normal]
		ensure
			not_empty_font_name: not Result.name.is_empty
		end

	font_size: INTEGER
			-- The `font_size' in Points.

	margin_top: INTEGER
			-- The `margin_top' distance in Points.

	margin_bottom: INTEGER
			-- The `margin_bottom' distance in Points.

	margin_left: INTEGER
			-- The `margin_left' distance in Points.

	margin_right: INTEGER
			-- The `margin_right' distance in Points.

	boxes: JSON_ARRAY
			-- A list of `boxes' specifications, possibly empty.
		attribute
			create Result.make_empty
		end

	widgets: JSON_ARRAY
			-- A list of `widgets' specifications, possibly empty.
		attribute
			create Result.make_empty
		end

feature -- Settings

	set_size (t: TUPLE [h, w: INTEGER])
			-- Set `height' and `width'.
		require
			positive_size: t.h > 0 and then t.w > 0
		do
			set_height (t.h)
			set_width (t.w)
		end

	set_height (n: INTEGER)
			-- Set `height' to `n'.
		require
			positive: n > 0
		do
			height := n
		ensure
			set: height = n
		end

	set_width (n: INTEGER)
			-- Set `width' to `n'.
		require
			positive: n > 0
		do
			width := n
		ensure
			set: width = n
		end

	set_indent_size (n: INTEGER)
			-- `set_indent_size' to `n' Points.
		require
			positive: n > 0
		do
			indent_size := n
		ensure
			set: indent_size = n
		end

	set_font_color (t: like font_color)
			-- `set_font_color' to `t' like `font_color'.
		do
			font_color := t
		ensure
			set: font_color ~ t
		end

	set_font_face (t: like font_face)
			-- `set_font_face' to `t' like `font_face'.
		do
			font_face := t
		ensure
			set: font_face ~ t
		end

	set_font_size (n: INTEGER)
			-- `set_font_size' to `n' Points.
		do
			font_size := n
		ensure
			set: font_size = n
		end

	set_margin_top (n: INTEGER)
			-- `set_margin_top' to `n' Points.
		require
			positive: n >= 0
		do
			margin_top := n
		ensure
			set: margin_top = n
		end

	set_margin_bottom (n: INTEGER)
			-- `set_margin_bottom' to `n' Points.
		require
			positive: n >= 0
		do
			margin_bottom := n
		ensure
			set: margin_bottom = n
		end

	set_margin_left (n: INTEGER)
			-- `set_margin_left' to `n' Points.
		require
			positive: n >= 0
		do
			margin_left := n
		ensure
			set: margin_left = n
		end

	set_margin_right (n: INTEGER)
			-- `set_margin_right' to `n' Points.
		require
			positive: n >= 0
		do
			margin_right := n
		ensure
			set: margin_right = n
		end

end
