note
	description: "Representation of a PDF_TEXT_WIDGET"
	design: "[
		Applies text with formatting to a host-PDF_BOX (cell/vert/horz).
		
		The basic idea is that this widget is named and json-data specifies
		the name as the target widget. Therefore, the code creates a new instance
		of this class when it detects json-data that specifies it as the target.
		
		Before that--a json-layout-spec states a box-with-widget specification,
		which creates the overall page-layout structure for json-data to fill.
		
		See {PDF_DOCS} design note for more.
		]"

class
	PDF_TEXT_WIDGET

inherit
	PDF_WIDGET

end
