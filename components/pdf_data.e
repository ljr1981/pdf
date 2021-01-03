note
	description: "Representation of a collection of Datum with Widgets"

class
	PDF_DATA

inherit
	JSE_AWARE

	PDF_CONST

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
		do
			check attached json_string_to_json_object (a_json) as al_object then
			-- Load `widgets' ...
				⟳ ic:json_object_to_json_array ("widgets", al_object) ¦
					widgets.force (create {PDF_WIDGET}.make_from_json (ic.representation))
				⟲
			-- Load `data' as instances of {PDF_DATUM} ...
				⟳ ic:json_object_to_json_array ("data", al_object) ¦
					check attached json_string_to_json_object (ic.representation) as al_ith and then
							attached json_object_to_json_object (al_ith, 1) as al_datum
					then
						l_json := al_datum.representation
					end
					data.force (create {PDF_DATUM}.make_from_json (l_json))
				⟲
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
										"widgets",
										"data"
										>> -- populate with "my_feature_name"
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature -- Access

	widgets: ARRAYED_LIST [PDF_WIDGET]
			-- A list of `widgets' for this data-stream.
		attribute
			create Result.make (100)
		end

	data: ARRAYED_LIST [PDF_DATUM]
			-- A list of `data' for this data-stream.
		attribute
			create Result.make (1_000)
		end

feature -- Measurement

feature -- Status report

	has_json_input_error: BOOLEAN
			--<Precursor>
			-- Compute Result based on `widgets' and `data' errors.
		do
			error_message.wipe_out
		-- Gather error messages from all widgets
			⟳ ic:widgets ¦
				if ic.has_json_input_error then
					error_message.append_string_general (ic.error_message)
					Result := True
				end
			⟲
		-- Gather error messages from all data
			⟳ ic:data ¦
				if ic.has_json_input_error then
					error_message.append_string_general (ic.error_message)
					Result := True
				end
			⟲
		end

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
