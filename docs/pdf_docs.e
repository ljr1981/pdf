note
	description: "Documents and Design Notes"

class
	PDF_DOCS

note
	design_no_1: "[
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
	design_no_2: "[
		The latest design reuses the facilities of Eiffel Vision2. EV already knows how to build
		self-positioning and self-expanding boxes and then putting "printable" (screen) components
		in them, where they are self-arranging. By reusing this code, we capitalize on its well
		tested and exercised facilities, where we only need to then add any further "specifications"
		where printed reports (PDFs) are concerned (regardless of printed-to-file or streamed-to-client).
		
		For example: Unlike screens (computer displays)--printed reports have definite limits in printable
		area and that area may change from page to page (e.g. size, orientation, or both).
		
		For example: Printed text and other "widgets" can rotate, whereas EV widgets generally do not
		have this capability. So, adding that and then translating that to paper (PDF) will be the
		challenge of this library.
		
		HUMBLE-BEGINNINGS: For the moment, it will be enough to get properly positioned text on a
		page of the right font (face), font-size (points), font-slant (italic), and font-weight (bold).
		To this end, the following are suggestion(s) for a basic workflow.
		
		1. Define a page-layout specification (e.g. vertical and horizontal widget-boxes, and page-specs)
		2. Define a page-widget specification (e.g. labels, lines, boxes)
		3. Define report-data (e.g. data-item points to display-widget and layout-widget)
		
		NOTE-THAT--as layout-widgets (vert/horz-boxes) "fill-up" and finally "get-full", it is
		suggested to use a visible "marker-widget" that is repeated tested for "is-visible". When
		it becomes "is-visible"=False, then the layout-widget "is-full" and stops taking
		page-widgets (printable-widgets) with related report-data items. Therefore, the page is
		ended-off, a new page created, and printing continues.
		
		IDEA--some of this may have behaviors that mimic HTML elements being drawn on a web-page,
		where the web-page is predetermined size (limits) and static, once its elements are "drawn".
		
		IDEA--this actually leads to wanting to know if HTML can be directly consumed and given to
		the PDF document and rendered on a page-by-page basis?
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
		Where: Each json-data item specifies its "{PDF_PAGE_SPEC}.name/{PDF_BOX}.name/{PDF_WIDGET}.name" as a target "namespace".
		
		Therefore: As each item (based on json-data item) is "placed", it computes its space-needs, position, formatting, and so on
		from its specifications, within the boundaries set, paying attention to clipping, overlay, hiding,
		and layering.
		]"
	process_description_2: "[
		1. Input a JSON-based page-layout-spec and a JSON data-content file.
			a. JSON-based page-layout-spec ==> ARRAY [PDF_PAGE_SPEC]
			b. JSON-based data-content ==> Parsed JSON_OBJECT
		2. Use the page-layout to create a {PDF_REPORT_SPEC} with one or more {PDF_PAGE_SPEC} items.
			a. This is actually the result of 1a. above (e.g. {PDF_REPORT_SPEC}.page_specs: ARRAY [PDF_PAGE_SPEC]).
			b. We will have 1a. and 1b. above as a work product.
		3. Go across the JSON data-content using one of the {PDF_PAGE_SPEC} to generate a {PDF_PAGE} populated with data.
			a. Result will be {PDF_REPORT_SPEC}.pages: ARRAY [PDF_PAGE]
			b. Each {PDF_PAGE} has {EV_BOX} items in a layout.
			c. Each {EV_BOX} has data extended into it as {EV_LABEL} items.
			d. Each {EV_BOX} has metadata for its namespace and other "settings".
			e. Each {EV_LABEL} has metadata for its namespace and other "settings".
			f. Each {EV_LABEL} is extended into an {EV_BOX} by way of a matching namespace.
		4. Go across the collection of {PDF_PAGE} objects, finalizing data like "page-number" and so on.
			a. Traverse the {EV_BOX} structure applying the "settings" of each {EV_BOX} to itself in Cairo-cr/Cairo-surface.
			b. Traverse the {EV_BOX} structure, finding {EV_LABELS} and applying settings to itself in Cairo-cr/Cairo-surface.
			c. At the end of {PDF_PAGE} be sure to "next_page", pushing the `cr', based on the 'surface'.
		5. Using the {PDF_WRITER}, generate PDF file document pages for each {PDF_PAGE} in the {PDF_PAGE} collection.
			a. Final step is to "destroy"/"dispose" of the `cr'/`surface' which forces the PDF-file to "print".
		
		]"

end
