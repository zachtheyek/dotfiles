vim.cmd("luafile " .. vim.fn.stdpath("config") .. "/lua/types/definitions.lua")

---@type ChadrcConfig

local M = {}

M.base46 = {
    theme = "catppuccin",
    hl_override = {
        -- Override NvimTree highlights for transparency
        NvimTreeNormal = { bg = "none" },
        NvimTreeNormalNC = { bg = "none" },
        NvimTreeEndOfBuffer = { bg = "none" },
        NvimTreeWinSeparator = { bg = "none" },

        -- Brighten comments for better visibility
        Comment = { fg = "#7f849c" },
        ["@comment"] = { fg = "#7f849c" }, -- TreeSitter uses @comment instead of Comment
    },
    changed_themes = {},
    transparency = true,
}

M.nvdash = {
    load_on_startup = false, -- Disable NVChad landing page
}

M.ui = {
    tabufline = { enabled = false },
}

M.plugins = "plugins.plugins"

return M
