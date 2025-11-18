-- TODO: learn how to use this plugin alongside other LSP tools
-- TODO: how do i switch focus to floating window? similar to tab for nvim-tree

local M = {}

M.setup = function()
    require("goto-preview").setup({
        -- TODO: match dimensions with other plugins' floating windows. use relative dimensions?
        -- Window dimensions
        width = 120,
        height = 15,

        -- Border style
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },

        -- TODO: define custom bindings & sync with which-key
        -- Default bindings:
        -- nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
        -- nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
        -- nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
        -- nnoremap gpD <cmd>lua require('goto-preview').goto_preview_declaration()<CR>
        -- nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
        -- nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
        default_mappings = true,

        -- Don't switch focus to floating window on open
        focus_on_open = false,

        -- Close floating window on cursor move (in parent buffer)
        dismiss_on_move = true,

        -- Don't nest floating windows
        stack_floating_preview_windows = false,

        -- Set preview window title as filename
        preview_window_title = { enable = true, position = "center" },

        -- Override vim.ui.input with goto-preview floating window
        vim_ui_input = true,
    })
end

return M
