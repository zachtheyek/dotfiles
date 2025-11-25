-- NOTE:
-- How do i include LSP-specific configs? need to specify at project-level?

-- Load NvChad default LSP settings
require("nvchad.configs.lspconfig").defaults()

-- Configure floating window borders and size (for hover docs and diagnostics)
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    ---@type table
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.max_width = opts.max_width or 80
    opts.max_height = opts.max_height or 20
    opts.focusable = false -- Prevent focus stealing while typing
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local nvlsp = require("nvchad.configs.lspconfig")
local mason_lspconfig = require("configs.mason_lspconfig")

-- Map Mason package names to lspconfig server names
local server_map = {
    ["bash-language-server"] = "bashls", -- .sh, .bash
    ["clangd"] = "clangd", -- .c, .cpp, .h, .hpp
    ["cmake-language-server"] = "cmake", -- CMakeLists.txt, .cmake
    ["css-lsp"] = "cssls", -- .css
    ["dockerfile-language-server"] = "dockerls", -- Dockerfile
    ["html-lsp"] = "html", -- .html
    ["jdtls"] = "jdtls", -- .java
    ["json-lsp"] = "jsonls", -- .json
    ["julia-lsp"] = "julials", -- .jl
    ["lemminx"] = "lemminx", -- .xml
    ["lua-language-server"] = "lua_ls", -- .lua
    ["marksman"] = "marksman", -- .md
    ["ocaml-lsp"] = "ocamllsp", -- .ml, .mli
    ["pyright"] = "pyright", -- .py
    ["rust-analyzer"] = "rust_analyzer", -- .rs
    ["sqlls"] = "sqlls", -- .sql
    ["texlab"] = "texlab", -- .tex
    ["typescript-language-server"] = "ts_ls", -- .js, .jsx, .ts, .tsx
    ["yaml-language-server"] = "yamlls", -- .yml, .yaml
}

-- Apply NVChad default on_attach, on_init, and capabilities to each LSP server
for _, mason_pkg in ipairs(mason_lspconfig.servers) do
    local server_name = server_map[mason_pkg]
    if server_name then
        vim.lsp.config(server_name, {
            on_attach = nvlsp.on_attach,
            on_init = nvlsp.on_init,
            capabilities = nvlsp.capabilities,
        })
        vim.lsp.enable(server_name)
    end
end
