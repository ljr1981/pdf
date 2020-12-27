note
	description: "Abstract notion of a Specification"

deferred class
	PDF_SPEC

inherit
	JSE_AWARE

feature -- Access

	type: STRING
			-- The `type' of this Specification.
		note
			warning: "DO NOT create a `setter' for this. Implement it as an inline manifest in descendants."
		deferred
		end

	name: STRING
			-- The namespace `name' of Current.
		attribute
			Result := "unknown_name"
		end

feature -- Settings

	set_name (s: STRING)
			-- Set `name' from `s'.
		require
			not_empty: not s.is_empty
		do
			name := s
		ensure
			set: name.same_string (s)
		end

end
