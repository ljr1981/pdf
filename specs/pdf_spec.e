note
	description: "Abstract notion of a Specification"

deferred class
	PDF_SPEC

inherit
	JSE_AWARE

feature -- Access

	name: STRING
			-- The `name' of this Specification.
		deferred
		end

end
