note
	description: "Documents and Design Notes"

class
	PDF_DOCS

note
	design: "[
		JSON_SPEC Input --> PDF_FACTORY --> PDF Report Output (file or stream)
		]"
	json_report_spec: "[
		{
		page_x: NNNN,
		page_y: NNNN,
		default_page_orientation: "Portrait | Landscape"
		page_spec: {
				name: "AAAA"
				height: NNNN,
				width: NNNN,
				orientation: "Default | Portrait | Landscape"
				},
		
		}
		]"

end
