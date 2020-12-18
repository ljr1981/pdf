note
	description: "Constant Values related to PDF Documents"

class
	PDF_CONST

feature -- Access

	dpi: INTEGER = 72
			-- Standard Cairo DPI of 1 point == 1/72.0 inch

	US_8_by_11_page_width: INTEGER
			-- Width in points based on `dpi'.
		once
			Result := (dpi * 8.5).truncated_to_integer
		end

	US_8_by_11_page_height: INTEGER
			-- Height in points based on `dpi'.
		once
			Result := (dpi * 11.0).truncated_to_integer
		end

end
