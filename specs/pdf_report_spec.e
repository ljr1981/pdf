note
	description: "Specification for a PDF_REPORT"

class
	PDF_REPORT_SPEC

inherit
	PDF_SPEC

create
	default_create,
	make_from_json

feature {NONE} -- Initialization

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		do
			check attached json_string_to_json_object (a_json) as al_object then
				set_name (json_object_to_string_attached ("name", al_object))
				fill_arrayed_list_of_detachable_any ("page_specs", al_object, page_specs, agent (a_object: JSON_VALUE): PDF_PAGE_SPEC do create Result.make_from_json_value (a_object) end)
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := <<
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
--						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING_8]
			--<Precursor>
		do
			Result := <<
--						"height",
--						"width",
--						"indent_size",
--						"font_color",
--						"font_face",
--						"font_size",
--						"margin_top",
--						"margin_bottom",
--						"margin_left",
						"name",
						"page_specs"
						>>
		end

feature -- Access

	type: STRING = "report"

	page_specs: ARRAYED_LIST [PDF_PAGE_SPEC]
			-- Page specification list.
		attribute
			create Result.make (10)
		end

feature -- Settings

	set_page_specs (v: ARRAYED_LIST [detachable ANY])
			-- Set `page_specs' from `v'.
		do
			across
				v as ic
			from
				page_specs.wipe_out
			loop
				if attached {PDF_PAGE_SPEC} ic.item as al_item then
					page_specs.force (al_item)
				end
			end
		end

end
