note
	description: "Representation of a PDF Page."

class
	PDF_PAGE

inherit
	DISPOSABLE

	JSE_AWARE

create
	make,
	make_from_page_spec

feature {NONE} -- Initialization (JSON)

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		do
			check attached json_string_to_json_object (a_json) as al_object then
				-- conversions of items in al_object --> Eiffel feature objects
				-- see {JSON_CODE_GENERATOR} for more (use TEST_SET to generate)
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := <<>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := <<>> -- populate with "my_feature_name"
		end

feature {NONE} -- Initialize

	make_from_page_spec (a_cr: CAIRO_STRUCT_API; a_spec: PDF_PAGE_SPEC)
			-- Create with `a_spec'.
		do
			cr := a_cr
			height := a_spec.height
			width := a_spec.width
			set_indent_size (a_spec.indent_size)
			set_font_color (a_spec.font_color)
			set_font_face (a_spec.font_face)
			set_margin_top (a_spec.margin_top)
			set_margin_bottom (a_spec.margin_bottom)
			set_margin_left (a_spec.margin_left)
			set_margin_right (a_spec.margin_right)
			boxes := a_spec.boxes.twin
			widgets := a_spec.widgets.twin
			cell_prep
		end

	make (a_cr: CAIRO_STRUCT_API; a_sizing: TUPLE [h, w: INTEGER])
			-- Create with `a_cr' reference.
		do
			cr := a_cr

				-- Setting of page height and width
			height := a_sizing.h
			width := a_sizing.w

				-- Settings of font Color, Face, and Size by default
			set_indent_size (default_indent)
			set_font_color (Black)
			set_normal_font_face
			set_font_size (Default_font_size)
			set_default_margins
			position_top_left
		ensure
			set: cr ~ a_cr
		end

feature -- Access

	height: INTEGER
			-- The current `page_height' in points.

	width: INTEGER
			-- The current `page_width' in points.

	margin_top,
	margin_bottom,
	margin_left,
	margin_right: INTEGER
			-- The page header, footer, left-and-right margin sizes.
			-- MediaPage size				 Print area     Top    Bottom  Sides
			-- 1.A/Letter (U.S.)8.5 x 11 in. 8.2 x 10.6 in. .22 in. .18 in .15 in
			-- https://www.office.xerox.com/userdoc/P540/540Margn.pdf#:~:text=Margins%20Media%20Page%20size%20Print%20area%20Top%20Bottom,287%20mm%205%20mm%205%20mm%205%20mm

	font_color: TUPLE [r, g, b: INTEGER] assign set_font_color
			-- What is the RGB `font_color'?
			-- Default = Black
		attribute
			Result := Black
		end

	font_size: REAL assign set_font_size
			-- The current `font_size' in points.

	font_face: TUPLE [name: STRING; slant, weight: INTEGER] assign set_font_face
			-- The current `font_face' specification.
		attribute
			Result := Font_normal
		end

	max_lines: INTEGER
			-- What are the max number of lines of current PDF PAGE?
		do
			Result := ((height - margin_top - margin_bottom) / font_size).truncated_to_integer
		end

	current_x: INTEGER
	current_y: INTEGER
			-- The current x,y position on the page.

	indent_size: INTEGER
			-- The size of an indent in points.

feature -- Layout

	cell: EV_VERTICAL_BOX
			-- Every page has one `cell'.
		attribute
			create Result
			Result.set_data ("{%"name%":%"cell%"}") -- e.g. {"name":"cbox"}
		end

	cbox: EV_VERTICAL_BOX
			-- Content (i.e. `cbox') box.
		attribute
			create Result
			Result.set_data ("{%"name%":%"cbox%"}") -- e.g. {"name":"cbox"}
		end

	boxes: JSON_ARRAY
			-- Specifications for `boxes' (see `cell_prep').
		attribute
			create Result.make_empty
		end

	widgets: JSON_ARRAY
			-- Specifications for `widgets' (see `cell_prep').
		attribute
			create Result.make_empty
		end

feature -- Layout Operations

	cell_prep
			-- Prepare `cbox' in `cell' for Content.
		note
			design: "[
				The "local" variables used here may (one day) want to become
				client-accessible features on this class. On that day, be sure
				to create them like `cell' and `cbox' with an invariant as well.
				Also, then here, the only step will be to do the proper extends
				and disabling of item expansion.
				]"
		local
			l_mbox: EV_VERTICAL_BOX -- Main-box (entire page)
			l_midbox: EV_HORIZONTAL_BOX -- Holder of left and right margins with `cbox' sandwiched between them.
			l_top, l_bottom: EV_HORIZONTAL_BOX -- Margins
			l_left, l_right: EV_VERTICAL_BOX -- Margins
		-- box-specs
			l_parent: detachable STRING
			l_prefix, l_name: STRING
			l_min_size: INTEGER
			l_is_horizontal: BOOLEAN
			i: INTEGER
		do
		-- create main-box in cell
			l_mbox := new_vbox (Void, "mbox", 0)
		-- add header (top)
			l_top := new_hbox ("mbox", "top", margin_top)
		-- add mid-box (left, cbox, right)
			l_midbox := new_hbox ("mbox", "midbox", 0)
			l_left := new_vbox ("midbox", "left", margin_left)
			l_midbox.extend (cbox)
			l_right := new_vbox ("midbox", "right", margin_right)
		-- add footer (bottom)
			l_bottom := new_hbox ("mbox", "bottom", margin_bottom)
		-- deal with `boxes'
			⟳ ic:boxes ¦
				i := i + 1
				check attached json_string_to_json_object (ic.representation) as al_object then
					create l_prefix.make (12)
					l_prefix.append_character ('b')
					l_prefix.append_string_general (i.out)
					check al_box_array: attached json_object_to_json_array (l_prefix, al_object) as al_box_array then
						⟳ ic_box_object:al_box_array ¦
							 if attached {JSON_OBJECT} ic_box_object as al_box_object then
								if attached al_box_object.string_item ("name") as al_name_item then
									create l_name.make (al_name_item.item.count + 2 + 10)
									l_name.append_string_general (l_prefix)
									l_name.append_character ('_')
									l_name.append_string (al_name_item.item)
								elseif attached al_box_object.string_item ("parent") as al_parent_item then
									l_parent := if al_parent_item.item.same_string ("null") then Void
												else al_parent_item.item end
								elseif attached al_box_object.number_item ("type") as al_type_item then
									l_is_horizontal := al_type_item.item.same_string ("horizontal")
								elseif attached al_box_object.array_item ("layout") as al_layout_array then
									⟳ ic_layout_object:al_layout_array ¦
										if attached {JSON_OBJECT} ic_layout_object as al_layout_object then
											if attached al_layout_object.number_item ("minimum_size") as al_min_size_item then
												l_min_size := al_min_size_item.integer_64_item.to_integer
											end
										end
									⟲
								end
							 end
						⟲
					end
					check has_box_name: attached l_name as al_name then
						new_box (l_parent, al_name, l_min_size, l_is_horizontal).do_nothing
					-- resets for next box
						l_name.wipe_out
						if attached l_parent then
							l_parent.wipe_out
						end
						l_min_size := 0
						l_is_horizontal := False
					end
				end
			⟲
		-- deal with `widgets'
			do_nothing -- for now ...
						-- (this will look like boxes, above)
		end

	new_vbox (a_parent: detachable STRING; a_name: STRING; a_min_size: INTEGER): EV_VERTICAL_BOX
			-- A new vertical box, possibly extended into `a_parent'.
		do
			check is_vertical: attached {EV_VERTICAL_BOX} new_box (a_parent, a_name, a_min_size, False) as al_result then Result := al_result end
		end

	new_hbox (a_parent: detachable STRING; a_name: STRING; a_min_size: INTEGER): EV_HORIZONTAL_BOX
			-- A new horizontal box, possibly extended into `a_parent'.
		do
			check is_vertical: attached {EV_HORIZONTAL_BOX} new_box (a_parent, a_name, a_min_size, True) as al_result then Result := al_result end
		end

	new_box (a_parent_name: detachable STRING; a_name: STRING; a_min_size: INTEGER; a_is_horizontal: BOOLEAN): EV_BOX
			-- Create a `new_box' with `a_name' as child of `a_parent_name' (if any, otherwise use `cell') with `a_min_size'.
		note
			design: "[
				Setting `a_min_size' > 0 indicates that the caller wants to `disable_item_expand' and
				collapse the `new_box' inside the `l_parent_box' to `a_min_size'. Otherwise,
				let the Result expand to fill the `l_parent_box'. Either way--we get a Result box in a parent.
				]"
			EIS: "name=json_prettifier", "src=https://jsonparser.org/"
		require
			unique_name: not attached box_ref (Void, a_name)
		local
			l_parent_box: EV_BOX
		do
		-- get a ref to the `a_parent_name' (or `cell')
			l_parent_box := if attached a_parent_name as al_parent then box_ref_attached (Void, al_parent) else cell end
		-- create new box using `a_is_horizontal' (or not means is-vertical)
			if a_is_horizontal then create {EV_HORIZONTAL_BOX} Result else create {EV_VERTICAL_BOX} Result end
			Result.set_data ("{%"name%":%"" + a_name + "%"}")
		-- put Result in `a_parent'
			l_parent_box.extend (Result)
		-- handle `a_min_size' and `disable_item_expand'
			if a_min_size > 0 then
				if attached {EV_VERTICAL_BOX} l_parent_box then
					Result.set_minimum_height (a_min_size)
				else
					Result.set_minimum_width (a_min_size)
				end
				l_parent_box.disable_item_expand (Result)
			end
		ensure
			child_added_to_parent: (attached box_ref (Void, a_name) as al_box_ref and then attached a_parent_name as al_parent) implies
									al_box_ref.parent ~ box_ref_attached (Void, al_parent)
		end

	box_ref_attached (a_box: detachable EV_BOX; a_name: STRING): EV_BOX
			-- Attached version of `box_ref'.
		do
			check has_box_ref_attached: attached box_ref (a_box, a_name) as al_result then Result := al_result end
		end

	box_ref (a_parent_box: detachable EV_BOX; a_name: STRING): detachable EV_BOX
			-- What is the `box_ref' for `a_name' starting in `a_parent_box'?
		local
			l_target_box: EV_BOX
		do
			l_target_box := if attached a_parent_box then a_parent_box else cell end
			if box_name (l_target_box).same_string (a_name) then
				Result := l_target_box
			else
				across
					l_target_box.new_cursor as ic
				until
					attached Result
				loop
					if attached {EV_BOX} ic.item as al_box and then attached {STRING} al_box.data as al_json then
						check has_json_object: attached json_string_to_json_object (al_json) as al_json_object then
							check has_name_attribute: attached json_object_to_string_attached ("name", al_json_object) as al_name then
								if al_name.same_string (a_name) then
									Result := al_box
								else
									Result := box_ref (al_box, a_name)
								end
							end
						end
					end
				end
			end
		end

feature -- Layout Helpers

	box_name (a_box: EV_BOX): STRING
			-- What is the `box_name' from `a_box' data as json?
		do
			check valid_json: attached {STRING} a_box.data as al_json and then
					attached json_string_to_json_object (al_json) as al_json_object and then
					attached json_object_to_string_attached ("name", al_json_object) as al_name
			then
				Result := al_name
			end
		end

feature -- Settings

	set_font_color (a_rgb: TUPLE [r, g, b: INTEGER])
			-- set `font_color' to `r' ,`g', `b'.
		do
			font_color := a_rgb
			{CAIRO_FUNCTIONS}.cairo_set_source_rgb (cr, a_rgb.r, a_rgb.g, a_rgb.b)
		end

	set_normal_font_face
			-- Set the font face to `Font_normal'.
		do
			set_font_face (Font_normal)
		end

	set_font_face (a_font_spec: TUPLE [name: STRING; slant, weight: INTEGER])
			-- Set the font face to the `a_font_spec' on `cr'
		do
			font_face := a_font_spec
			{CAIRO_FUNCTIONS}.cairo_select_font_face (cr, a_font_spec.name, a_font_spec.slant, a_font_spec.weight)
		end

	set_font_name (a_font_name: STRING)
			-- Set the font face with `a_font_name'.
		do
			font_face := [a_font_name, font_face.slant, font_face.weight]
			set_font_face (font_face)
		end

	set_font_size (a_size: REAL)
			-- Set the font size to `a_size' points on `cr'.
		do
			font_size := a_size
			{CAIRO_FUNCTIONS}.cairo_set_font_size (cr, a_size)
		end

	set_default_margins
			-- Set the default page margins to Xerox standards.
			-- MediaPage size				 Print area     Top    Bottom  Sides
			-- 1.A/Letter (U.S.)8.5 x 11 in. 8.2 x 10.6 in. .22 in. .18 in .15 in
			--
		note
			EIS: "src=https://www.office.xerox.com/userdoc/P540/540Margn.pdf#:~:text=Margins%%20Media%%20Page%%20size%%20Print%%20area%%20Top%%20Bottom,287%%20mm%%205%%20mm%%205%%20mm%%205%%20mm"
		do
			margin_top := (.22 * 72).truncated_to_integer
			margin_bottom := (.18 * 72).truncated_to_integer
			margin_left := (.15 * 72).truncated_to_integer
			margin_right := (.15 * 72).truncated_to_integer
		end

	set_indent_size (n: INTEGER)
			-- Set `indent_size' to `n'.
		do
			indent_size := n
		ensure
			set: indent_size = n
		end

	set_current_x (x: INTEGER)
			-- Sets the `current_x' to `x'.
		do
			current_x := x
			move
		ensure
			set: current_x = x
		end

	set_current_y (y: INTEGER)
			-- Sets the `current_y' to `y'.
		do
			current_y := y
			move
		ensure
			set: current_y = y
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

feature -- Basic Operations

	move
			-- Move to `current_x' and `current_y' on `cr'
		do
			{CAIRO_FUNCTIONS}.cairo_move_to (cr, current_x.to_real, current_y.to_real)
		end

	position_top_left
			-- Position `current_x' and `current_y' to top left.
		do
			current_x := (margin_left.to_real).truncated_to_integer
			current_y := (margin_top.to_real + font_size).truncated_to_integer
			move
		ensure
			x_set: current_x = (margin_left.to_real).truncated_to_integer
			y_set: current_y = (margin_top.to_real + font_size).truncated_to_integer
		end

	down_n_lines (n: INTEGER)
			-- Move down `n' lines.
		do
			current_y := current_y + (font_size.truncated_to_integer * n)
			move
		ensure
			downed: current_y = old current_y + (font_size.truncated_to_integer * n)
		end

	crlf
			-- Perform a CR+LF
		do
			down_n_lines (1)
			current_x := margin_left
			move
		ensure
			carriage_returned: current_x = margin_left
		end

	indent_one
			-- Indent one time.
		do
			indent (1)
			move
		end

	indent (n: INTEGER)
			-- Peform `n' indents based on `indent_size'.
		do
			current_x := current_x + (indent_size * n)
			move
		end

	apply_text (a_text: STRING_32)
			-- Apply `a_text' at `current_x', `current_y'.
		do
			move
			{CAIRO_FUNCTIONS}.cairo_show_text (cr, a_text)
		end

feature {NONE} -- Implementation: Destroy

	dispose
			--<Precursor>
			-- Push out out page.
		do
			{CAIRO_FUNCTIONS}.cairo_show_page (cr)
		end

feature {NONE} -- Implementation

	cr: CAIRO_STRUCT_API
			-- Creation reference.

feature {NONE} -- Implementation: Constants

	default_indent: INTEGER = 50

	Black: TUPLE [r, g, b: INTEGER]
			-- The color `Black' in RGB.
		once
			Result := [0,0,0]
		end

	Font_face_sans: STRING = "Sans"
			-- The Sans font face.

	Font_slant_normal: INTEGER
			-- The normal font slant (i.e. not italic)
		once
			Result := {CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_normal
		end

	Font_weight_normal: INTEGER
			-- The normal font weight (i.e. not bold)
		once
			Result := {CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_normal
		end

	Font_normal: TUPLE [name: STRING; slant, weight: INTEGER]
			-- A normal Sans font face specification.
		once
			Result := [Font_face_sans, Font_slant_normal, Font_weight_normal]
		end

	Default_font_size: REAL = 12.0
			-- The normal or default font point size.

invariant
	cell_is_cell: attached {STRING} cell.data as al_cell and then al_cell.same_string ("{%"name%":%"cell%"}")
	cbox_is_cbox: attached {STRING} cbox.data as al_cbox and then al_cbox.same_string ("{%"name%":%"cbox%"}")

end
