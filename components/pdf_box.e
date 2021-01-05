note
	description: "Represenation of a Layout Box for a PDF_PAGE_SPEC"

class
	PDF_BOX

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
		local
			l_json: STRING
			l_box_array: JSON_ARRAY
		do
		-- A small dance to remove control characters (prettifying) from json string.
			create l_json.make_empty
			⟳ ic:a_json ¦ if not ic.is_control then l_json.append_character (ic) end ⟲
			l_json.replace_substring_all (" ", "")
		-- Ensure our json starts with box key for its array ...
			l_json := if l_json.has_substring ("{%"box%":[") then
				l_json
			else
				"{%"box%":[" + a_json + "]}"
			end
		-- Now, we can continue building our box ...
			check attached json_string_to_json_object (l_json) as al_object then
				check al_box_array: attached json_object_to_json_array ("box", al_object) as al_box_array then
					name := json_array_get_keyed_object_string_attached (al_box_array, "name")
					parent := json_array_get_keyed_object_string (al_box_array, "parent")
					type := json_array_get_keyed_object_string_attached (al_box_array, "type")
					if attached json_array_get_keyed_object_object (al_box_array, "layout") as al_value then
						create layout.make_from_json ("{%"layout%":" + al_value.representation + "}")
					end
				end
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := {ARRAY [JSON_METADATA]} <<
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default
												>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := {ARRAY [STRING]} <<
										"name",
										"parent",
										"type",
										"layout"
										>> -- populate with "my_feature_name"
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature -- Access

	name: STRING
		attribute
			create Result.make_empty
		end

	parent: detachable STRING

	type: STRING
		attribute
			Result := "vertical"
		end

	layout: PDF_LAYOUT
		attribute
			create Result
		end

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
