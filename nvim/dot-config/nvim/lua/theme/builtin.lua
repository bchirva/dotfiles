local colors = require("theme/colors")
local highlight = require("theme/highlight")

local M = {}

function M.setup()
    vim.cmd("highlight clear")

    vim.g.terminal_color_0 = colors.black
    vim.g.terminal_color_1 = colors.red
    vim.g.terminal_color_2 = colors.green
    vim.g.terminal_color_3 = colors.yellow
    vim.g.terminal_color_4 = colors.blue
    vim.g.terminal_color_5 = colors.magenta
    vim.g.terminal_color_6 = colors.cyan
    vim.g.terminal_color_7 = colors.white

    vim.g.terminal_color_8 = colors.black_alt
    vim.g.terminal_color_9 = colors.red_alt
    vim.g.terminal_color_10 = colors.green_alt
    vim.g.terminal_color_11 = colors.yellow_alt
    vim.g.terminal_color_12 = colors.blue_alt
    vim.g.terminal_color_13 = colors.magenta_alt
    vim.g.terminal_color_14 = colors.cyan_alt
    vim.g.terminal_color_15 = colors.white_alt

    local rules = {
        -- highlight-groups
        Normal                   = { bg = colors.bg_buffer, fg = colors.fg_text },
        NormalNC                 = { link = "Normal" },
        Visual                   = { bg = colors.bg_focused },
        VisualNOS                = { link = "Visual" },

        Cursor                   = { reverse = true, bold = true },
        lCursor                  = { link = "Cursor" },
        CursorIM                 = { link = "Cursor" },
        TermCursor               = { link = "Cursor" },

        StatusLine               = { bg = colors.bg_line },
        StatusLineNC             = { link = "StatusLine" },
        StatusLineTerm           = { link = "StatusLine" },
        StatusLineTermNC         = { link = "StatusLine" },
        TabLine                  = { bg = colors.bg_line },
        TabLineFill              = { link = "TabLine" },
        TabLineSel               = { fg = colors.primary, bold = true },
        LineNr                   = { bg = colors.bg_line, fg = colors.fg_text },
        LineNrAbove              = { link = "LineNr" },
        LineNrBelow              = { link = "LineNr" },
        CursorLineNr             = { link = "LineNr" },
        FoldColumn               = { link = "LineNr" },
        SignColumn               = { link = "LineNr" },
        CursorLineFold           = { link = "LineNr" },
        CursorLineSign           = { link = "LineNr" },
        ColorColumn              = {},
        CursorColumn             = {},
        CursorLine               = { bg = colors.bg_line },

        OkMsg                    = { fg = colors.green },
        WarningMsg               = { fg = colors.yellow },
        ErrorMsg                 = { fg = colors.red },
        StderrMsg                = { fg = colors.red, bold = true },
        StdoutMsg                = { fg = colors.fg_text },

        DiffAdd                  = { fg = colors.green },
        DiffChange               = { fg = colors.yellow },
        DiffDelete               = { fg = colors.red },
        DiffText                 = { fg = colors.yellow },
        DiffTextAdd              = { fg = colors.green },

        EndOfBuffer              = { fg = colors.fg_faded },
        Conceal                  = {},
        WinSeparator             = {},
        Folded                   = { fg = colors.fg_faded, underline = true },
        Whitespace               = {},
        SpecialKey               = { fg = colors.fg_faded },
        Directory                = { fg = colors.primary },

        Search                   = {
            fg = colors.primary,
            bold = true,
            italic = true,
            underline = true
        },
        CurSearch                = {
            bg = colors.primary,
            fg = colors.bg_buffer,
            bold = true,
            italic = true
        },
        IncSearch                = { link = "Search" },
        Substitute               = { link = "Search" },

        MatchParen               = { fg = colors.primary, bold = true, italic = true },
        ModeMsg                  = {},
        MsgArea                  = {},
        MsgSeparator             = {},
        MoreMsg                  = {},
        NonText                  = { fg = colors.fg_faded },

        NormalFloat              = { link = "Normal" },
        FloatBorder              = { fg = colors.fg_faded },
        FloatTitle               = { fg = colors.primary, bold = true },
        FloatFooter              = { fg = colors.secondary, italic = true },

        Pmenu                    = {},
        PmenuSel                 = { bg = colors.primary, fg = colors.bg_buffer, bold = true },
        PmenuThumb               = { bg = colors.primary },
        PmenuMatch               = { link = "Search" },
        PmenuMatchSel            = { link = "CurSearch" },
        PmenuBorder              = { fg = colors.fg_faded },

        ComplMatchIns            = {},
        PreInsert                = {},
        ComplHint                = {},
        ComplHintMore            = {},
        Question                 = {},
        QuickFixLine             = {},
        SnippetTabstop           = {},
        SnippetTabstopActive     = {},
        SpellBad                 = { fg = colors.red },
        SpellCap                 = { fg = colors.yellow },
        SpellLocal               = { fg = colors.blue },
        SpellRare                = { fg = colors.magenta },
        Title                    = { fg = colors.primary, bold = true },
        WildMenu                 = {},
        WinBar                   = {},
        WinBarNC                 = {},

        Menu                     = {},
        Scrollbar                = {},
        Tooltip                  = {},

        -- group-names
        Comment                  = { fg = colors.fg_faded, italic = true },
        SpecialComment           = { fg = colors.green, italic = true },

        Constant                 = { fg = colors.red },
        Identifier               = { fg = highlight.mix(colors.red, colors.yellow, 0.5) },
        Function                 = { fg = colors.blue },
        Type                     = { fg = colors.yellow },
        Structure                = { link = "Type" },
        Typedef                  = { link = "Type" },
        String                   = { fg = colors.green },
        Character                = { link = "String" },
        Number                   = { fg = colors.blue },
        Float                    = { link = "Number" },
        Boolean                  = { link = "Number" },

        Statement                = { fg = colors.magenta },
        Conditional              = { link = "Statement" },
        Repeat                   = { link = "Statement" },
        Label                    = { link = "Statement" },
        Operator                 = { link = "Statement" },
        Keyword                  = { link = "Statement" },
        Exception                = { link = "Statement" },
        StorageClass             = { link = "Statement" },

        PreProc                  = { fg = colors.cyan },
        Include                  = { link = "PreProc" },
        Define                   = { link = "PreProc" },
        Macro                    = { link = "PreProc" },
        PreCondit                = { link = "PreProc" },

        Special                  = {},
        SpecialChar              = { link = "Special" },
        Tag                      = {},
        Delimiter                = {},
        Underlined               = { underline = true },
        Debug                    = {},
        Ignore                   = {},
        Error                    = { fg = colors.red, underline = true },
        Todo                     = { fg = colors.blue, italic = true },
        Added                    = { fg = colors.green },
        Changed                  = { fg = colors.yellow },
        Removed                  = { fg = colors.red },

        -- diagnostic-highlights
        DiagnosticError          = { fg = colors.red },
        DiagnosticWarn           = { fg = colors.yellow },
        DiagnosticInfo           = { fg = colors.blue },
        DiagnosticHint           = { fg = colors.cyan },
        DiagnosticOk             = { fg = colors.green },
        DiagnosticDeprecated     = { strikethrough = true },
        DiagnosticUnderlineError = { fg = colors.red, underline = true },
        DiagnosticUnderlineWarn  = { fg = colors.yellow, underline = true },
        DiagnosticUnderlineInfo  = { fg = colors.blue, underline = true },
        DiagnosticUnderlineHint  = { fg = colors.cyan, underline = true },
        DiagnosticUnderlineOk    = { fg = colors.green, underline = true },


        -- treesitter-highlight-groups

        -- ["@variable"] = {},                    -- various variable names
        -- ["@variable.builtin"] = {},            -- built-in variable names (e.g. `this`, `self`)
        -- ["@variable.parameter"] = {},          -- parameters of a function
        -- ["@variable.parameter.builtin"] = {},  -- special parameters (e.g. `_`, `it`)
        -- ["@variable.member"] = {},             -- object and struct fields
        -- ["@constant"] = {},                    -- constant identifiers
        -- ["@constant.builtin"] = {},            -- built-in constant values
        -- ["@constant.macro"] = {},              -- constants defined by the preprocessor
        -- ["@module"] = {},                      -- modules or namespaces
        -- ["@module.builtin"] = {},              -- built-in modules or namespaces
        -- ["@label"] = {},                       -- `GOTO` and other labels (e.g. `label:` in C), including heredoc labels
        -- ["@string"] = {},                      -- string literals
        -- ["@string.documentation"] = {},        -- string documenting code (e.g. Python docstrings)
        -- ["@string.regexp"] = {},               -- regular expressions
        -- ["@string.escape"] = {},               -- escape sequences
        -- ["@string.special"] = {},              -- other special strings (e.g. dates)
        -- ["@string.special.symbol"] = {},       -- symbols or atoms
        -- ["@string.special.path"] = {},         -- filenames
        -- ["@string.special.url"] = {},          -- URIs (e.g. hyperlinks)
        -- ["@character"] = {},                   -- character literals
        -- ["@character.special"] = {},           -- special characters (e.g. wildcards)
        -- ["@boolean"] = {},                     -- boolean literals
        -- ["@number"] = {},                      -- numeric literals
        -- ["@number.float"] = {},                -- floating-point number literals
        -- ["@type"] = {},                        -- type or class definitions and annotations
        -- ["@type.builtin"] = {},                -- built-in types
        -- ["@type.definition"] = {},             -- identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)
        -- ["@attribute"] = {},                   -- attribute annotations (e.g. Python decorators, Rust lifetimes)
        -- ["@attribute.builtin"] = {},           -- builtin annotations (e.g. `@property` in Python)
        -- ["@property"] = {},                    -- the key in key/value pairs
        -- ["@function"] = {},                    -- function definitions
        -- ["@function.builtin"] = {},            -- built-in functions
        -- ["@function.call"] = {},               -- function calls
        -- ["@function.macro"] = {},              -- preprocessor macros
        -- ["@function.method"] = {},             -- method definitions
        -- ["@function.method.call"] = {},        -- method calls
        -- ["@constructor"] = {},                 -- constructor calls and definitions
        -- ["@operator"] = {},                    -- symbolic operators (e.g. `+`, `*`)
        -- ["@keyword"] = {},                     -- keywords not fitting into specific categories
        -- ["@keyword.coroutine"] = {},           -- keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
        -- ["@keyword.function"] = {},            -- keywords that define a function (e.g. `func` in Go, `def` in Python)
        -- ["@keyword.operator"] = {},            -- operators that are English words (e.g. `and`, `or`)
        -- ["@keyword.import"] = {},              -- keywords for including or exporting modules (e.g. `import`, `from` in Python)
        -- ["@keyword.type"] = {},                -- keywords describing namespaces and composite types (e.g. `struct`, `enum`)
        -- ["@keyword.modifier"] = {},            -- keywords modifying other constructs (e.g. `const`, `static`, `public`)
        -- ["@keyword.repeat"] = {},              -- keywords related to loops (e.g. `for`, `while`)
        -- ["@keyword.return"] = {},              -- keywords like `return` and `yield`
        -- ["@keyword.debug"] = {},               -- keywords related to debugging
        -- ["@keyword.exception"] = {},           -- keywords related to exceptions (e.g. `throw`, `catch`)
        -- ["@keyword.conditional"] = {},         -- keywords related to conditionals (e.g. `if`, `else`)
        -- ["@keyword.conditional.ternary"] = {}, -- ternary operator (e.g. `?`, `:`)
        -- ["@keyword.directive"] = {},           -- various preprocessor directives and shebangs
        -- ["@keyword.directive.define"] = {},    -- preprocessor definition directives
        -- ["@punctuation.delimiter"] = {},       -- delimiters (e.g. `;`, `.`, `,`)
        -- ["@punctuation.bracket"] = {},         -- brackets (e.g. `()`, `{}`, `[]`)
        -- ["@punctuation.special"] = {},         -- special symbols (e.g. `{}` in string interpolation)
        -- ["@comment"] = {},                     -- line and block comments
        -- ["@comment.documentation"] = {},       -- comments documenting code
        -- ["@comment.error"] = {},               -- error-type comments (e.g. `ERROR`, `FIXME`, `DEPRECATED`)
        -- ["@comment.warning"] = {},             -- warning-type comments (e.g. `WARNING`, `FIX`, `HACK`)
        -- ["@comment.todo"] = {},                -- todo-type comments (e.g. `TODO`, `WIP`)
        -- ["@comment.note"] = {},                -- note-type comments (e.g. `NOTE`, `INFO`, `XXX`)
        ["@markup.strong"] = { fg = colors.red, bold = true },    -- bold text
        ["@markup.italic"] = { fg = colors.blue, italic = true }, -- italic text
        -- ["@markup.strikethrough"] = {},        -- struck-through text
        -- ["@markup.underline"] = {},            -- underlined text (only for literal underline markup!)
        ["@markup.heading"] = { fg = colors.red, bold = true },
        ["@markup.heading.1"] = { fg = colors.red, bold = true },
        ["@markup.heading.2"] = { fg = colors.magenta, bold = true },
        ["@markup.heading.3"] = { fg = colors.yellow, bold = true },
        ["@markup.heading.4"] = { fg = colors.cyan, bold = true },
        ["@markup.heading.5"] = { fg = colors.blue, bold = true },
        ["@markup.heading.6"] = { fg = colors.green, bold = true },
        ["@markup.quote"] = { fg = colors.blue, italic = true },
        -- ["@markup.math"] = {},                 -- math environments (e.g. `$ ... $` in LaTeX)
        -- ["@markup.link"] = {},                 -- text references, footnotes, citations, etc.
        -- ["@markup.link.label"] = {},           -- link, reference descriptions
        -- ["@markup.link.url"] = {},             -- URL-style links
        ["@markup.raw"] = { bg = colors.bg_focused },                -- literal or verbatim text (e.g. inline code)
        ["@markup.raw.block"] = { link = "@markup.raw" },            -- literal or verbatim text as a stand-alone block
        ["@markup.list"] = { fg = colors.magenta, bold = true },     -- list markers
        ["@markup.list.checked"] = { fg = colors.green },            -- checked todo-style list markers
        ["@markup.list.unchecked"] = { fg = colors.fg_highlighted }, -- unchecked todo-style list markers
        -- ["@diff.plus"] = {},                   -- added text (for diff files)
        -- ["@diff.minus"] = {},                  -- deleted text (for diff files)
        -- ["@diff.delta"] = {},                  -- changed text (for diff files)
        -- ["@tag"] = {},                         -- XML-style tag names (e.g. in XML, HTML, etc.)
        -- ["@tag.builtin"] = {},                 -- builtin tag names (e.g. HTML5 tags)
        -- ["@tag.attribute"] = {},               -- XML-style tag attributes
        -- ["@tag.delimiter"] = {},               -- XML-style tag delimiters

        -- lsp-semantic-highlight
        -- ["@lsp.type.class"] = {},         -- Identifiers that declare or reference a class type
        -- ["@lsp.type.comment"] = {},       -- Tokens that represent a comment
        -- ["@lsp.type.decorator"] = {},     -- Identifiers that declare or reference decorators and annotations
        -- ["@lsp.type.enum"] = {},          -- Identifiers that declare or reference an enumeration type
        ["@lsp.type.enumMember"] = { fg = colors.green, italic = true }, -- Identifiers that declare or reference an enumeration property, constant, or member
        -- ["@lsp.type.event"] = {},         -- Identifiers that declare an event property
        -- ["@lsp.type.function"] = {},      -- Identifiers that declare a function
        -- ["@lsp.type.interface"] = {},     -- Identifiers that declare or reference an interface type
        -- ["@lsp.type.keyword"] = {},       -- Tokens that represent a language keyword
        ["@lsp.type.macro"] = { link = "Macro" }, -- Identifiers that declare a macro
        -- ["@lsp.type.method"] = {},        -- Identifiers that declare a member function or method
        -- ["@lsp.type.modifier"] = {},      -- Tokens that represent a modifier
        ["@lsp.type.namespace"] = { fg = colors.red, bold = true }, -- Identifiers that declare or reference a namespace, module, or package
        -- ["@lsp.type.number"] = {},        -- Tokens that represent a number literal
        -- ["@lsp.type.operator"] = {},      -- Tokens that represent an operator
        ["@lsp.type.parameter"] = { fg = colors.fg_highlighted, italic = true }, -- Identifiers that declare or reference a function or method parameters
        -- ["@lsp.type.property"] = {},      -- Identifiers that declare or reference a member property, member field, or member variable
        -- ["@lsp.type.regexp"] = {},        -- Tokens that represent a regular expression literal
        -- ["@lsp.type.string"] = {},        -- Tokens that represent a string literal
        -- ["@lsp.type.struct"] = {},        -- Identifiers that declare or reference a struct type
        -- ["@lsp.type.type"] = {},          -- Identifiers that declare or reference a type that is not covered above
        -- ["@lsp.type.typeParameter"] = {}, -- Identifiers that declare or reference a type parameter
        ["@lsp.type.variable"] = { fg = colors.fg_text }, -- Identifiers that declare or reference a local or global variable
        -- ["@lsp.mod.abstract"] = {},       -- Types and member functions that are abstract
        -- ["@lsp.mod.async"] = {},          -- Functions that are marked async
        -- ["@lsp.mod.declaration"] = {},    -- Declarations of symbols
        -- ["@lsp.mod.defaultLibrary"] = {}, -- Symbols that are part of the standard library
        -- ["@lsp.mod.definition"] = {},     -- Definitions of symbols, for example, in header files
        -- ["@lsp.mod.deprecated"] = {},     -- Symbols that should no longer be used
        -- ["@lsp.mod.documentation"] = {},  -- Occurrences of symbols in documentation
        -- ["@lsp.mod.modification"] = {},   -- Variable references where the variable is assigned to
        -- ["@lsp.mod.readonly"] = {},       -- Readonly variables and member fields (constants)
        -- ["@lsp.mod.static"] = {},         -- Class members (static members)
        ["@lsp.typemod.variable.readonly"] = { link = "Constant" }
    }

    highlight.set(rules)
end

return M
