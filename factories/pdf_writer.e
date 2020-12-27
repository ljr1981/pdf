note
	description: "Facilities for writing PDF files"

class
	PDF_WRITER

inherit
	PDF_CAIRO_FUNCTIONS

	PDF_CONST

	DISPOSABLE

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_pdf_file_name: STRING; a_height, a_width: INTEGER)
			-- Create Current with file-name and height/width.
		do
			surface := new_surface (a_pdf_file_name, a_width, a_height)
			last_cr := cr
		end

feature -- Cleanup Operations

	dispose
			--<Precursor>
			-- Handle the `destroy' of the Factoy.
		note
			design: "[
				It is critical to destroyed both the `cr' and `surface' references
				before an instance of this class is garbage-collected. See the EIS
				link below for more details.
				]"
			EIS: "name=cr_destroy", "src=https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-destroy"
		require else
			not_destroyed: not is_destroyed
		do
			destroy
		end

	destroy
			-- Ensure `surface' and `cr' are properly destroyed.
		require
			not_destroyed: not is_destroyed
		do
			if attached surface as al_surface then
				{CAIRO_FUNCTIONS}.cairo_destroy (cr)
				{CAIRO_FUNCTIONS}.cairo_surface_destroy (al_surface)
			end
			is_destroyed_imp := True
		ensure
			destroyed: is_destroyed
		end

feature -- Status Report

	is_destroyed: BOOLEAN
			-- Is Current destroyed?
		do
			Result := is_destroyed_imp
		end

	is_first_page_created: BOOLEAN
			-- Has the `first_page' been created?

feature -- Factory Products

	page: attached like current_page
			-- An attached version of `current_page' as `page'.
		do
			check has_current_page: attached current_page as al_result then
				Result := al_result
			end
		end

	current_page: detachable PDF_PAGE
			-- A possible `current_page', depending on `first_page' being called first.

	first_page
			-- Make a `first_page' for current PDF.
		require
			no_pages: not is_first_page_created
		do
			page_make
			is_first_page_created := True
		ensure
			is_first_page_created = True
		end

	next_page
			-- Make `next_page' for current PDF.
		require
			is_first_page_created
		do
			{CAIRO_FUNCTIONS}.cairo_show_page(cr)
			page_make
		end

feature -- Access

	page_height: INTEGER assign set_page_height
			-- The `page_height' in points.

	page_width: INTEGER assign set_page_width
			-- The `page_width' in points.

	page_count: INTEGER
			-- What is the current `page_count'?

feature -- Settings

	set_page_height (a_value: INTEGER)
			--
		require
			not_destroyed: not is_destroyed
		do
			page_height := a_value
		ensure
			set: page_height = a_value
		end

	set_page_width (a_value: INTEGER)
			--
		require
			not_destroyed: not is_destroyed
		do
			page_width := a_value
		ensure
			set: page_width = a_value
		end

feature {NONE} -- Implementation: Pagination

	page_make
		do
			create current_page.make (cr, [page_height, page_width])
			page_count := page_count + 1
		end

feature {NONE} -- Implementation: Status Report

	is_destroyed_imp: BOOLEAN
			-- Internal imp of `is_destroyed'.

feature {NONE} -- Implementation

	surface: detachable CAIRO_SURFACE_STRUCT_API
			-- The last-created `surface'

	new_surface (a_name: STRING; a_width, a_height: INTEGER): attached like surface
			-- Create a `new_surface' targeted to `a_name' file with `a_width' and `a_height'.
		require
			not_destroyed: not is_destroyed
		once ("OBJECT")
			Result := {CAIRO_PDF_FUNCTIONS}.cairo_pdf_surface_create(a_name, a_width, a_height)
		ensure
			has_surface: {CAIRO_FUNCTIONS}.cairo_surface_status (Result) = {CAIRO_STATUS_ENUM_API}.cairo_status_success
		end

	last_cr: detachable like cr
			-- The last-used `cr'

	cr: CAIRO_STRUCT_API
			-- `cr' is a "Cairo-context" rendering-device state and shape coordinates.
		note
			feature_name_explanation: "[
				Why not just call this feature `cairo_context' then?
				
				Even though this is a `cairo_context', we retain the name `cr' because it is a
				coding-convention within the cairo C API and is more easily recognizable when
				reading the "wrap_cairo" library (e.g. {CAIRO_FUNCTIONS_API}). For example:
				
				{CAIRO_FUNCTIONS_API}.c_cairo_line_to (cr: POINTER; x, y: REAL_64)
				
				Understanding what `cr' is helps you to know what is needed when calling these
				functions. Moreover, it helps you understand that need and how to structure
				your own code when extending classes like {PDF_CAIRO_FUNCTIONS}.
				]"
			EIS: "name=cr", "src=https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-create"
			EIS: "name=cairo_t", "src=https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-t"
			description: "[
				A cairo_t contains the current state of the rendering device, including coordinates 
				of yet to be drawn shapes.

				Cairo contexts, as cairo_t objects are named, are central to cairo and all drawing
				with cairo is always done to a cairo_t object.

				Memory management of cairo_t is done with cairo_reference() and cairo_destroy().

				Since: 1.0
				]"
		require
			not_destroyed: not is_destroyed
			has_surface: attached surface
		once ("OBJECT")
			check has_surface_then_cr: attached surface as al_surface and then
				attached {CAIRO_FUNCTIONS}.cairo_create (al_surface) as al_result and then
					{CAIRO_FUNCTIONS}.cairo_status (al_result) = {CAIRO_STATUS_ENUM_API}.cairo_status_success
			then
				Result := al_result
			end
		end

end
