-- TODO:
-- current settings are based on defaults
-- test on real project, then tweak configs & keys based on preferences
-- https://github.com/folke/trouble.nvim?tab=readme-ov-file#-installation
-- https://github.com/folke/trouble.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
-- https://github.com/folke/trouble.nvim?tab=readme-ov-file#-usage
-- improve UI & contents
-- https://github.com/folke/trouble.nvim/blob/main/docs/examples.md
-- https://github.com/folke/trouble.nvim/blob/main/docs/filter.md
-- integrate telescope & fzf & lualine
-- https://github.com/folke/trouble.nvim?tab=readme-ov-file#telescope
-- https://github.com/folke/trouble.nvim?tab=readme-ov-file#fzf-lua
-- https://github.com/folke/trouble.nvim?tab=readme-ov-file#statusline-component
-- remap key bindings to something more sensible
-- Note: how do i actually use this? how to pull up menu to see all diagnostics? how to jump between diagnostics in current file? how to enable linewrap for diagnostics? how to search diagnostics across code base?

local M = {}

M.keys = {
    {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
    },
    {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
    },
    {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
    },
    {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
    },
    {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
    },
}

return M
