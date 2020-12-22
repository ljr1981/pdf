note
	description: "PDF_CELL single-item container"

deferred class
	PDF_CELL

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			--<Precursor>
		do
			Precursor
			expandable := True
			limit := 1
		ensure then
			set_expandable: expandable
		end

	metadata_refreshed (a_current: ANY): ARRAY [JSON_METADATA]
			--<Precursor>
		do
			Result := <<
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default,
						create {JSON_METADATA}.make_text_default
						>>
		end

	convertible_features (a_current: ANY): ARRAY [STRING_8]
			--<Precursor>
		do
			Result := <<
						"sub_items",
						"offset_x",
						"offset_y",
						"height",
						"width",
						"inside_border_padding",
						"outside_border_padding",
						"expandable",
						"limit",
						"parent"
						>>
		end

feature -- Access

	sub_items: ARRAYED_LIST [PDF_CELL]
			-- A list of contained `sub_items'.
		attribute
			create Result.make (10)
		end

	offset_x, offset_y: INTEGER
			-- Offset coordinates from `parent' origin

	height, width: INTEGER
			-- 2D height (along y) and width (along x).

	inside_border_padding,
	outside_border_padding: INTEGER

	expandable: BOOLEAN
			-- Is Current `expandable'?

	limit: INTEGER
			-- What is the `item' count `limit'?

	parent: detachable WEAK_REFERENCE [PDF_CELL]
			-- Possible parent container.

feature -- Settings

	set_items (o: like sub_items)
			-- Set `sub_items' to items in `o'.
		do
			across
				o as ic
			loop
				sub_items.force (ic.item)
			end
		end

	set_offset_x (n: INTEGER)
			-- Set `offset_x' to `n'.
		do
			offset_x := n
		ensure
			set: offset_x = n
		end

	set_offset_y (n: INTEGER)
			-- Set `offset_y' to `n'.
		do
			offset_y := n
		ensure
			set: offset_y = n
		end

	set_limit (n: INTEGER)
			-- Set `limit' to `n'.
		do
			limit := n
		ensure
			set: limit = n
		end

	set_height (n: INTEGER)
			-- Set `height' to `n'.
		do
			height := n
		ensure
			set: height = n
		end

	set_width (n: INTEGER)
			-- Set `width' to `n'.
		do
			width := n
		ensure
			set: width = n
		end

	set_inside_border_padding (n: INTEGER)
			-- Set `inside_border_padding' to `n'.
		do
			inside_border_padding := n
		ensure
			set: inside_border_padding = n
		end

	set_outside_border_padding (n: INTEGER)
			-- Set `outside_border_padding' to `n'.
		do
			outside_border_padding := n
		ensure
			set: outside_border_padding = n
		end

	set_parent (v: WEAK_REFERENCE [PDF_CELL])
			-- Set the parent `v'.
		do
			parent := v
		ensure
			set: parent ~ v
		end

	disable_item_expand
			-- Disable `expandable'
		do
			expandable := False
		end

feature -- Basic Operations

	extend (v: PDF_CELL)
			-- Extend `v' into `sub_items' with Current as v.`parent'
		require
			enough: (sub_items.count < limit) xor (limit = 0)
		local
			l_parent: WEAK_REFERENCE [PDF_CELL]
		do
			sub_items.force (v)
				-- Set Current a weak-reference'd parent.
			create l_parent
			l_parent.put (Current)
			v.set_parent (l_parent)
		ensure
			extended: sub_items.has (v)
		end

end
