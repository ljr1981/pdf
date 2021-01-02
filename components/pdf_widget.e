note
	description: "Represenation of a JSON-defined Widget to place a JSON-based datum in."

class
	PDF_WIDGET

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
			check attached json_string_to_json_object (a_json) as al_object then
				set_widget_id (json_object_to_string_attached ("widget_id", al_object))
				set_type (json_object_to_string ("type", al_object))
				set_text (json_object_to_string ("text", al_object))
				set_inside_border_padding (json_object_to_integer ("inside_border_padding", al_object))
				set_outside_border_padding (json_object_to_integer ("outside_border_padding", al_object))
				set_minimum_height (json_object_to_integer ("minimum_height", al_object))
				set_minimum_width (json_object_to_integer ("minimum_width", al_object))
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := {ARRAY [JSON_METADATA]} <<
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default
												>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := <<
						"widget_id",
						"type",
						"text",
						"minimum_height",
						"minimum_width",
						"inside_border_padding",
						"outside_border_padding"
						>> -- populate with "my_feature_name"
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature -- Access

	wid: INTEGER
			-- What is the `wid' (`widget_id')?
		do
			if widget_id.is_number_sequence then
				Result := widget_id.to_integer
			end
		end

	widget_id: STRING
			-- What is the `widget_id' of Current?
		attribute
			create Result.make_empty
		end

	type: detachable STRING assign set_type
			-- Does Widget have `text'
		note

		attribute
			Result := Void
		end

	type_attached: attached like type
			--
		do
			check attached type as al_result then Result := al_result end
		end

	types_enum: ARRAY [STRING]
			-- Enumeraed types of `type'.
		once
			Result := <<"label">>
		end

	text: detachable STRING assign set_text
			-- Does Widget have `text'
		note

		attribute
			Result := Void
		end

	minimum_height: INTEGER assign set_minimum_height
			-- What is the minimum_height of Widget?

	minimum_width: INTEGER assign set_minimum_width
			-- What is the minimum_width of Widget?

	inside_border_padding: INTEGER assign set_inside_border_padding
			-- What is the `inside_border_padding' in Points?

	outside_border_padding: INTEGER assign set_outside_border_padding
			-- What is the `inside_border_padding' in Points?

feature -- Measurement

feature -- Status report

	has_error: BOOLEAN
			-- Does current have any error?
		do
			Result := bad_type
			Result := Result or bad_wid
			Result := Result or bad_paddings
			Result := Result or bad_minimums
			if Result then
				error_message.wipe_out
				if bad_type and then attached type as al_value then
					error_message.append_string_general ("Type: " + al_value.out + "%N")
				end
				if attached text as al_value then
					error_message.append_string_general ("Text: " + al_value.out + "%N")
				else
					error_message.append_string_general ("Text: null%N")
				end
				error_message.append_string_general ("WID: " + wid.out + "%N")
				error_message.append_string_general ("min Ht/Wid: " + minimum_height.out + "," + minimum_width.out + "%N")
				error_message.append_string_general ("Padding In/Out: " + inside_border_padding.out + "," + outside_border_padding.out + "%N")
			end
		end

	error_message: STRING
			-- Any errors logged here.
		attribute
			create Result.make_empty
		end

	bad_type: BOOLEAN do Result := not good_type end

	good_type: BOOLEAN
			-- Is the type of `type' bad?
		do
			Result := attached type as al_type implies
						∃ ic:Types_enum ¦ ic.same_string (al_type)
		end

	bad_wid: BOOLEAN do Result := not good_wid end

	good_wid: BOOLEAN
			-- Is the `wid' based on `widget_id' bad?
		do
			Result := (not widget_id.is_empty) implies widget_id.is_number_sequence
		end

	bad_paddings: BOOLEAN do Result := not good_paddings end

	good_paddings: BOOLEAN
			-- Are either of the padding values bad (non-positive)?
		do
			Result := (inside_border_padding >= 0) and then (outside_border_padding >= 0)
		end

	bad_minimums: BOOLEAN do Result := not good_minimums end

	good_minimums: BOOLEAN
			-- Are either of the minimum values bad (non-positive)?
		do
			Result := (minimum_height >= 0) or else (minimum_width >= 0)
		end

feature -- Status setting

	set_widget_id (v: like widget_id)
			--
		do
			widget_id := v
		ensure
			set: widget_id ~ v
		end

	set_type (v: like type)
			--
		do
			type := v
			has_error.do_nothing
		ensure
			set: type ~ v
		end

	set_text (v: like text)
			--
		do
			text := v
		ensure
			set: text ~ v
		end

	set_minimum_height (v: like minimum_height)
			--
		do
			minimum_height := v
		ensure
			set: minimum_height ~ v
		end

	set_minimum_width (v: like minimum_width)
			--
		do
			minimum_width := v
		ensure
			set: minimum_width ~ v
		end

	set_inside_border_padding (v: like inside_border_padding)
			--
		do
			inside_border_padding := v
		ensure
			set: inside_border_padding ~ v
		end

	set_outside_border_padding (v: like outside_border_padding)
			--
		do
			outside_border_padding := v
		ensure
			set: outside_border_padding ~ v
		end

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
