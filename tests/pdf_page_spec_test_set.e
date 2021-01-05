note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	testing: "type/manual"

class
	PDF_PAGE_SPEC_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

	JSE_AWARE
		undefine
			default_create
		end

feature -- Test routines

	json_array_test
		note
			why_is_this_here: "[
				It turns out that {JSON_ARRAY}.has_key and {JSON_ARRAY}.chained_item are not
				implemented in a way that allows us to find "keyed-objects" in the array by
				means of a key as expected. In fact, "has_key" on JSON_ARRAY is actually
				not implemented (an empty "do-end" process with no code).
				
				This test feature was created to explore and then expose this reality and my
				misconecption and misuse of the "has_key" in JSON_ARRAY. Moreover, once that
				misconception was exposed, this feature then provided a space to create a
				new JSON_EXT library feature-set in JSON_DESERIALIZABLE for "getting" array
				items that are "keyed-objects"--that is--key-value pairs (see l_json below).

				]"
			testing:  "covers/{JSON_ARRAY}.make",
						"execution/isolated"
		local
			l_array: JSON_ARRAY
			l_object: JSON_OBJECT
			l_name: STRING
			l_parser: JSON_PARSER
			l_json, l_json_out: STRING
		do
			l_json := "{%"name%":%"Larry%"}"
			l_json_out := "[" + l_json + "]"
			create l_array.make (1)

			create l_parser.make_with_string (l_json)
			l_parser.parse_content
			check can_make_object: attached l_parser.parsed_json_object as al_object then
				l_array.add (al_object.twin)
			end

			assert_strings_equal ("matching_json_out", l_json_out, l_array.representation)
		-- THIS CODE SUCCEEDS!
			⟳ ic:l_array ¦
				check is_object: attached {JSON_OBJECT} ic as al_object then
					check create_name_attr: attached (create {JSON_STRING}.make_from_string ("name")) as al_attr then
						check has_key: al_object.has_key (al_attr) then
							check has_chained_item: attached {JSON_STRING} al_object.chained_item (al_attr) as al_value then
								l_name := al_value.item
								assert_strings_equal ("has_larry_1", "Larry", l_name)
							end
						end
					end
				end
			⟲
		-- BASED ON NEW JSE_DESERIALIZABLE ...
			l_name := json_array_get_keyed_object_string_attached (l_array, "name")
			assert_strings_equal ("has_larry_2", "Larry", l_name)
		-- THIS CODE FAILS!
--			check create_name_attr: attached (create {JSON_STRING}.make_from_string ("name")) as al_attr then
--				check has_key: l_array.has_key (al_attr) then
--					check has_chained_item: attached {JSON_STRING} l_array.chained_item (al_attr) as al_value then
--						l_name := al_value.item
--						assert_strings_equal ("has_larry", "Larry", l_name)
--					end
--				end
--			end
		end

	page_spec_test
		note
			testing:  "covers/{PDF_PAGE_SPEC}.default_create",
						"execution/serial"
		local
			l_page_spec: PDF_PAGE_SPEC
		do
			create l_page_spec
			assert_strings_equal ("default_create_json_out", default_create_json_out, l_page_spec.json_out)
			create l_page_spec.make_from_json (make_from_json_json_out)
			assert_strings_equal ("make_from_json_json_out", make_from_json_json_out, l_page_spec.json_out)
		-- At this point we know it works without boxes ...
		-- Now, add a box (just 1)
			create l_page_spec.make_from_json (make_from_json_one_box_json_out)
			assert_strings_equal ("make_from_json_one_box_json_out", make_from_json_one_box_json_out, l_page_spec.json_out)

		end


	page_spec_box_and_widget_spec_tests
			-- Test of box and widget specifications being loaded.
		note
			testing:  "covers/{PDF_PAGE_SPEC}.default_create",
						"covers/{PDF_TEST_SET_SUPPORT}.page_spec_3",
						"covers/{PDF_TEST_SET_SUPPORT}.page_spec_3_json",
						"execution/isolated",
						"execution/serial"
		do
			assert_integers_equal ("three_box_specs", 3, page_spec_3.boxes.count)
		end

feature {NONE} -- PAGE_SPEC Test Support

	default_create_json_out: STRING = "[
{"name":null,"font_color":null,"font_face":null,"boxes":null,"height":0,"width":0,"indent_size":0,"font_size":0,"margin_top":0,"margin_bottom":0,"margin_left":0,"margin_right":0}
]"

	make_from_json_json_out: STRING = "[
{"name":"page_spec_x","font_color":null,"font_face":["Sans",0,0],"boxes":null,"height":800,"width":600,"indent_size":10,"font_size":10,"margin_top":10,"margin_bottom":10,"margin_left":10,"margin_right":10}
]"

	make_from_json_one_box_json_out: STRING = "[
{"name":"page_spec_3","font_color":[0,0,0],"font_face":["Sans",0,0],"boxes":[{"name":"my_box_1","parent":null,"type":"vertical","layout":{"minimum_size":0}}],"height":792,"width":612,"indent_size":50,"font_size":10,"margin_top":16,"margin_bottom":13,"margin_left":11,"margin_right":11}
]"

feature {NONE} -- Initialization (JSON)

	make_from_json (a_json: STRING)
			--<Precursor>
		require else
			True
		do
			check attached json_string_to_json_object (a_json) as al_object then
				-- conversions of items in al_object --> Eiffel feature objects
				-- see {JSON_CODE_GENERATOR} for more (use TEST_SET to generate)
			end
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := {ARRAY [JSON_METADATA]} <<>> -- populate with "create {JSON_METADATA}.make_text_default"
		end

	convertible_features (a_current: ANY): ARRAY [STRING]
			--<Precursor>
		do
			Result := {ARRAY [STRING]} <<>> -- populate with "my_feature_name"
		end

feature -- Status Report

	has_json_input_error: BOOLEAN

end


