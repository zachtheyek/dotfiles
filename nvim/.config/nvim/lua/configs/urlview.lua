local M = {}

M.setup = function()
    require("urlview").setup({
        default_title = "URLs",

        -- Use dressing.nvim's telescope picker
        default_picker = "native",

        -- Default is to open URLs in browser
        default_action = "system",
    })
end

M.keys = {
    { "<leader>fu", "<cmd>UrlView<cr>", desc = "Telescope Current Buffer URLs" },
    { "<leader>fp", "<cmd>UrlView lazy<cr>", desc = "Telescope Lazy Plugin URLs" },
}

return M
