note
	description: "Representation of a PDF Page."

class
	PDF_PAGE

inherit
	DISPOSABLE

create
	make

feature {PDF_FACTORY} -- Initialize

	make (a_cr: CAIRO_STRUCT_API; a_sizing: TUPLE [h, w: INTEGER])
			-- Create with `a_cr' reference.
		do
			cr := a_cr

				-- Setting of page height and width
			page_height := a_sizing.h
			page_width := a_sizing.w

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

	page_height: INTEGER
			-- The current `page_height' in points.

	page_width: INTEGER
			-- The current `page_width' in points.

	page_header_size,
	page_footer_size,
	page_left_margin_size,
	page_right_margin_size: INTEGER
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
			Result := ((page_height - page_header_size - page_footer_size) / font_size).truncated_to_integer
		end

	current_x: INTEGER
	current_y: INTEGER
			-- The current x,y position on the page.

	indent_size: INTEGER
			-- The size of an indent in points.

feature -- Constants

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

	Default_font_size: REAL = 20.0
			-- The normal or default font point size.

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
			page_header_size := (.22 * 72).truncated_to_integer
			page_footer_size := (.18 * 72).truncated_to_integer
			page_left_margin_size := (.15 * 72).truncated_to_integer
			page_right_margin_size := (.15 * 72).truncated_to_integer
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

	move
			-- Move to `current_x' and `current_y' on `cr'
		do
			{CAIRO_FUNCTIONS}.cairo_move_to (cr, current_x.to_real, current_y.to_real)
		end

feature -- Status Report

feature -- Basic Operations

	position_top_left
			-- Position `current_x' and `current_y' to top left.
		do
			current_x := (page_left_margin_size.to_real).truncated_to_integer
			current_y := (page_header_size.to_real + font_size).truncated_to_integer
			move
		ensure
			x_set: current_x = (page_left_margin_size.to_real).truncated_to_integer
			y_set: current_y = (page_header_size.to_real + font_size).truncated_to_integer
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
			current_x := page_left_margin_size
			move
		ensure
			carriage_returned: current_x = page_left_margin_size
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

end
