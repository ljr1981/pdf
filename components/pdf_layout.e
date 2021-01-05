note
	description: "Layout specifications"

class
	PDF_LAYOUT

inherit JSE_AWARE

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
			check attached json_string_to_json_object (a_json) as al_object then
				check al_array: attached json_object_to_json_array ("layout", al_object) as al_array then
					⟳ ic_layout_object:al_array ¦
						 if attached {JSON_OBJECT} ic_layout_object as al_layout_object then
							if attached al_layout_object.number_item ("minimum_size") as al_minimum_size then
								minimum_size := al_minimum_size.integer_64_item.to_integer
							end
						 end
					⟲
				end
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := {ARRAY [JSON_METADATA]} <<
												create {JSON_METADATA}.make_text_default
												>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := {ARRAY [STRING]} <<
										"minimum_size"
										>> -- populate with "my_feature_name"
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature -- Access

	minimum_size: INTEGER

feature -- Measurement

feature -- Status report

	has_json_input_error: BOOLEAN
			--<Precursor>

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
