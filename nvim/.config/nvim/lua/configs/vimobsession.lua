-- TODO: add keybinding for :Obsess (starting/pausing session tracking)

local M = {}

function M.setup()
    local session_file = "Session.vim" -- strict naming to maintain compatability with tmux-resurrect

    -- Check if current directory is a git repo
    local function is_git_repo()
        return vim.fn.isdirectory(".git") == 1
    end

    -- Auto-save session
    local function save_session()
        -- Check if we should skip this save
        if vim.g.obsession_skip_next_save then
            vim.g.obsession_skip_next_save = false
            return
        end

        -- Don't save if user only interacted with alpha dashboard
        if vim.g.started_with_alpha and not vim.g.used_non_alpha_buffer then
            return
        end

        if vim.v.this_session ~= "" then
            vim.cmd("silent! Obsess")
        end
    end

    -- Auto-start on VimEnter (only if NOT starting with alpha dashboard)
    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        nested = true,
        callback = function()
            -- Defer to ensure lazy.nvim finishes loading
            vim.defer_fn(function()
                -- Skip if Lazy UI is open
                local lazy_view_ok, lazy_view = pcall(require, "lazy.view")
                if lazy_view_ok and lazy_view.visible() then
                    return
                end

                -- Skip if started with alpha dashboard
                if vim.g.started_with_alpha then
                    return
                end

                -- Skip if current buffer is alpha
                if vim.bo.filetype == "alpha" then
                    return
                end

                -- Skip if current buffer is empty/unnamed (alpha will open)
                local buf_name = vim.api.nvim_buf_get_name(0)
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                local is_empty = buf_name == "" and ((#lines == 0) or (#lines == 1 and lines[1] == ""))

                if is_empty then
                    return
                end

                local session_exists = vim.fn.filereadable(session_file) == 1

                -- Don't auto-load session, only start tracking
                -- Session loading is manual via alpha dashboard button 2
                if session_exists then
                    vim.cmd("Obsess " .. session_file)
                elseif is_git_repo() then
                    vim.cmd("Obsess " .. session_file)
                end
            end, 100)
        end,
    })

    -- Auto-save on exit
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = save_session,
    })

    -- Periodic auto-save (every 5 minutes)
    ---@diagnostic disable-next-line: undefined-field
    local timer = vim.uv.new_timer()
    timer:start(5 * 60 * 1000, 5 * 60 * 1000, vim.schedule_wrap(save_session))

    -- Clean up timer on exit
    vim.api.nvim_create_autocmd("VimLeave", {
        callback = function()
            if timer then
                timer:stop()
                timer:close()
            end
        end,
    })
end

return M
