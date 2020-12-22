note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	PDF_BOX_TEST_SET

inherit
	PDF_TEST_SET_SUPPORT

feature -- Test routines

	vbox_test
			-- New test routine
		note
			testing:  "covers/{PDF_VERTICAL_BOX}.make_from_json", "execution/isolated", "execution/serial"
		local
			l_page: PDF_PAGE_SPEC
			l_box: PDF_VERTICAL_BOX
			l_text: PDF_TEXT_WIDGET
		do
			create l_page.make_from_json ("{}")
			create l_box
			create l_text
			l_box.extend (l_text)
			assert_32 ("box_has_text", l_box.sub_items.has (l_text))
			assert_32 ("box_weak_reference_parent_on_text", attached l_text.parent as al_parent and then al_parent.item ~ l_box)
		end

end


