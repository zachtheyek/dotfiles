-- NOTE: FTerm instances are not persisted across sessions. For long-running processes, use tmux panes
local M = {}

M.setup = function()
    require("FTerm").setup({
        border = "rounded",
        dimensions = {
            height = 0.8, -- Height of terminal window
            width = 0.8, -- Width of terminal window
            x = 0.5, -- X-axis of terminal window
            y = 0.5, -- Y-axis of terminal window
        },
        blend = 0, -- Set terminal window transparency (0=fully transparent)
        auto_close = true,
    })
end

-- NOTE:
-- There are 2 terminal session types:
-- "Main" -> state persisted within a session
-- "Scratch" -> ephemeral state; exits as soon as given command terminates
-- At any give time, only 1 of each session type, and at most 2 terminal sessions, may exist
-- Specifically, you can toggle the main terminal while a scratch terminal is open, but not vice versa
-- -- BUG: scratch terminal displays linenumbers when toggling main terminal on top of it (linenumbers should be hidden)
M.keys = {
    {
        "<leader>tt",
        "<CMD>lua require('FTerm').toggle()<CR>",
        desc = "Toggle Floating Terminal (Main)",
        mode = { "n", "t" },
    },
    {
        "<leader>tr",
        function()
            vim.ui.input({ prompt = "Run command: " }, function(input)
                if input then
                    require("FTerm").scratch({ cmd = input })
                end
            end)
        end,
        desc = "Run Single Command (Scratch)",
    },
    {
        "<leader>tp",
        "<CMD>lua require('FTerm').scratch({ cmd = 'ipython' })<CR>",
        desc = "Open iPython Session (Scratch)",
    },
    -- TODO: add more custom key bindings for frequently used ephemeral commands
}

return M
