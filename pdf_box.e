note
	description: "Abstract notion of a widget box."

deferred class
	PDF_BOX

inherit
	PDF_CELL
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			--<Precursor>
		do
			Precursor
			limit := 0
		end

end
