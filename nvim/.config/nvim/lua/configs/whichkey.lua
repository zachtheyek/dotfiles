return {
    -- Choose layout style
    preset = "helix",

    -- Delay before which-key popup appears (ms)
    delay = 1000,

    -- TODO:
    -- (1) Verify key bindings are named and grouped correctly (note: desc should be capitalized)
    -- (2) Rename/remap key bindings where necessary
    -- (3) Reorder groups using sensible order

    -- Custom mappings and groups with icons
    -- These icons only apply to the group labels themselves
    -- To add icons to individual commands, add icon field to each keymap definition
    spec = {
        { "<leader>f", group = "Find", icon = "󰍉" }, -- NOTE: not cleaned
        { "<leader>h", group = "Harpoon", icon = "󰛢" },
        { "<leader>g", group = "Git", icon = "󰊢" }, -- NOTE: not cleaned
        { "<leader>c", group = "Code/Commits", icon = "󰘦" }, -- NOTE: not cleaned
        { "<leader>r", group = "Rename/Relative", icon = "󰑕" }, -- NOTE: not cleaned
        { "<leader>w", group = "Workspace", icon = "󰉋" }, -- NOTE: not cleaned
        { "<leader>m", group = "Marks", icon = "󰃀" }, -- NOTE: not cleaned
        { "<leader>p", group = "Pick/Paste", icon = "󰆒" }, -- NOTE: not cleaned
        { "<leader>t", group = "Terminal", icon = "󰆍" },
        { "<leader>d", group = "Delete/Diagnostic", icon = "󰆴" }, -- NOTE: not cleaned
        { "<leader>x", group = "Close", icon = "󰅖" }, -- NOTE: not cleaned
        { "<leader>n", group = "Notifications", icon = "󰂚" },
    },

    -- Don't show notification warnings
    notify = false,

    -- Configure what activates the popup
    triggers = {
        { "<auto>", mode = "nixsotc" }, -- auto setup triggers
    },

    -- Set conditional show behavior (never defer)
    defer = function(ctx)
        return false
    end,

    -- Enable built-in helpers
    plugins = {
        marks = true, -- shows marks on ' and `
        registers = true, -- shows registers on " in NORMAL or <C-r> in INSERT
        spelling = {
            enabled = true, -- show spelling suggestions with z=
            suggestions = 20,
        },
        presets = {
            operators = true, -- help for d, y, c, etc.
            motions = true, -- help for motions
            text_objects = true, -- help for text objects after operators
            windows = true, -- bindings on <c-w>
            nav = true, -- misc window bindings
            z = true, -- bindings for folds, spelling, etc.
            g = true, -- bindings for g
        },
    },

    -- BUG: dual column views don't display properly (e.g. space+h cuts off rightmost column)
    -- Set column dimensions
    layout = {
        width = { min = 15 }, -- min width of columns
        spacing = 2, -- spacing between columns
    },

    -- Expand groups when they have <= this many mappings
    -- Set to 0 to never auto-expand (keep groups collapsed)
    -- Set to 999 to always expand and show all individual keymaps
    expand = 0,

    -- Visual representations and UI styling
    -- This is different from spec icons - these are global UI-wide settings
    icons = {
        breadcrumb = "»", -- symbol in command line showing active key combo
        separator = "➜", -- symbol between key and label
        group = "+", -- symbol prepended to groups
        ellipsis = "…",
        mappings = true, -- show icons from spec
        rules = {}, -- custom icon rules (using defaults)
        colors = true, -- use icon colors

        -- Special key representations
        -- Defines how special keys are displayed in the popup (cosmetic UI styling)
        -- For example, <C-h> shows as "󰘴 h" instead of "Ctrl+h"
        keys = {
            Up = "↑",
            Down = "↓",
            Left = "←",
            Right = "→",
            C = "󰘴 ", -- Ctrl
            M = "󰘵 ", -- Alt/Meta
            D = "󰘳 ", -- Cmd (Mac)
            S = "󰘶 ", -- Shift
            CR = "󰌑 ", -- Enter
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰌑 ",
            BS = "󰁮", -- Backspace
            Space = "󱁐 ",
            Tab = "󰌒 ",
            F1 = "󱊫",
            F2 = "󱊬",
            F3 = "󱊭",
            F4 = "󱊮",
            F5 = "󱊯",
            F6 = "󱊰",
            F7 = "󱊱",
            F8 = "󱊲",
            F9 = "󱊳",
            F10 = "󱊴",
            F11 = "󱊵",
            F12 = "󱊶",
        },
    },

    -- Toggle hints
    show_help = true,
    show_keys = true,
}
