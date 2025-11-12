local M = {}

-- TODO:
-- remap conflicting bindings. C-space: tmux leader key, C-k: moves cursor up in insert mode
-- Tab: accept
-- C-space: open menu (or open docs if already open)
-- C-n/C-p or Up/Down: select next/previous item
-- C-e: hide menu
-- C-k: toggle signature help (if signature.enabled = true)
-- see :h blink-cmp-config-keymap for custom keymap definitions
-- Note: how do i actually use this? currently no autocomplete that i can see? how to integrate with claude code / other AIs?

-- Tab to accept, Ctrl-n/p to navigate
M.keymap = { preset = "super-tab" }

-- Use monospace nerd font icons
M.appearance = { nerd_font_variant = "mono" }

-- Only show documentation popup when manually triggered
M.completion = {
    documentation = { auto_show = false },
    accept = {
        auto_brackets = {
            enabled = true, -- Let blink handle brackets during function completions (see autopairs.lua)
        },
    },
}

-- TODO: add other sources (lspsaga/lspkind, luasnip/friendly-snippets, lazydev, dadbod, copilot/claude, ripgrep, emoji)
-- Default list of autocompletion providers
-- Can be extended elsewhere with `opts_extend`
M.sources = {
    default = {
        "lsp", -- LSP server completions (functions, variables, types)
        "path", -- File/directory path completions
        "snippets", -- Build-in snippet engine
        "buffer", -- Words from current/open buffers
    },
}

-- Prefer rust fuzzy matcher for typo resistance & better performance
-- Fallback to lua implementation if not available
M.fuzzy = { implementation = "prefer_rust_with_warning" }

return M
