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
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local nvlsp = require("nvchad.configs.lspconfig")
local mason_lspconfig = require("configs.mason_lspconfig")

-- Map Mason package names to lspconfig server names
local server_map = {
    ["bash-language-server"] = "bashls",
    ["clangd"] = "clangd",
    ["cmake-language-server"] = "cmake",
    ["css-lsp"] = "cssls",
    ["dockerfile-language-server"] = "dockerls",
    ["html-lsp"] = "html",
    ["jdtls"] = "jdtls",
    ["typescript-language-server"] = "ts_ls",
    ["json-lsp"] = "jsonls",
    ["julia-lsp"] = "julials",
    ["texlab"] = "texlab",
    ["lua-language-server"] = "lua_ls",
    ["marksman"] = "marksman",
    ["ocaml-lsp"] = "ocamllsp",
    ["pyright"] = "pyright",
    ["r-languageserver"] = "r_language_server",
    ["rust-analyzer"] = "rust_analyzer",
    ["sqlls"] = "sqlls",
    ["lemminx"] = "lemminx",
    ["yaml-language-server"] = "yamlls",
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
    end
end
