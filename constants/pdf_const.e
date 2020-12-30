note
	description: "Constant Values related to PDF Documents"

class
	PDF_CONST

inherit
	PDF_DOCS

feature -- Access

	dpi: INTEGER = 72
			-- Standard Cairo DPI of 1 point == 1/72.0 inch

	US_8_by_11_page_width: INTEGER = 612
			-- Width in points based on `dpi'.
			--	Default: dpi x 8.5

	US_8_by_11_page_height: INTEGER = 792
			-- Height in points based on `dpi'.
			--	Default: dpi x 11

	us_portrait: TUPLE [INTEGER, INTEGER]
		once
			Result := [US_8_by_11_page_height, US_8_by_11_page_width]
		end

	us_landscape: TUPLE [INTEGER, INTEGER]
		once
			Result := [US_8_by_11_page_width, US_8_by_11_page_height]
		end

	default_margin_bottom: INTEGER = 13
		--	margin_bottom := (.18 * 72).truncated_to_integer = 12.96

	default_margin_left: INTEGER = 11
		--	margin_left := (.15 * 72).truncated_to_integer = 10.8

	default_margin_right: INTEGER = 11
		--	margin_right := (.15 * 72).truncated_to_integer = 10.8

	default_margin_top: INTEGER = 16
		--	margin_top := (.22 * 72).truncated_to_integer = 15.84

	default_pdf_file_name: STRING = "pdffile.pdf"

	regex: RX_PCRE_ROUTINES
			--
		once
			create Result
		end

	valid_file_name_regex_pattern: STRING = "^[\w,\s-]+\.[A-Za-z]{3}$"

	is_valid_file_name (fn: READABLE_STRING_GENERAL): BOOLEAN
			-- Is `fn' a valid file name based on `valid_file_name_regex_pattern'.
		do
			Result := attached regex.regexp (valid_file_name_regex_pattern) as al_expr and then al_expr.matches (fn)
		end

;end
