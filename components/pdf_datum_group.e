note
	description: "Group of {PDF_DATUM} items, held by {PDF_DATA}."
	primary_purpose: "[
		The primary purpose for creating this class is a place to park
		{PDF_PAGE_SPEC} references. Otherwise, they are too granular at
		the {PDF_DATUM} level and to coarse at the {PDF_DATA} level. So,
		we need a place to take groups of datum and assign ment a {PDF_PAGE_SPEC}
		reference.
		]"

class
	PDF_DATUM_GROUP

inherit
	JSE_AWARE

create
	default_create,
	make,
	make_from_json

feature {NONE} -- Initialization (JSON)

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		do
			check attached json_string_to_json_object (a_json) as al_object and then
					attached {JSON_ARRAY} json_object_to_json_array ("datum_group", al_object) as al_dg_array then
						page_spec_name := json_array_get_keyed_object_string_attached (al_dg_array, "page_spec_name")
						check attached {JSON_ARRAY} json_array_get_keyed_object_value (al_dg_array, "datums") as al_datum_array then
							⟳ ic:al_datum_array ¦
								datums.force (create {PDF_DATUM}.make_from_json (ic.representation))
							⟲
						end
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := {ARRAY [JSON_METADATA]} <<
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default
												>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := {ARRAY [STRING]} <<
										"page_spec_name",
										"datums"
										>> -- populate with "my_feature_name"
		end

feature -- Status Report

	has_json_input_error: BOOLEAN

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature -- Access

	page_spec_name: STRING
			-- Name of the PDF_PAGE_SPEC this Group is targeted at.
		attribute
			create Result.make_empty
		end

	datums: ARRAYED_LIST [PDF_DATUM]
			-- The list of `datums' grouped by Current
		attribute
			create Result.make (0)
		end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
