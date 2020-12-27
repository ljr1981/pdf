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
			create cell
		end

	make_from_json_value (v: JSON_VALUE)
			--<Precursor>
		do
			default_create
			Precursor (v)
			create cell
		end

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
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

feature -- Layout

	cell: EV_CELL
			-- Every page has one `cell'.

	cbox: EV_VERTICAL_BOX
			-- Content (i.e. `cbox') box.
		attribute
			create Result
			Result.set_data ("cbox")
		end

	prep_cell
			-- Prepare `cbox' in `cell' for Content.
		local
			l_mbox: EV_VERTICAL_BOX -- Main-box (entire page)
			l_midbox: EV_HORIZONTAL_BOX -- Holder of left and right margins with `cbox' sandwiched between them.
			l_top, l_left, l_right, l_bottom: EV_CELL -- Margins
		do
		-- create main-box in cell
			create l_mbox; cell.extend (l_mbox)
		-- add header (top)
			create l_top; l_mbox.extend (l_top); l_mbox.disable_item_expand (l_top); l_top.set_minimum_height (margin_top)
		-- add mid-box (left, cbox, right)
			create l_midbox; l_mbox.extend (l_midbox)
			create l_left; l_midbox.extend (l_left); l_midbox.disable_item_expand (l_left); l_left.set_minimum_width (margin_left)
			l_midbox.extend (cbox)
			create l_right; l_midbox.extend (l_right); l_midbox.disable_item_expand (l_right); l_right.set_minimum_width (margin_right)
		-- add footer (bottom)
			create l_bottom; l_mbox.extend (l_bottom); l_mbox.disable_item_expand (l_bottom); l_bottom.set_minimum_height (margin_bottom) -- add header (top)		
		end

	new_box (a_parent: detachable STRING; a_name: STRING; a_min_size: INTEGER; a_is_horizontal: BOOLEAN): EV_BOX
			-- `new_box' of `a_name' to `a_parent' (if named, otherwise `cbox') with `a_min_size'.
		note
			design: "[
				Setting `a_min_size' > 0 indicates that the caller wants to `disable_item_expand' and
				collapse the `new_box' inside the `a_parent' box to `a_min_size'. Otherwise,
				let the Result
				]"
		local
			l_parent_box: EV_BOX
		do
		-- get a ref to the parent (or `cbox')
			if attached a_parent as al_parent then
				check attached cbox_child (Void, al_parent) as al_parent_box then
					l_parent_box := al_parent_box
				end
			else
				check attached cbox_child (Void, "cbox") as al_parent_box then
					l_parent_box := al_parent_box
				end
			end
		-- create new box using `a_is_horizontal' or not
			if a_is_horizontal then
				create {EV_HORIZONTAL_BOX} Result
			else
				create {EV_VERTICAL_BOX} Result
			end
		-- handle `a_min_size' and `disable_item_expand'
			if a_min_size > 0 then
				if attached {EV_VERTICAL_BOX} l_parent_box as al_vert then
					Result.set_minimum_height (a_min_size)
				elseif attached {EV_HORIZONTAL_BOX} l_parent_box as al_horz then
					Result.set_minimum_width (a_min_size)
				end
				l_parent_box.disable_item_expand (Result)
			end
		-- put Result in `a_parent'
			l_parent_box.extend (Result)
		end

	cbox_child (a_box: detachable EV_BOX; a_name: STRING): detachable EV_BOX
			-- Look for `a_box' named `a_name' starting in `cbox'.
		local
			l_target_box: EV_BOX
		do
			l_target_box := if attached a_box then a_box else cbox end
			across
				l_target_box.new_cursor as ic
			loop
				if attached {EV_BOX} ic.item as al_box and then attached {STRING} al_box.data as al_name then
					if al_name.same_string (a_name) then
						Result := al_box
					else
						Result := cbox_child (al_box, a_name)
					end
				end
			end
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
