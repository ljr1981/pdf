note
	description: "Documents and Design Notes"

class
	PDF_DOCS

note
	design: "[
		PDF_REPORT ::= {PDF_PAGE_SPEC}+
	
		PDF_PAGE_SPEC ::= {PDF_CELL}+
		
		PDF_CELL ::= {PDF_CELL}(1)
		
		A PDF_PAGE always contains one (1) PDF_CELL within its margins.
		
		PDF_BOX ::= {PDF_WIDGET | PDF_BOX}*
		
		PDF_BOX is a type of PDF_CELL, but can contain one or more PDF_CELL item(s).
		PDF_BOX expands to use all of the space available to it within its container.
		PDF_BOX "disable_item_expand" disable the expansion from above.
		PDF_BOX has outside_border_padding and inside_border_padding (points).
		PDF_BOX items float to the first available empty space for them (left or right and top or bottom).
		PDF_BOX items can be placed (x,y) relative to their parent (with or without clipping).
		
		Flow???
		
		PDF_VERTICAL_BOX inherits PDF_BOX, where child PDF_CELL items flow vertically from [top to bottom | bottom to top].
		PDF_HORIZONTAL_BOX inherits PDF_BOX, where PDF_CELL items flow horizontally from [left to right | right to left].		
		
		PDF_LINE_WIDGET items are PDF_BOX items which can draw lines on their edges (top, sides, bottom).
		PDF_TEXT_WIDGET inherits PDF_LINE_WIDGET. PDF_BOX items contain (possibly clipped) text.
		PDF_IMAGE_WIDGET inherits PDF_LINE_WIDGET. PDF_BOX items contain (possibly clipped) graphics (e.g. PNG, JPG, SVG, etc).
				]"
	process: "[
		Based upon the design (above), the processing-step are:
		
		1. Build a report object with each page-spec(s)
		2. Build object for each page-spec with a page-layout-spec
		3. Build object for each page-layout-spec with related widgets
		4. Read-parse-fill page-layout-spec recursively with json-data
			where json-data is translated in PDF_WIDGETS that are placed
			in PDF_BOXes within a specified PDF_PAGE_SPEC.
			
		Pdf_resport ::= {Pdf_page_spec}+
			
		Pdf_page_spec ::= {Pdf_box}+
		
		Pdf_box ::= {Pdf_box | Pdf_widget}+
		
		Where: Each Pdf_page_spec, Pdf_box, Pdf_widget is uniquely named.
		Where: Each json-data item specifies its page-spec-name/box-name/widget-name as a target "namespace".
		
		Therefore: As each item (based on json-data item) is "placed", it computes is space-needs, position, formatting, and so on
		from its specifications, within the boundaries set, paying attention to clipping, overlay, hiding,
		and layering.
		]"

end
