-- TODO:
-- (1) add a key binding to add comma at end of pair without moving cursor
--     e.g. | -> press "{" -> {|} -> press key binding -> {|},
-- (2) add a key binding to jump cursor back to last pair
--     e.g. {}| -> press key binding -> {|}

return {
    setup = function()
        local autopairs = require("nvim-autopairs")

        autopairs.setup({
            check_ts = true, -- Enable treesitter for context-aware pairing

            -- Specify treesitter nodes where autopairing should be disabled
            ts_config = {
                lua = { "string" }, -- Lua strings
                javascript = { "template_string" }, -- JS template literals
            },

            -- Specify filetypes where autopairing should be disabled
            disable_filetype = {
                "TelescopePrompt", -- Telescope's search prompt
                "vim", -- Vim command-line buffers
            },

            -- Map <C-Enter> to smart behavior:
            -- Cursor at |
            --     function() {|}
            -- Press <C-Enter>
            --     function() {
            --         |
            --     }
            -- I.e. it expands pairs with proper indentation
            map_cr = true,

            -- NOTE:
            -- Both blink.cmp & nvim-autopairs have autopairing functionality
            -- Blink should only handle completion-time cases (e.g. accepting function completions)
            -- Nvim-autopairs should handle all other cases (namely manual typing of pairs)
            -- If you notice cases of double-pairing, try uncommenting the following line
            -- It tells nvim-autopairs not to auto-close when the next character matches the pattern
            ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        })
    end,
}
