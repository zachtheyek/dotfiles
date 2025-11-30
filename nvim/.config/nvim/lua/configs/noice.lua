-- BUG: cmdline isn't transparent like the other UI elements (buffer, filetree, harpoon menu, telescope picker)

return {
    cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {
            position = {
                row = "30%", -- center vertically
                col = "50%", -- center horizontally
            },
        },
    },
    views = {
        mini = {
            backend = "mini",
            relative = "editor",
            align = "message-right",
            timeout = 2000,
            reverse = true,
            position = {
                row = -2,
                col = "100%",
            },
        },
    },
    routes = {
        -- Route messages longer than 10 lines to separate split
        {
            view = "split",
            filter = { event = "msg_show", min_height = 10 },
        },
    },
    lsp = {
        progress = {
            enabled = true,
            view = "mini", -- Unobtrusive bottom-right corner
            throttle = 1000 / 30,
        },
        -- BUG: noice's LSP signature/hover handling steals focus while typing in insert mode
        -- Known issue: https://github.com/folke/noice.nvim/issues/1016
        -- Disabling noice's LSP handlers; using native LSP + blink.cmp instead
        signature = {
            enabled = false,
        },
        hover = {
            enabled = false,
        },
        -- Override markdown rendering so that **blink.cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- Enable recommended presets for better UX
    presets = {
        -- BUG: popupmenu (above) overlaps with cmdline (below) vertically when former has too many options (look at dressing.lua telescope config too, and also telescope.lua itself)
        command_palette = true, -- position cmdline and popupmenu together
        long_message_to_split = true, -- long messages sent to split
        bottom_search = false, -- use popup cmdline for search instead of classic bottom
        inc_rename = false, -- enables input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add border to hover docs and signature help
    },
}
