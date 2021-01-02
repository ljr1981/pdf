note
	description: "A single report item 'record' or Datum"

class
	PDF_DATUM

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
			l_array: JSON_ARRAY
		do
			check attached json_string_to_json_object (a_json) as al_object then
				l_array := json_object_to_json_array ("datum", al_object)
				⟳ ic:l_array.array_representation ¦
					if attached {JSON_OBJECT} ic as al_array_object then
						if al_array_object.has_key (create {JSON_STRING}.make_from_string ("text")) and then attached json_object_to_string ("text", al_array_object) as al_text then
							text := al_text
						elseif al_array_object.has_key (create {JSON_STRING}.make_from_string ("size")) and then attached json_object_to_integer ("size", al_array_object) as al_size then
							size := al_size
						elseif al_array_object.has_key (create {JSON_STRING}.make_from_string ("wid")) and then attached json_object_to_string ("wid", al_array_object) as al_wid then
							widget_id := al_wid
						elseif al_array_object.has_key (create {JSON_STRING}.make_from_string ("font_face")) and then attached json_object_to_json_array ("font_face", al_array_object) as al_array then
							-- EXAMPLE: {"font_face":["Courier",1,2]}
							check attached {JSON_STRING} al_array [1] as al_face and then
									attached {JSON_NUMBER} al_array [2] as al_slant and then
									attached {JSON_NUMBER} al_array [3] as al_weight
							then
								set_font_face ([al_face.item, al_slant.integer_64_item.to_integer, al_weight.integer_64_item.to_integer])
							end
						end
					end
				⟲
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := {ARRAY [JSON_METADATA]} <<
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default,
												create {JSON_METADATA}.make_text_default
												>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := {ARRAY [STRING]} <<
										"text",
										"size",
										"font_face"
										>> -- populate with "my_feature_name"
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do

		end

feature -- Access

	text: STRING assign set_text
		attribute
			create Result.make_empty
		end

	size: REAL assign set_size

	font_face: detachable TUPLE [name: STRING; slant, weight: INTEGER]
			-- Possible `font_face', which negates need for `widget'
			--	and overrides `widget' if it has a `font_face' defined.
		note
			see_also: "The `widget' feature note for interaction below."
			EIS: "name=slant_normal", "src=https://cairod.github.io/cairoD/api/cairo/c/cairo/cairo_font_slant_t.CAIRO_FONT_SLANT_NORMAL.html"
			EIS: "name=weight_normal", "src=https://cairod.github.io/cairoD/api/cairo/c/cairo/cairo_font_weight_t.CAIRO_FONT_WEIGHT_NORMAL.html"
		attribute
			Result := ["Courier", {CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_normal, {CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_normal]
		end

	widget_id: detachable STRING assign set_widget_id
			-- An ID (or name/code) of a {PDF_WIDGET} (see `widget').
		note
			interaction_design: "[
				The datum JSON ought to only ever have the "ID" of the `widget' (below).
				Once a set of defined PDF_WIDGET items is "known", then the collection
				of PDF_DATUM items can be traversed and a reference set to the proper
				widget, which will then supply anything the datum needs (which might be
				nothing at all--TBD)
				]"
		attribute
			Result := Void
		end

	widget: detachable PDF_WIDGET
			-- Possible `widget', which must have a `font_face'!?
		note
			interaction: "[
				This feature logically interacts with `font_face'. There are a number
				of posible logical outcomes where defining `font_face' is concerned.
				
				1. If widget has font-face, then widget.font_face overrides `font_face' above.
				2. If widget has not font-face, then `font_face' is possibly used.
				3. If neither widget nor `font_face' define font-face, then a global font-face is used.
				
				This might lead to very unexpected behavior in the printed report, which
				will leave the programmer/report-writer wondering "Why is my font not right?".
				]"
			design_musings: "[
				Can we protect our report-writer from the heinous question of, "Dude, where's my font-face?"
				
				At the moment, the best solution seems to be logging an error with a descriptive
				error message so our programmer/report-writer has some indication of these various
				states.
				
				QUESTION: Are these errors or just states resulting from JSON-parsing?
				
				Note that the `has_font_face_error' is (in fact) an error. Delivering an
				erroneous font-face spec is an error. However, not defining a font-face
				spec is not really an error, is it? While it might be an oversight by
				our programmer/report-writer, such oversights end up being a "state" that the
				programmer must be responsible for measuring.
				]"
		attribute
			Result := Void
		end

feature -- Measurement

feature -- Status report

	has_font_face_error: BOOLEAN
			-- Do we have an error in `font_face' setting?

	error_text: detachable STRING
			-- What was the error?

feature -- Status setting

	set_text (s: like text)
		do
			text := s
		ensure
			set: text.same_string (s)
		end

	set_size (n: like size)
		do
			size := n
		ensure
			set: size = n
		end

	set_widget_id (s: like widget_id)
			--
		do
			widget_id := s
		ensure
			set: attached widget_id as al_widget_id and then
					attached s as al_s implies al_widget_id.same_string (al_s)
		end

	set_font_face (t: attached like font_face)
			-- Set the `font_face' to `t', if no error.
		note
			alt: "see font_face for more"
			warning: "[
				Semi-silent fail, which means that if the font name, slant, or weight
				is wrong, then the reasonable default is taken--that is--the `font_face'
				remains undefined (detached). This might have serious implications if
				the programmer/report-writer expects this Datum to define its font-face.
				What will happen is this--upon fail, if the report-writer finds no widget 
				to define the font-face, then a superceding reasonable-default font-face 
				will be used. While this keeps the software from failing, the resulting report
				will most likely use an unexpected font-face. Therefore, this note is
				here to tell you (as programmer) to test for error-flags and messages!
				]"
		do
			if (slant_enum.has (t.slant) or else
				weight_enum.has (t.weight)) and then
				(not t.name.is_empty)
			then
				font_face := t
			else
				has_font_face_error := True
				error_text := "[" + t.name + "," + t.slant.out + "," + t.weight.out + "]"
			end
		ensure
			flag_implies_message: has_font_face_error implies attached error_text
			set_without_error: (font_face ~ t) implies not has_font_face_error
			set_with_error: (has_font_face_error and attached error_text) implies not (font_face ~ t)	-- (not a) or else b <-- Implication with possible undefinedness
		end

	slant_enum: ARRAY [INTEGER]
			-- Enumeration of font slants.
		once
			Result := <<
						{CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_normal,
						{CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_italic,
						{CAIRO_FONT_SLANT_ENUM_API}.cairo_font_slant_oblique
						>>
		end

	weight_enum: ARRAY [INTEGER]
			-- Enumeration of font weights.
		once
			Result := <<
						{CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_normal,
						{CAIRO_FONT_WEIGHT_ENUM_API}.cairo_font_weight_bold
						>>
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
