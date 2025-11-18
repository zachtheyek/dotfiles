-- NOTE: why does scope highlighting work on some files but not others?

-- Setup custom highlight colors for indent guides
local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })
end)

return {
    -- Indent character appearance
    indent = {
        char = "│",
        tab_char = "│",
        highlight = "IblIndent", -- Use custom highlight
    },

    -- Scope highlighting (requires TreeSitter)
    scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = "IblScope", -- Use custom highlight
    },

    -- Whitespace handling
    whitespace = {
        remove_blankline_trail = true,
    },

    -- TODO: tweak as needed
    -- Exclude certain filetypes
    exclude = {
        filetypes = {
            "help",
            "alpha",
            "dashboard",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
        },
    },
}
