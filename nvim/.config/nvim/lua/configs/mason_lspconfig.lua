local M = {}

M.servers = {
    "bash-language-server",
    "clangd",
    "cmake-language-server",
    "css-lsp",
    "dockerfile-language-server",
    "html-lsp",
    "jdtls",
    "typescript-language-server",
    "json-lsp",
    "julia-lsp",
    "texlab",
    "lua-language-server",
    "marksman",
    "ocaml-lsp",
    "pyright",
    "r-languageserver",
    "rust-analyzer",
    "sqlls",
    "lemminx",
    "yaml-language-server",
}

M.opts = {
    ensure_installed = M.servers,
    automatic_installation = true, -- Auto-install LSP servers on file open
}

return M
