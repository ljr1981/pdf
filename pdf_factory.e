note
	description: "A Factory for creating PDF Documents."

class
	PDF_FACTORY

inherit
	PDF_CONST
		redefine
			default_create
		end

	DISPOSABLE
		undefine
			default_create
		end

create
	default_create,
	make,
	make_us_std_with_name,
	make_us_std

feature {NONE} -- Initialization

	make_us_std_with_name (a_file_name: STRING)
			-- Initialize PDF with `a_file_name' as US Std
		require
			not_destroyed: not is_destroyed
		do
			file_name := a_file_name
			make_us_std
		end

	make_us_std
			-- Make PDF as US 8.5 x 11
		require
			not_destroyed: not is_destroyed
		do
			default_create
		end

	make (a_file_name: STRING; a_height, a_width: INTEGER)
			-- Initialize PDF with `a_file_name' and `a_height', `a_width'.
		require
			not_destroyed: not is_destroyed
		do
			page_height := a_height
			page_width := a_width
			file_name := a_file_name
			cr.do_nothing
			first_page
		ensure
			not_destroyed: not is_destroyed
			first_page_created: is_first_page_created
		end

	default_create
			--<Precursor>
			-- A `make_us_std' by default.
		require else
			not_destroyed: not is_destroyed
		do
			Precursor
			page_height := US_8_by_11_page_height
			page_width := US_8_by_11_page_width
			cr.do_nothing
			first_page
		ensure then
			not_destroyed: not is_destroyed
			first_page_created: is_first_page_created
		end

feature -- Access

	page_height: INTEGER assign set_page_height
			-- The `page_height' in points.

	page_width: INTEGER assign set_page_width
			-- The `page_width' in points.

	file_name: STRING assign set_file_name
			-- The `file_name' of PDF.
		require
			not_destroyed: not is_destroyed
		attribute
			Result := "pdffile.pdf"
		end

	page_count: INTEGER
			-- What is the current `page_count'?

feature -- Factory Products

	page: PDF_PAGE
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

feature {NONE} -- Implementation: Pagination

	page_make
		do
			create current_page.make (cr, [page_height, page_width])
			page_count := page_count + 1
		end

feature -- Status Report

	is_destroyed: BOOLEAN
			-- Is the `cr' and `surface' destroyed?
		do
			Result := is_destroyed_imp
		end

	is_first_page_created: BOOLEAN
			-- Has the `first_page' been created?

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

	set_file_name (a_value: STRING)
			--
		require
			not_destroyed: not is_destroyed
		do
			file_name := a_value
		ensure
			set: file_name.same_string (a_value)
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
			{CAIRO_FUNCTIONS}.cairo_destroy (cr)
			{CAIRO_FUNCTIONS}.cairo_surface_destroy (surface)
			is_destroyed_imp := True
		ensure
			destroyed: is_destroyed
		end

feature {NONE} -- Implementation: Status Report

	is_destroyed_imp: BOOLEAN
			-- Internal imp of `is_destroyed'.

feature {NONE} -- Implementation

	surface: CAIRO_SURFACE_STRUCT_API
			-- PDF Drawing Surface.
		require
			not_destroyed: not is_destroyed
		once ("OBJECT")
			check has_surface_ptr:
				attached {CAIRO_PDF_FUNCTIONS_API}.cairo_pdf_surface_create((create {C_STRING}.make (file_name)).item, page_width, page_height) as al_surface_ptr and then
				al_surface_ptr /= default_pointer
			then
				create Result.make_by_pointer (al_surface_ptr)
			end
		ensure
			has_surface: {CAIRO_FUNCTIONS}.cairo_surface_status (Result) = {CAIRO_STATUS_ENUM_API}.cairo_status_success
		end

	cr: CAIRO_STRUCT_API
			-- `cr' is  reference list with count to `surface's.
		note
			EIS: "name=cr", "src=https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-create"
		require
			not_destroyed: not is_destroyed
		once ("OBJECT")
			check has_surface_then_cr: attached surface as al_surface and then
				attached {CAIRO_FUNCTIONS}.cairo_create (surface) as al_result and then
					{CAIRO_FUNCTIONS}.cairo_status (al_result) = {CAIRO_STATUS_ENUM_API}.cairo_status_success
			then
				Result := al_result
			end
		end

end
