-- WARN:
-- some weird behavior in alpha dashboard when entering nvim without args (i.e. just "nvim")
-- not sure how to fix. just enter with args for now (e.g. "nvim ." or "nvim filename.txt")

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Helper function to load session
local function load_session()
    vim.g.alpha_session_loaded = true
    vim.g.used_non_alpha_buffer = true

    if vim.fn.filereadable("Session.vim") == 1 then
        local alpha_buf = vim.api.nvim_get_current_buf()
        vim.cmd("source Session.vim")

        -- Delete alpha buffer after session loads
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(alpha_buf) then
                vim.api.nvim_buf_delete(alpha_buf, { force = true })
            end
        end)

        vim.cmd("Obsess Session.vim")
    else
        vim.notify("No Session.vim found in current directory", vim.log.levels.ERROR)
    end
end

-- Catppuccin Mocha colors
vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa" })
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4" })
vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f5c2e7" })
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#bac2de" })

-- Set header
dashboard.section.header.val = {
    "                                                                                  ",
    "███████╗ █████╗  ██████╗██╗  ██╗████████╗██╗  ██╗███████╗██╗   ██╗███████╗██╗  ██╗",
    "╚══███╔╝██╔══██╗██╔════╝██║  ██║╚══██╔══╝██║  ██║██╔════╝╚██╗ ██╔╝██╔════╝██║ ██╔╝",
    "  ███╔╝ ███████║██║     ███████║   ██║   ███████║█████╗   ╚████╔╝ █████╗  █████╔╝ ",
    " ███╔╝  ██╔══██║██║     ██╔══██║   ██║   ██╔══██║██╔══╝    ╚██╔╝  ██╔══╝  ██╔═██╗ ",
    "███████╗██║  ██║╚██████╗██║  ██║   ██║   ██║  ██║███████╗   ██║   ███████╗██║  ██╗",
    "╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝",
    "                                                                                  ",
}
dashboard.section.header.opts.hl = "AlphaHeader"

-- Set menu buttons
dashboard.section.buttons.val = {
    dashboard.button("1", "     Resume Session", "<cmd>lua require('configs.alpha').load_session()<CR>"),
    dashboard.button("2", "     New File", ":ene <BAR> startinsert <CR>"),
    dashboard.button("3", "     Find File", ":Telescope find_files<CR>"),
    dashboard.button("4", "     Find Text", ":Telescope live_grep<CR>"),
    dashboard.button("5", "   󱘎  Filetree", ":NvimTreeToggle<CR>"),
    dashboard.button(
        "6",
        "   󰛢  Harpoon",
        ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>"
    ),
    dashboard.button("7", "     Plugins", ":e ~/.config/nvim/lua/plugins/plugins.lua<CR>"),
    dashboard.button(
        "8",
        "   󰈆  Quit",
        "<cmd>lua if not vim.g.alpha_session_loaded then vim.g.obsession_skip_next_save = true end<CR>:qa<CR>"
    ),
}

for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
end

-- Set footer with random quotes
dashboard.section.footer.val = require("alpha.fortune")()
dashboard.section.footer.opts.hl = "AlphaFooter"

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Auto-open alpha on startup (unless a specific file is opened)
vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local buf_name = vim.api.nvim_buf_get_name(0)
        local is_empty = (#lines == 0) or (#lines == 1 and lines[1] == "")
        local is_directory = vim.fn.isdirectory(buf_name) == 1
        local no_args = vim.fn.argc() == 0
        local alpha_already_loaded = vim.bo.filetype == "alpha"
        local should_start_alpha = ((is_empty and no_args) or is_directory) and vim.bo.filetype == ""

        if should_start_alpha then
            vim.g.started_with_alpha = true
            require("alpha").start()
        elseif alpha_already_loaded then
            -- Alpha already loaded by NvChad
            vim.g.started_with_alpha = true
        else
            vim.g.started_with_alpha = false
        end
    end,
})

-- Disable line numbers and cursor styling on alpha buffer
local alpha_opts_group = vim.api.nvim_create_augroup("AlphaDisableNumbers", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = alpha_opts_group,
    pattern = "alpha",
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.cursorline = false
        vim.opt_local.foldenable = false
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = alpha_opts_group,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "alpha" then
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.cursorline = false
            vim.opt_local.foldenable = false
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = alpha_opts_group,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "alpha" then
            vim.wo.number = false
            vim.wo.relativenumber = false
            vim.wo.cursorline = false
            vim.opt_local.foldenable = false
        end
    end,
})

-- Track when user enters a real file buffer and start Obsess tracking
local tracking_group = vim.api.nvim_create_augroup("AlphaObsessionTracking", { clear = true })
local should_check_buffers = false

vim.api.nvim_create_autocmd("BufLeave", {
    group = tracking_group,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "alpha" then
            should_check_buffers = true
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = tracking_group,
    pattern = "*",
    callback = function()
        if not should_check_buffers then
            return
        end

        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype
        local buf_name = vim.api.nvim_buf_get_name(0)

        -- Skip special buffers
        local ignore_ft =
            { "alpha", "TelescopePrompt", "harpoon", "NvimTree", "help", "qf", "lazy", "mason", "noice", "notify" }
        local ignore_bt = { "nofile", "prompt", "popup", "help", "quickfix", "terminal" }

        for _, ft in ipairs(ignore_ft) do
            if filetype == ft then
                return
            end
        end

        for _, bt in ipairs(ignore_bt) do
            if buftype == bt then
                return
            end
        end

        -- Only proceed if buffer has an actual filename
        if buf_name == "" or buf_name:match("^%[.*%]$") then
            return
        end

        -- Mark that user has used a non-alpha buffer
        vim.g.used_non_alpha_buffer = true

        -- Start tracking if not already tracking
        if vim.v.this_session == "" then
            local session_exists = vim.fn.filereadable("Session.vim") == 1
            local is_git_repo = vim.fn.isdirectory(".git") == 1

            if session_exists or is_git_repo then
                vim.cmd("Obsess Session.vim")
            end
        end

        -- Remove autocmds after first successful trigger
        vim.api.nvim_clear_autocmds({ group = tracking_group })
    end,
})

-- Export load_session function for button access
return {
    load_session = load_session,
}
