local colors = require("theme/colors")
local blend = require("theme/blend")

local M = {}

function M.setup()
	vim.cmd("highlight clear")

	local rules = {
		-- Syntax groups
		Comment = { fg = colors.foreground_faded, italic = true }, -- any comment
		SpecialComment = { fg = colors.green1, italic = true }, -- special things inside a comment

		Constant = { fg = colors.blue1 }, -- any constant
		String = { fg = colors.green1 }, -- a string constant: "this is a string"
		Character = { fg = colors.green1 }, -- a character constant: 'c', '\n'
		Number = { fg = colors.blue1 }, -- a number constant: 234, 0xff
		Float = { fg = colors.blue1 }, -- a floating point constant: 2.3e10
		Boolean = { fg = colors.blue1 }, -- a boolean constant: TRUE, false

		Type = { fg = colors.yellow1 }, -- int, long, char, etc.
		Structure = { fg = colors.yellow1 }, -- struct, union, enum, etc.
		Typedef = { fg = colors.yellow1 }, -- a typedef

		Identifier = { fg = colors.red1 }, -- any variable name
		Function = { fg = colors.blue1 }, -- function name (also: methods for classes)

		Statement = { fg = colors.magenta1 }, -- any statement
		Conditional = { link = "Statement" }, -- if, then, else, endif, switch, etc.
		Repeat = { link = "Statement" }, -- for, do, while, etc.
		Label = { link = "Statement" }, -- case, default, etc.
		Operator = { link = "Statement" }, -- "sizeof", "+", "*", etc.
		Exception = { link = "Statement" }, -- try, catch, throw
		StorageClass = { link = "Statement" }, -- static, register, volatile, etc.
		Keyword = { link = "Statement" }, -- any other keyword

		PreProc = { fg = colors.cyan1 }, -- generic Preprocessor
		Include = { link = "PreProc" }, -- preprocessor #include
		Define = { link = "PreProc" }, -- preprocessor #define
		Macro = { link = "PreProc" }, -- same as Define
		PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

		Special = { fg = colors.yellow1 }, -- any special symbol
		SpecialChar = { link = "Special" }, -- special character in a constant
		SpecialKey = { link = "Special" }, -- generally: text that is displayed differently from what it really is
		Underlined = { underline = true }, -- text that stands out, HTML links
		Error = { fg = colors.red1 }, -- any erroneous construct
		Todo = { fg = colors.green2 }, -- anything that needs extra attention: TODO, FIXME, XXX
		Delimiter = {}, -- character that needs attention
		Debug = {}, -- debugging statements
		Tag = {},
		Ignore = {},

		-- Interface groups
		ColorColumn = {}, -- used for the columns set with 'colorcolumn'
		Conceal = {}, -- placeholder characters substituted for concealed text (see 'conceallevel')
		Cursor = { reverse = true, bold = true }, -- the character under the cursor
		CursorIM = { link = "Cursor" }, -- like Cursor, but used when in IME mode
		CursorColumn = { bg = colors.cursor_grey }, -- the screen column that the cursor is in when 'cursorcolumn' is set

		DiffAdd = { bg = colors.green2, fg = colors.background_buffer }, -- diff mode: added line
		DiffChange = { fg = colors.yellow2, underline = true }, -- diff mode: changed line
		DiffDelete = { bg = colors.red2, fg = colors.background_buffer }, -- diff mode: deleted line
		DiffText = { bg = colors.yellow2, fg = colors.background_buffer }, -- diff mode: changed text within a changed line.

		EndOfBuffer = {}, -- filler lines (~) after the last line in the buffer

		Pmenu = { bg = colors.background_focused, fg = colors.foreground_base }, -- popup menu: normal item
		PmenuSel = { bg = colors.background_highlighted, fg = colors.foreground_highlighted }, -- popup menu: selected item
		PmenuSbar = { bg = colors.background_some }, -- popup menu: scrollbar
		PmenuThumb = { bg = colors.faded }, -- popup menu: thumb of the scrollbar
		TabLine = { bg = colors.background_line, fg = colors.foreground_faded }, -- tab pages line, not active tab page label
		TabLineFill = { link = "TabLine" }, -- tab pages line, where there are no labels
		TabLineSel = { bg = colors.background_focused, fg = colors.foreground_highlighted }, -- tab pages line, active tab page label
		WildMenu = { bg = colors.blue1, fg = colors.background_buffer }, -- current match in 'wildmenu' completion
		VertSplit = { fg = colors.background_line }, -- the column separating vertically split windows

		StatusLine = { bg = colors.background_line, fg = colors.foreground_base }, -- status line of current window
		StatusLineNC = { fg = colors.foreground_faded }, -- status lines of not-current windows
		StatusLineTerm = { link = "StatusLine" }, -- status line of current :terminal window
		StatusLineTermNC = { link = "StatusLineNC" }, -- status line of non-current :terminal window

		WarningMsg = { fg = colors.warning }, -- warning messages
		ErrorMsg = { fg = colors.error }, -- error messages on the command line
		ModeMsg = {}, -- 'showmode' message (e.g., "-- INSERT --")
		MoreMsg = {}, -- more-prompt

		SpellBad = { fg = colors.error, underline = true }, -- word that is not recognized by the spellchecker
		SpellCap = { fg = colors.warning }, -- word that should start with a capital
		SpellLocal = { fg = colors.success }, -- word that is recognized by the spellchecker as one that is used in another region
		SpellRare = { fg = colors.info }, -- word that is recognized by the spellchecker as one that is hardly ever used
		Whitespace = {}, -- "nbsp", "space", "tab", "multispace", "lead" and "trail"

		Search = { bg = colors.warning, fg = colors.on_warning }, -- last search pattern highlighting. Also used for similar items that need to stand out.
		IncSearch = { bg = colors.warning, fg = colors.on_warning }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
		MatchParen = { fg = colors.warning, underline = true }, -- the character under the cursor or just before it, if it is a paired bracket, and its match.

		Normal = { bg = colors.background_buffer, fg = colors.foreground_base }, -- normal text
		Visual = { bg = colors.background_highlighted }, -- visual mode selection
		VisualNOS = { link = "Visual" }, -- visual mode selection when vim is "Not Owning the Selection"
		Terminal = { link = "Normal" }, -- terminal window (see terminal-size-color)
		NonText = { fg = colors.foreground_faded },

		Folded = { fg = colors.foreground_faded, bold = true }, -- line used for closed folds
		FoldColumn = {}, -- 'foldcolumn'
		SignColumn = { bg = colors.background_line }, -- column where signs are displayed
		LineNr = { bg = colors.background_line }, -- line number for ":number" and ":#" commands
		CursorLineNr = { link = "CursorLine" }, -- like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.

		Question = { fg = colors.cyan1 }, -- hit-enter prompt and yes/no questions
		QuickFixLine = { bg = colors.cyan1, fg = colors.background_buffer }, -- Current quickfix item in the quickfix window.
		Title = { fg = colors.green1 }, -- titles for output from ":set all", ":autocmd" etc.
		Directory = { fg = colors.blue1 }, -- directory names (and other special names in listings)

		-- Float windows
		NormalFloat = { bg = colors.background_focused },
		FloatBorder = { fg = colors.foreground_highlighted },
		WinBar = { link = "NormalFloat" },
		WinBarNC = { link = "NormalFloat" },

		-- Trouble
		TroubleNormal = { link = "Normal" },
		TroubleNormalNC = { link = "Normal" },
		TroubleIndent = { link = "Normal" },

		-- NvimTree
		NvimTreeNormal = { bg = colors.background_buffer, fg = colors.foreground_base },
		NvimTreeWinSeparator = { bg = colors.background_buffer },
		NvimTreeNormalNC = { bg = colors.background_buffer, fg = colors.foreground_base },
		NvimTreeRootFolder = { fg = colors.blue2, bold = true },
		NvimTreeGitDirty = { fg = colors.yellow1 },
		NvimTreeGitNew = { fg = colors.green1 },
		NvimTreeGitDeleted = { fg = colors.red1 },
		NvimTreeOpenedFile = { bg = colors.background_highlight },
		NvimTreeSpecialFile = { fg = colors.magenta1, underline = true },
		NvimTreeIndentMarker = { fg = colors.foreground_highlighted },
		NvimTreeImageFile = {},
		NvimTreeSymlink = { fg = colors.cyan1 },
		NvimTreeFolderIcon = { fg = colors.blue1 },

		-- LSP Completion
		CmpItemAbbr = { link = "Tag" },
		CmpItemAbbrDeprecated = { link = "Tag" },
		CmpItemAbbrMatch = { bold = true },
		CmpItemAbbrMatchFuzzy = { bold = true, italic = true },
		CmpItemMenu = { link = "" },
		CmpItemKindText = { link = "String" },
		CmpItemKindVariable = { link = "Identifier" },
		CmpItemKindMethod = { link = "Function" },
		CmpItemKindFunction = { link = "Function" },
		CmpItemKindConstructor = { link = "Function" },
		CmpItemKindField = { link = "Identifier" },
		CmpItemKindClass = { link = "Structure" },
		CmpItemKindInterface = { link = "Structure" },
		CmpItemKindUnit = { link = "PreProc" },
		CmpItemKindModule = { link = "PreProc" },
		CmpItemKindProperty = { link = "Identifier" },
		CmpItemKindValue = { link = "Identifier" },
		CmpItemKindEnum = { link = "Structure" },
		CmpItemKindEnumMember = { link = "Identifier" },
		CmpItemKindOperator = { link = "Operator" },
		CmpItemKindKeyword = { link = "Keyword" },
		CmpItemKindEvent = { link = "Function" },
		CmpItemKindReference = { link = "Identifier" },
		CmpItemKindColor = { link = "Special" },
		CmpItemKindSnippet = { link = "Special" },
		CmpItemKindFile = { link = "PreProc" },
		CmpItemKindFolder = { link = "PreProc" },
		CmpItemKindConstant = { link = "Constant" },
		CmpItemKindStruct = { link = "Structure" },
		CmpItemKindTypeParameter = { link = "Typedef" },

		-- Diagnostics
		DiagnosticError = { fg = colors.red1 },
		DiagnosticWarn = { fg = colors.yellow1 },
		DiagnosticInfo = { fg = colors.blue1 },
		DiagnosticHint = { fg = colors.green1 },
		DiagnosticUnderlineError = { fg = colors.red1, underline = true },
		DiagnosticUnderlineWarn = { fg = colors.yellow1, underline = true },
		DiagnosticUnderlineInfo = { fg = colors.blue1, underline = true },
		DiagnosticUnderlineHint = { fg = colors.green1, underline = true },

		-- Git
		gitcommitHeader = {},
		gitcommitFile = {},
		gitcommitComment = { fg = colors.comment_grey },
		gitcommitUnmerged = { fg = colors.green },
		gitcommitOnBranch = {},
		gitcommitBranch = { fg = colors.blue1 },
		gitcommitDiscardedType = { fg = colors.red1 },
		gitcommitSelectedType = { fg = colors.green1 },
		gitcommitUntrackedFile = { fg = colors.yellow1 },
		gitcommitDiscardedFile = { fg = colors.red1 },
		gitcommitSelectedFile = { fg = colors.green1 },
		gitcommitUnmergedFile = { fg = colors.magenta1 },
		gitcommitSummary = { fg = colors.foreground_base },
		gitcommitOverflow = { fg = colors.red1 },
		gitcommitNoBranch = { link = "gitcommitBranch" },
		gitcommitUntracked = { link = "gitcommitComment" },
		gitcommitDiscarded = { link = "gitcommitComment" },
		gitcommitSelected = { link = "gitcommitComment" },
		gitcommitDiscardedArrow = { link = "gitcommitDiscardedFile" },
		gitcommitSelectedArrow = { link = "gitcommitSelectedFile" },
		gitcommitUnmergedArrow = { link = "gitcommitUnmergedFile" },

		-- Markdown
		markdownBlockquote = { fg = colors.foreground_faded },
		markdownBold = { fg = colors.red1, bold = true },
		markdownItalic = { fg = colors.blue1, italic = true },
		markdownBoldItalic = { fg = colors.magenta1, bold = true, italic = true },
		markdownCode = { fg = colors.green1 },
		markdownCodeBlock = { link = "markdownCode" },
		markdownCodeDelimiter = { link = "markdownCode" },
		markdownH1 = { fg = colors.magenta1, bold = true, underline = true },
		markdownH2 = { link = "markdownH1" },
		markdownH3 = { link = "markdownH1" },
		markdownH4 = { link = "markdownH1" },
		markdownH5 = { link = "markdownH1" },
		markdownH6 = { link = "markdownH1" },
		markdownHeadingDelimiter = { fg = colors.red1, bold = true },
		markdownHeadingRule = { fg = colors.foreground_faded },
		markdownId = { fg = colors.yellow1 },
		markdownIdDeclaration = { fg = colors.blue1 },
		markdownIdDelimiter = { link = "markdownId" },
		markdownLinkDelimiter = { fg = colors.magenta1 },
		markdownLinkText = { fg = colors.blue1 },
		markdownListMarker = { fg = colors.red1 },
		markdownOrderedListMarker = { fg = colors.red1 },
		markdownRule = { fg = colors.foreground_faded },
		markdownUrl = { fg = colors.cyan1, underline = true },

		-- LSP Semantics Tokens
		["@lsp.type.namespace"] = { fg = colors.red1, bold = true },
		["@lsp.type.class"] = { link = "Structure" },
		["@lsp.type.enum"] = { link = "Structure" },
		["@lsp.type.enumMember"] = { fg = colors.green2, italic = true },
		["@lsp.type.function"] = { link = "Function" },
		["@lsp.type.method"] = { link = "Function" },
		["@lsp.type.macro"] = { link = "PreProc" },
		["@lsp.type.variable"] = { fg = blend.mix(colors.foreground_base, colors.yellow1, 0.9) },
		["@lsp.type.parameter"] = { fg = blend.mix(colors.foreground_base, colors.cyan2, 0.9) },
		["@lsp.type.property"] = { fg = blend.mix(colors.red1, colors.yellow1, 0.5) },
		["@lsp.typemod.variable.static"] = { fg = blend.mix(colors.yellow1, colors.magenta1, 0.5) },
		["@lsp.typemod.function.static"] = { link = "Function" },

		SnacksIndent = { fg = colors.background_line },
		SnacksIndentScope = { fg = colors.foreground_highlighted },

		AvanteSidebarNormal = { link = "Normal" },
	}

	if vim.opt.diff:get() then
		rules.CursorLine = { underline = true } -- the screen line that the cursor is in when 'cursorline' is set
	else
		rules.CursorLine = { bg = colors.background_line } -- the screen line that the cursor is in when 'cursorline' is set
	end

	for group, rule in pairs(rules) do
		vim.api.nvim_set_hl(0, group, rule)
	end

	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ", -- 
				[vim.diagnostic.severity.WARN] = " ", -- 
				[vim.diagnostic.severity.INFO] = " ", -- 
				[vim.diagnostic.severity.HINT] = "󰅺", --
			},
		},
	})

	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
	vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "WarningMsg", linehl = "", numhl = "" })
	vim.fn.sign_define("DapLogPoint", { text = "", texthl = "Question", linehl = "", numhl = "" })
	vim.fn.sign_define("DapBreakpointRejected", { text = "󰜺", texthl = "Error", linehl = "", numhl = "" })

	vim.g.terminal_color_0 = colors.black1
	vim.g.terminal_color_8 = colors.black2
	vim.g.terminal_color_1 = colors.red1
	vim.g.terminal_color_9 = colors.red2
	vim.g.terminal_color_2 = colors.green1
	vim.g.terminal_color_10 = colors.green2
	vim.g.terminal_color_3 = colors.yellow1
	vim.g.terminal_color_11 = colors.yellow2
	vim.g.terminal_color_4 = colors.blue1
	vim.g.terminal_color_12 = colors.blue2
	vim.g.terminal_color_5 = colors.magenta1
	vim.g.terminal_color_13 = colors.magenta2
	vim.g.terminal_color_6 = colors.cyan1
	vim.g.terminal_color_14 = colors.cyan2
	vim.g.terminal_color_7 = colors.white1
	vim.g.terminal_color_15 = colors.white2
end

return M
