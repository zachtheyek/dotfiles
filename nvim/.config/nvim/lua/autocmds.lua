local autocmd = vim.api.nvim_create_autocmd

-- Auto-reload files on focus/buffer enter
autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    command = "checktime",
})

-- Always auto-center cursor in normal mode
-- Note, this might affect mouse-wheel scrolling behavior (just use vim motions)
local center_group = vim.api.nvim_create_augroup("AutoCenter", { clear = true })

autocmd({ "CursorMoved" }, {
    group = center_group,
    pattern = "*",
    callback = function()
        -- Don't center on special buffers
        local excluded_ft = { "alpha", "help", "qf", "lazy", "mason" }
        for _, ft in ipairs(excluded_ft) do
            if vim.bo.filetype == ft then
                return
            end
        end
        vim.cmd("normal! zz")
    end,
})

-- BUG: cursor position moves when zooming in/out of tmux-nvim pane. should stay fixed & instead center buffer on new cursor position
autocmd({ "VimResized" }, {
    group = center_group,
    pattern = "*",
    callback = function()
        vim.cmd("normal! zz")
    end,
})

-- Disable auto-commenting on new lines
autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})

-- Force transparency after colorscheme loads
local function apply_transparency()
    -- Editor body transparency
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

    -- NvimTree transparency
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })
    vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "none" })

    -- Lighter cursorline
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3a3a4a" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#3a3a4a" })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#3a3a4a" })
    vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#3a3a4a" })

    -- Noice cmdline colors
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "#2a2a3a", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#89b4fa" })

    -- Nvim-notify colors
    vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#fab387" })
    vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = "#fab387" })
    vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = "#fab387" })
    vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#cba6f7" })
    vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#cba6f7" })
    vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#cba6f7" })
    vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#94e2d5" })
    vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#94e2d5" })
    vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#94e2d5" })
end

autocmd("ColorScheme", {
    pattern = "*",
    callback = apply_transparency,
})

autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        vim.defer_fn(apply_transparency, 50)
    end,
})

autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        -- Don't apply to alpha or special buffers
        local excluded_ft = { "alpha", "lazy", "mason", "TelescopePrompt" }
        for _, ft in ipairs(excluded_ft) do
            if vim.bo.filetype == ft then
                return
            end
        end
        -- Re-enable cursorline and line numbers for regular buffers
        vim.wo.cursorline = true
        vim.wo.number = true
        vim.wo.relativenumber = true
        vim.defer_fn(apply_transparency, 10)
    end,
})

-- Disable cursorline in Telescope prompt
autocmd("FileType", {
    pattern = "TelescopePrompt",
    callback = function()
        vim.wo.cursorline = false
    end,
})

autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        vim.defer_fn(apply_transparency, 50)
    end,
})

autocmd("FileType", {
    pattern = "NvimTree",
    callback = function()
        apply_transparency()
    end,
})

autocmd("User", {
    pattern = "LazySync",
    callback = function()
        vim.defer_fn(apply_transparency, 50)
    end,
})

autocmd("User", {
    pattern = "LazyUpdate",
    callback = function()
        vim.defer_fn(apply_transparency, 50)
    end,
})

autocmd("User", {
    pattern = "LazyCheck",
    callback = function()
        vim.defer_fn(apply_transparency, 50)
    end,
})
