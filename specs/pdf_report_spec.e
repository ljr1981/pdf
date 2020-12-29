note
	description: "Specification for a PDF_REPORT"

class
	PDF_REPORT_SPEC

inherit
	PDF_SPEC

	PDF_CONST
		undefine
			default_create
		end

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
			check attached {JSON_OBJECT} json_string_to_json_object (a_json) as al_object then
				set_name (json_object_to_string_attached ("name", al_object))
				set_output_file_name (json_object_to_string_attached ("output_file_name", al_object))
				fill_arrayed_list_of_detachable_any ("page_specs", al_object, page_specs, agent (a_object: JSON_VALUE): PDF_PAGE_SPEC do create Result.make_from_json_value (a_object) end)
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := <<
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
						"output_file_name",
						"page_specs"
						>>
		end

feature -- Access

	type: STRING = "report"

	output_file_name: STRING
			-- The name of the output file.
		attribute
			create Result.make_empty
		ensure
			not_empty: not Result.is_empty
		end

	page_specs: ARRAYED_LIST [PDF_PAGE_SPEC]
			-- Page specification list.
		attribute
			create Result.make (10)
		end

	is_destroyed: BOOLEAN

feature -- Settings

	set_page_specs (v: ARRAYED_LIST [detachable ANY])
			-- Set `page_specs' from `v'.
		do
			page_specs.wipe_out
			⟳ ic:v ¦
				if attached {PDF_PAGE_SPEC} ic as al_item then
					page_specs.force (al_item)
				end
			⟲
		end

	set_output_file_name (s: like output_file_name)
			-- Set `output_file_name' from `s'.
		require
			not_empty: not s.is_empty
			-- valid-file-name test? {PLAIN_TEXT_FILE}
		do
			output_file_name := s
		ensure
			set: output_file_name.same_string (s)
		end

feature -- Basic Operations

	print_to_file (a_file_name, a_json: STRING)
			-- `print' Current to `a_file_name' PDF file.
		do
			file_name := a_file_name
			page_height := US_8_by_11_page_height
			page_width := US_8_by_11_page_width
			check attached json_string_to_json_object (a_json) as al_object then

			end
		end

feature {NONE} -- Implementation

	file_name: STRING
		attribute
			create Result.make_empty
		end

	page_width, page_height: INTEGER

	set_surface_size (h, w: INTEGER)
			-- Set the size of the `surface' to `h' and `w' (height and width).
		note
			C_API_description: "[
				Changes the size of a PostScript surface for the current (and subsequent) pages.
				
				This function should only be called before any drawing operations have been 
				performed on the current page. The simplest way to do this is to call this 
				function immediately after creating the surface or immediately after completing 
				a page with either Context.show_page() or Context.copy_page().
				]"
		do
			{CAIRO_PDF_FUNCTIONS_API}.cairo_pdf_surface_set_size (surface, w, h)
		end


	surface: CAIRO_SURFACE_STRUCT_API
			-- PDF Drawing Surface.
		require
			has_file_name: not file_name.is_empty
			not_destroyed: not is_destroyed
		once ("OBJECT")
			Result := {CAIRO_PDF_FUNCTIONS}.cairo_pdf_surface_create(file_name, page_width, page_height)
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
