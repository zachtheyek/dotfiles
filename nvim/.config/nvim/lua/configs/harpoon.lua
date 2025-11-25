-- TODO: have a custom function s.t. when opening cwd with v ., we save the harpoon menu to a tmp file, then loads the entire cwd into the harpoon menu s.t. we can use next/prev to easily explore the cwd. set size/level limits so we don't overwhelm the menu. on exit, clean the harpoon menu, then pop the tmp file contents back & delete the tmp file
-- BUG: weird behavior when moving beyond harpoon menu bounds (no wrap, but jumps out of menu)

local M = {}

function M.setup()
    local harpoon = require("harpoon")
    local map = vim.keymap.set

    harpoon:setup({
        settings = {
            save_on_toggle = true,
            sync_on_ui_close = true,
            key = function()
                return vim.loop.cwd()
            end,
        },
    })

    -- Configure Harpoon menu appearance and behavior
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "harpoon",
        callback = function()
            -- BUG:
            -- edge case still exists -> enter & exit insert mode in harpoon menu switches relative linenumbers on
            -- likely stems from interactions with comfy-line-numbers & nvim-numbertoggle
            -- think about what linenumber behavior we actually want in our harpoon UI

            -- Disable relative line numbers
            vim.opt_local.relativenumber = false
            vim.opt_local.number = true

            -- Enable cursorline (colors handled by autocmds.lua)
            vim.opt_local.cursorline = true
        end,
    })

    -- Ensure relative line numbers stay disabled when switching modes
    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "ModeChanged" }, {
        pattern = "*",
        callback = function()
            if vim.bo.filetype == "harpoon" then
                vim.opt_local.relativenumber = false
            end
        end,
    })

    -- Keymaps
    map("n", "<leader>ha", function()
        harpoon:list():add()
    end, { desc = "Harpoon Add File" })

    map("n", "<leader>hx", function()
        local list = harpoon:list()
        local current_file = vim.api.nvim_buf_get_name(0)
        -- Convert to relative path from CWD to match Harpoon's storage format
        current_file = vim.fn.fnamemodify(current_file, ":.")

        -- Find current buffer's index in harpoon list
        local current_index = nil
        for i = 1, list:length() do
            local item = list:get(i)
            if item and item.value == current_file then
                current_index = i
                break
            end
        end

        if not current_index then
            vim.notify("Current buffer is not in the Harpoon menu", vim.log.levels.WARN)
            return
        end

        -- Check if we're in the harpoon menu
        local in_menu = vim.bo.filetype == "harpoon"

        -- Close menu if open
        if in_menu then
            harpoon.ui:toggle_quick_menu(list)
        end

        -- Create a new items array without the removed item
        local new_items = {}
        for i, item in ipairs(list.items) do
            if i ~= current_index and item and item.value and item.value ~= "" then
                table.insert(new_items, item)
            end
        end

        -- Replace the entire items table
        list.items = new_items

        -- Update internal length if it exists
        if list._length then
            list._length = #new_items
        end

        -- Reopen menu if it was open
        if in_menu then
            vim.defer_fn(function()
                harpoon.ui:toggle_quick_menu(list)
            end, 50)
        end

        vim.notify("Removed from Harpoon menu", vim.log.levels.INFO)
    end, { desc = "Harpoon Remove File" })

    -- TODO: how to add file preview?
    map("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon Menu" })

    map("n", "<leader>hf", "<cmd>Telescope harpoon marks<CR>", { desc = "Telescope Harpoon Files" })

    map("n", "<leader>h1", function()
        harpoon:list():select(1)
    end, { desc = "Harpoon to File 1" })

    map("n", "<leader>h2", function()
        harpoon:list():select(2)
    end, { desc = "Harpoon to File 2" })

    map("n", "<leader>h3", function()
        harpoon:list():select(3)
    end, { desc = "Harpoon to File 3" })

    map("n", "<leader>h4", function()
        harpoon:list():select(4)
    end, { desc = "Harpoon to File 4" })

    map("n", "<leader>h5", function()
        harpoon:list():select(5)
    end, { desc = "Harpoon to File 5" })

    map("n", "<leader>h6", function()
        harpoon:list():select(6)
    end, { desc = "Harpoon to File 6" })

    map("n", "<leader>h7", function()
        harpoon:list():select(7)
    end, { desc = "Harpoon to File 7" })

    map("n", "<leader>h8", function()
        harpoon:list():select(8)
    end, { desc = "Harpoon to File 8" })

    map("n", "<leader>h9", function()
        harpoon:list():select(9)
    end, { desc = "Harpoon to File 9" })

    map("n", "<leader>hn", function()
        local list = harpoon:list()
        local current_file = vim.api.nvim_buf_get_name(0)
        -- Convert to relative path from CWD to match Harpoon's storage format
        current_file = vim.fn.fnamemodify(current_file, ":.")
        local list_length = list:length()

        -- Find current buffer's index in harpoon list
        local current_index = nil
        for i = 1, list_length do
            local item = list:get(i)
            if item and item.value == current_file then
                current_index = i
                break
            end
        end

        if not current_index then
            vim.notify("Current buffer is not in the Harpoon menu", vim.log.levels.WARN)
            return
        end

        -- Navigate to next file with wrapping
        local next_index = current_index % list_length + 1
        list:select(next_index)
    end, { desc = "Harpoon Next File" })

    map("n", "<leader>hp", function()
        local list = harpoon:list()
        local current_file = vim.api.nvim_buf_get_name(0)
        -- Convert to relative path from CWD to match Harpoon's storage format
        current_file = vim.fn.fnamemodify(current_file, ":.")
        local list_length = list:length()

        -- Find current buffer's index in harpoon list
        local current_index = nil
        for i = 1, list_length do
            local item = list:get(i)
            if item and item.value == current_file then
                current_index = i
                break
            end
        end

        if not current_index then
            vim.notify("Current buffer is not in the Harpoon menu", vim.log.levels.WARN)
            return
        end

        -- Navigate to previous file with wrapping
        local prev_index = (current_index - 2) % list_length + 1
        list:select(prev_index)
    end, { desc = "Harpoon Previous File" })
end

M.setup()

return M
