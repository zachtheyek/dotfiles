-- NOTE:
-- LSPs don't have to be installed system-wide since only Neovim needs to communicate with them
-- Hence Mason will handle the installations at ~/.local/share/nvim/mason/packages
-- BTW, even if you install an LSP in your system PATH, Mason will still prefer its version by default (configured in lspconfig.lua)

local M = {}

M.servers = {
    "bash-language-server", -- .sh, .bash
    "clangd", -- .c, .cpp, .h, .hpp
    "cmake-language-server", -- CMakeLists.txt, .cmake
    "css-lsp", -- .css
    "dockerfile-language-server", -- Dockerfile
    "html-lsp", -- .html
    "jdtls", -- .java
    "json-lsp", -- .json
    "julia-lsp", -- .jl
    "lemminx", -- .xml
    "lua-language-server", -- .lua
    "marksman", -- .md
    "ocaml-lsp", -- .ml, .mli
    "pyright", -- .py
    "rust-analyzer", -- .rs
    "sqlls", -- .sql
    "texlab", -- .tex
    "typescript-language-server", -- .js, .jsx, .ts, .tsx
    "yaml-language-server", -- .yml, .yaml
}

M.opts = {
    ensure_installed = M.servers,
    automatic_installation = true, -- Auto-install LSP servers on file open
}

return M
