-- NOTE:
-- Unlike LSPs, linters/formatters need to be in the system PATH since conform.nvim calls them as system commands
-- If possible, install them via Homebrew
-- NOTE:
-- How do i include language-specific configs? need to specify at project-level?

local M = {}

-- TODO: add linters/formatters for
-- Rust: rustfmt
-- Java: google-java-format
-- OCaml: ocamlformat
-- Julia: JuliaFormatter.jl
-- NOTE:
-- conform.nvim only handler formatting. see nvim-lint for linting
-- ask claude to suggest linter plugins for each language. sync with LSPs & formatters
-- TODO: look into debuffers as well. ask claude for plugin suggestions. start with Python/C++
M.formatters_by_ft = {
    -- TODO: create global ruff config at ~/.config/ruff/ruff.toml (structured similarly to local configs: pyproject.toml). note that local configs take precedent over global configs (can either override with tool.ruff.lint.select, or work in parallel with tool.ruff.lint.extend-select, for example)
    -- Python
    python = {
        "ruff_format",
        "ruff_fix",
    },
    -- C/C++
    c = { "clang_format" },
    cpp = { "clang_format" },
    -- CMake
    cmake = { "cmake_format" }, -- Managed by Mason, not Homebrew
    -- Bash/Shell
    bash = { "shfmt" },
    sh = { "shfmt" },
    -- SQL
    sql = { "Bsqlfluff" },
    -- Lua
    lua = { "stylua" },
    -- LaTeX
    tex = { "latexindent" },
    -- Web dev
    html = { "prettier" },
    css = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    -- Misc
    dockerfile = { "prettier" },
    markdown = { "prettier" },
    ["markdown.mdx"] = { "prettier" }, -- Markdown + JSX (markdown with react components)
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    xml = { "prettier" },
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
