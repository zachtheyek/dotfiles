-- TODO:
-- define toggle in on_open & on_close to turn off notifications during zenmode
-- (notifications currently handled by nvim-notify, which is wrapped by noice.nvim)
-- turn this toggle off since notifications can be useful info, but have toggle handy for moments where we want them off for max focus

M = {
    window = {
        backdrop = 1, -- keep same background as normal
        width = 120, -- narrow editor width to 120 pixels
        height = 1, -- keep the same height as normal
        options = { laststatus = 0 }, -- disables neovim statusline
    },

    plugins = {
        twilight = { enabled = true }, -- enable twilight dimming effect during zen mode
        tmux = { enabled = true }, -- enable tmux integration (true: disables tmux statusline during zen mode)
        diagnostics = { enabled = false }, -- enable diagnostics integration (false: LSP diagnostics remain visible during zen mode)
        todo = { enabled = false }, -- enable todo integration (false: todo-comments remain visible during zen mode)
        gitsigns = { enabled = true }, -- enable gitsigns integration (true: disables git signs during zen mode)
    },

    on_open = function()
        -- Disable colorizer during zen mode entirely by:
        -- 1. Detaching from all currently attached buffers
        -- 2. Disabling the auto-attach hook for new buffers
        local colorizer = require("colorizer")
        M.colorizer_buffers = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if colorizer.is_buffer_attached(buf) then
                table.insert(M.colorizer_buffers, buf)
                colorizer.detach_from_buffer(buf)
            end
        end
        -- Save and disable the colorizer setup hook
        M.colorizer_hook = _G.COLORIZER_SETUP_HOOK
        _G.COLORIZER_SETUP_HOOK = function() end

        -- Override tmux plugin to prevent unzooming on close
        local zen_plugins = require("zen-mode.plugins")
        if not M.original_tmux_plugin then
            M.original_tmux_plugin = zen_plugins.tmux
        end
        -- Replace with custom version that keeps zoom on close
        zen_plugins.tmux = function(state, disable, opts)
            if not vim.env.TMUX then
                return
            end
            if disable then
                -- On open: run original behavior (zoom pane)
                M.original_tmux_plugin(state, disable, opts)
            else
                -- On close: restore tmux settings but keep pane zoomed
                if type(state.pane) == "string" then
                    vim.fn.system(string.format([[tmux set -w pane-border-status %s]], state.pane))
                else
                    vim.fn.system([[tmux set -uw pane-border-status]])
                end
                vim.fn.system(string.format([[tmux set status %s]], state.status))
            end
        end
    end,

    on_close = function()
        vim.o.laststatus = 3 -- manually redraw neovim statusline on close

        -- Re-enable colorizer after zen mode by:
        -- 1. Restoring the auto-attach hook
        -- 2. Re-attaching to all previously attached buffers
        _G.COLORIZER_SETUP_HOOK = M.colorizer_hook
        local colorizer = require("colorizer")

        -- Use vim.schedule to ensure buffers are fully loaded before reattaching
        vim.schedule(function()
            for _, buf in ipairs(M.colorizer_buffers or {}) do
                if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                    colorizer.attach_to_buffer(buf)
                    -- Force rehighlight for currently visible buffers
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(win) == buf then
                            local options = colorizer.get_buffer_options(buf)
                            if options then
                                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                                colorizer.highlight_buffer(buf, colorizer.DEFAULT_NAMESPACE, lines, 0, options)
                            end
                            break
                        end
                    end
                end
            end
            M.colorizer_buffers = {}
        end)
    end,
}

-- Track cursor positions during zen mode
local zen_buffer_positions = {}
local zen_tracking_group = nil
local zen_restore_group = nil

-- Custom toggle function that stays on current buffer and cursor position when exiting zen mode
local function toggle_zen_mode()
    local zen_mode = require("zen-mode")

    if require("zen-mode.view").is_open() then
        -- Save current buffer's position before closing
        local current_buf = vim.api.nvim_get_current_buf()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        zen_buffer_positions[current_buf] = cursor_pos

        zen_mode.close()

        -- Clean up the tracking autocmd
        if zen_tracking_group then
            vim.api.nvim_del_augroup_by_id(zen_tracking_group)
            zen_tracking_group = nil
        end

        -- Create autocmd to restore cursor positions when entering tracked buffers
        zen_restore_group = vim.api.nvim_create_augroup("ZenModePositionRestore", { clear = true })
        vim.api.nvim_create_autocmd("BufEnter", {
            group = zen_restore_group,
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                if zen_buffer_positions[buf] then
                    local pos = zen_buffer_positions[buf]
                    vim.api.nvim_win_set_cursor(0, pos)
                    -- Remove from table after restoring once
                    zen_buffer_positions[buf] = nil
                    -- Clean up autocmd when all positions are restored
                    if vim.tbl_count(zen_buffer_positions) == 0 and zen_restore_group then
                        vim.api.nvim_del_augroup_by_id(zen_restore_group)
                        zen_restore_group = nil
                    end
                end
            end,
        })

        -- Restore current buffer and cursor position immediately
        vim.api.nvim_set_current_buf(current_buf)
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        zen_buffer_positions[current_buf] = nil -- Remove current buffer from tracking
    else
        zen_mode.open()

        -- Set up autocommand to track cursor positions as we move between buffers
        zen_buffer_positions = {}
        zen_tracking_group = vim.api.nvim_create_augroup("ZenModeBufferTracking", { clear = true })
        vim.api.nvim_create_autocmd("BufLeave", {
            group = zen_tracking_group,
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                local pos = vim.api.nvim_win_get_cursor(0)
                zen_buffer_positions[buf] = pos
            end,
        })
    end
end

vim.keymap.set("n", "<leader>z", toggle_zen_mode, { desc = "Toggle Zen Mode" })

return M
