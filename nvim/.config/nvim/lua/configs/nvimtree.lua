-- BUG: filetree unhides linenumbers when opening -> switching away -> switching back. linenumbers should always be hidden in filetree
-- -- also happens when toggling FTerm while filetree is open
-- BUG: cursor resets to near-bottom when going from filetree to buffer (without closing filetree)
-- TODO: define list of files/directories to ignore (e.g. .git, .claude). don't strictly follow .gitignore. also no way to toggle on/off showing ignored files?

local M = {}

M.setup = function()
    local nvchad_nvimtree = require("nvchad.configs.nvimtree")
    local preview = require("nvim-tree-preview")

    -- TODO: couldn't get image previews to work
    -- Enable image preview if available
    -- pcall(function()
    --     require("image").setup()
    --     vim.g.nvim_tree_preview_image_kitty = false -- Disable kitty-specific behavior
    -- end)

    nvchad_nvimtree.on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Set default keybindings (only call this once)
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
            return {
                desc = "nvim-tree: " .. desc,
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true,
            }
        end

        -- Preview setup
        local function auto_preview(node)
            if node and node.type == "file" then
                preview.node(node, { toggle_focus = false })
            else
                preview.unwatch()
            end
        end

        -- Automatic preview on cursor movement with debounce
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            callback = function()
                local node = api.tree.get_node_under_cursor()
                auto_preview(node)
            end,
        })

        -- NOTE: what do these do? are they still needed?
        -- TODO: add key binding to expand all directories in filetree
        -- Keymap adjustments
        vim.keymap.del("n", "<Tab>", { buffer = bufnr })
        vim.keymap.del("n", "P", { buffer = bufnr })
        vim.keymap.set("n", "gp", preview.watch, opts("Preview (Watch)"))

        vim.keymap.set("n", "<Esc>", preview.unwatch, opts("Close Preview"))
        vim.keymap.set("n", "<C-f>", function()
            return preview.scroll(4)
        end, opts("Scroll Down"))
        vim.keymap.set("n", "<C-b>", function()
            return preview.scroll(-4)
        end, opts("Scroll Up"))
        -- Smart tab behavior
        vim.keymap.set("n", "<Tab>", function()
            local ok, node = pcall(api.tree.get_node_under_cursor)
            if ok and node then
                if node.type == "directory" then
                    api.node.open.edit()
                else
                    preview.node(node, { toggle_focus = true })
                end
            end
        end, opts("Preview"))

        -- Initial preview when opening the tree
        local node = api.tree.get_node_under_cursor()
        auto_preview(node)
    end

    return nvchad_nvimtree
end

return M
