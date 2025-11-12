-- FIX:
-- why does "no signature help available" notification keep popping up?
-- i think it has something to do with autopairs (specifically when working with "(" or ")")

local M = {}

M.setup = function()
    local notify = require("notify")

    notify.setup({
        -- Render style for notifications display
        render = "compact",

        -- Timeout for notifications in ms
        timeout = 2000,

        -- Background color opacity
        background_colour = "#000000",

        -- Animation for disappearing notifications
        stages = "fade",

        -- Icons for different notification levels
        icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "✎",
        },

        -- Minimum width/height
        minimum_width = 50,
        max_width = 80,
        max_height = 10,
    })

    -- Set as default notify handler
    vim.notify = notify
end

-- Add custom key bindings
M.keys = {
    { "<leader>nn", "<cmd>Telescope notify<cr>", desc = "Notifications History" },
    { "<leader>nf", "<cmd>Telescope notify<cr>", desc = "Telescope Notifications" },
    {
        "<leader>nc",
        function()
            require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Clear Notifications",
    },
}

return M
