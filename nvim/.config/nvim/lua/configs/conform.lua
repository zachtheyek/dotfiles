local M = {}

-- TODO: currently only configured for Python. add more formatters (sync with lsp & treesitter)
M.formatters_by_ft = {
    python = {
        "ruff_format", -- Code formatting
        "ruff_fix", -- Auto-fixes (e.g. import sorting)
    },
}

-- Configure formatters to run on buffer save
M.format_on_save = function(bufnr)
    -- NOTE:
    -- To disable autoformatting temporarily, do :lua vim.g.disable_autoformat = true
    -- Save your changes, then do :lua vim.g.disable_autoformat = false
    -- Note that vim.g.disable_autoformat is global in scope, but resets to false upon quitting neovim
    ---@diagnostic disable-next-line: undefined-field
    if vim.g.disable_autoformat then
        return
    end
    return {
        timeout_ms = 500,
        lsp_fallback = true, -- Fallback to LSP if formatter isn't available
    }
end

return M
