note
	description: "Facilities for writing PDF files"

class
	PDF_WRITER

inherit
	JSE_AWARE				-- How to be a JSON_TRANSFORMABLE thing
		redefine
			make_from_json_value
		end

	PDF_CAIRO_FUNCTIONS		-- How to interop with Cairo

	PDF_CONST				-- Some useful constants

	DISPOSABLE				-- Ensure what happens when destroyed/disposed

create
	default_create,			-- An empty PDF Writer
	make,					-- A PDF Writer with name and page-sizing
	make_from_json,			-- A PDF Writer spec'd-out from json-string spec
	make_from_json_value	-- A PDF Writer conforming to a passed {JSON_VALUE} as spec

feature {NONE} -- Initialization

	make_from_json_value (a_object: JSON_VALUE)
			--<Precursor
		do
			Precursor (a_object)
		ensure then
			not_has_surface: not has_surface
			not_has_cr: not has_cr
		end

	make_from_json (a_json: STRING)
			--<Precursor>
			-- The `a_json' is a `report_spec'.
		note
			warning: "[
				In order to make a `surface' with a `cr', we have to make an assumption.
				We assume that there is at least one page-spec in the report-spec. Moreover,
				we assume that the first page-spec (or only, if just one) is the "starting"
				page. Now, this is okay (for the moment) because we can adjust the
				settings on the `surface' before we start using the `cr' to make pages
				from the page-specs. We can even change to another page-spec and then
				redefine the `surface' and `cr' accordingly.
				
				We make these assumptions because we want this creation feature to
				have the same ensure as the standard `make'.
				]"
		require else
			not_empty: not a_json.is_empty
			valid_json: attached (create {JSON_PARSER}.make_with_string (a_json)) as al_parser and then al_parser.is_valid
		do
			create report_spec.make_from_json (a_json)
			surface := new_surface (report_spec_attached.output_file_name, us_8_by_11_page_width, us_8_by_11_page_height)
			last_cr := cr
			⟳ ic_page_spec:report_spec_attached.page_specs ¦
				page_make_with_cr (ic_page_spec)
				page_templates.force (current_cr_page_attached.twin)
			⟲
		end

	make (a_pdf_file_name: STRING; a_height, a_width: INTEGER)
			-- Create Current with file-name and height/width.
		require
			not_empty: not a_pdf_file_name.is_empty
			positive_size: a_height > 0 and a_width > 0
			not_has_surface : not has_surface
			not_has_cr: not has_cr
		do
			surface := new_surface (a_pdf_file_name, a_width, a_height)
			last_cr := cr
		ensure
			has_surface: has_surface
			has_cr: has_cr
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := <<
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := <<
						"report_spec"
						>>
		end

feature -- Data Loading

	load_pdf_data (a_json: STRING)
			-- Loads `pdf_data' from `a_json'.
		do
			create pdf_data.make_from_json (a_json)
		end

	pdf_data: detachable PDF_DATA
			-- The `pdf_data' for Current after `load_pdf_data'
			-- 	with possible errors.

	pdf_data_attached: attached like pdf_data
			-- The attached version of `pdf_data'.
		do
			check attached pdf_data as al_result then Result := al_result end
		end

feature -- Data Processing (report generation in-memory)

	page_templates: ARRAYED_LIST [PDF_PAGE]
			-- Empty `page_templates' as a source of empty pages
			-- for `process_data'.
		attribute
			create Result.make (10)
		end

	pages: ARRAYED_LIST [PDF_PAGE]
			-- The `pages' generated from `last_data'
		attribute
			if attached pdf_data as al_pdf_data then
				create Result.make (al_pdf_data.data.count)
			else
				create Result.make (0)
			end
		end

	process_data
			-- For each `last_data_json_object' item,
			-- create a copy of a {PDF_PAGE} template.
		do
		-- each data item ...
		-- determine which page to use from data
		-- set `surface' attributes from selected page
		-- add the current data item
		end

feature -- Report finalization

feature -- Cleanup Operations

	output_pdf
			-- Output PDF by destroy/dispose
		do
			dispose
		end

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
			-- Has the `first_cr_page' been created?

	has_surface: BOOLEAN
			-- Has `surface' been created yet?
		do
			Result := attached surface
		end

	has_cr: BOOLEAN
			-- has `cr' been created yet?
		do
			Result := attached last_cr
		end

feature -- Factory Products

	current_cr_page_attached: attached like current_cr_page
			-- An attached version of `current_cr_page' as `current_cr_page_attached'.
		require
			has_surface: has_surface
			has_cr: has_cr
		do
			check has_current_page: attached current_cr_page as al_result then
				Result := al_result
			end
		ensure
			has_surface: has_surface
			has_cr: has_cr
		end

	current_cr_page: detachable PDF_PAGE
			-- A possible `current_cr_page', depending on `first_cr_page' being called first.

	first_cr_page
			-- Make a `first_cr_page' for current PDF.
		require
			no_pages: not is_first_page_created
			has_surface: has_surface
			has_cr: has_cr
		do
			if attached report_spec_attached.page_specs [1] as al_page_spec then
				page_make_with_cr (al_page_spec)
			else
				page_make_with_cr (Void)
			end
			is_first_page_created := True
		ensure
			is_first_page_created
			has_surface: has_surface
			has_cr: has_cr
		end

	next_cr_page (a_page_spec: detachable PDF_PAGE_SPEC)
			-- Make `next_cr_page' for current PDF.
		require
			is_first_page_created
			has_surface: has_surface
			has_cr: has_cr
		do
			{CAIRO_FUNCTIONS}.cairo_show_page(cr)
			page_make_with_cr (a_page_spec)
		ensure
			is_first_page_created
			has_surface: has_surface
			has_cr: has_cr
		end

feature -- Access: JSON-able

	report_spec_attached: attached like report_spec
			-- Attached version of `report_spec'.
		do
			check attached report_spec as al_result then Result := al_result end
		end

	report_spec: detachable PDF_REPORT_SPEC
			-- Possible repor specification.
			--	(usually coming from JSON spec)

feature -- Access: Generated

	page_height: INTEGER assign set_page_height
			-- The `page_height' in points.

	page_width: INTEGER assign set_page_width
			-- The `page_width' in points.

	page_count: INTEGER
			-- What is the current `page_count'?
		require
			has_surface: has_surface
			has_cr: has_cr
		do
			Result := pages.count
		end

feature -- Status Report

	has_json_input_error: BOOLEAN
			--<Precursor>
			-- What are the cummulative errors of `pdf_data' and `report_spec'
		do
			if attached report_spec as al_report_spec and then al_report_spec.has_json_input_error then
				Result := True
				error_message.append_string_general (al_report_spec.error_message)
			end
			if attached pdf_data as al_pdf_data and then al_pdf_data.has_json_input_error then
				Result := True
				error_message.append_string_general (al_pdf_data.error_message)
			end
		end

feature -- Settings

	set_page_height (a_value: INTEGER)
			-- Set current `page_height' to `a_value' (in points)
		require
			not_destroyed: not is_destroyed
			positive: a_value > 0
		do
			page_height := a_value
		ensure
			set: page_height = a_value
		end

	set_page_width (a_value: INTEGER)
			-- Set current `page_width' to `a_value' (in points)
		require
			not_destroyed: not is_destroyed
			positive: a_value > 0
		do
			page_width := a_value
		ensure
			set: page_width = a_value
		end

feature {NONE} -- Implementation: Pagination

	page_make_with_cr (a_page_spec: detachable PDF_PAGE_SPEC)
			-- Make a new `current_cr_page' item.
		require
			has_surface: has_surface
			has_cr: has_cr
		do
			if attached a_page_spec then
				-- We were passed a page_spec
				create current_cr_page.make_from_page_spec (cr, a_page_spec)
			elseif not report_spec_attached.page_specs.is_empty then
				-- We can assume a page_spec
				if attached report_spec_attached.page_specs [1] as al_first_page_spec then
					create current_cr_page.make_from_page_spec (cr, al_first_page_spec)
				end
			else
				-- We have no page_spec, so we create whatever our default is
				create current_cr_page.make (cr, [page_height, page_width])
			end
		ensure
			same_page: attached current_cr_page
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
			not_empty: not a_name.is_empty
			positive_size: a_width > 0 and a_height > 0
			not_destroyed: not is_destroyed
			not_has_surface: not has_surface
		once ("OBJECT")
			Result := {CAIRO_PDF_FUNCTIONS}.cairo_pdf_surface_create(a_name, a_width, a_height)
		ensure
			success: {CAIRO_FUNCTIONS}.cairo_surface_status (Result) = {CAIRO_STATUS_ENUM_API}.cairo_status_success
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
			has_surface: has_surface
		once ("OBJECT")
			check has_surface_then_cr: attached surface as al_surface and then
				attached {CAIRO_FUNCTIONS}.cairo_create (al_surface) as al_result and then
					{CAIRO_FUNCTIONS}.cairo_status (al_result) = {CAIRO_STATUS_ENUM_API}.cairo_status_success
			then
				Result := al_result
			end
		end

end
