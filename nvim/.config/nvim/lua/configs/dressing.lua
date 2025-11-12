return {
    input = {
        -- Enable enhanced input UI
        enabled = true,

        -- Default prompt string
        default_prompt = "Input",

        -- Trim trailing colons from prompts
        trim_prompt = true,

        -- Title position
        title_pos = "center",

        -- Start in insert mode
        start_mode = "insert",

        -- Window border style
        border = "rounded",

        -- Position relative to cursor
        relative = "win",

        -- Window dimensions
        prefer_width = 0.8,

        -- Window options
        win_options = {
            winblend = 0,
            winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder",
        },

        -- Keymaps for prompt navigation
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["<CR>"] = "Confirm",
            },
            i = {
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
            },
        },
    },

    select = {
        -- Enable enhanced select UI
        enabled = true,

        -- Backend priority (telescope first, then builtin)
        backend = { "telescope", "builtin" },

        -- Telescope-specific configuration
        telescope = require("telescope.themes").get_dropdown({
            layout_config = {
                width = 0.8,
                height = 0.6,
            },
        }),

        -- Builtin selector options
        builtin = {
            -- Show line numbers
            show_numbers = true,

            -- Window border style
            border = "rounded",

            -- Relative positioning
            relative = "editor",

            -- Window dimensions
            min_width = 40,
            max_width = 80,
            min_height = 10,
            max_height = 20,

            -- Window options
            win_options = {
                winblend = 0,
                winhighlight = "NormalFloat:Normal,FloatBorder:FloatBorder,CursorLine:Visual",
            },

            -- Keymaps
            mappings = {
                ["<Esc>"] = "Close",
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
            },
        },
    },
}
