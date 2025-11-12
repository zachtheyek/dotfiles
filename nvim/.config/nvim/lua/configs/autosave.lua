local M = {}

function M.setup()
    require("auto-save").setup({
        enabled = true, -- Start autosave when plugin is loaded
        -- Define auto-save triggers
        trigger_events = {
            immediate_save = { "BufLeave", "FocusLost" }, -- Save immediately: when switching to a different file/buffer, or when focus is switched off of Nvim
            defer_save = { "InsertLeave", "TextChanged" }, -- Delayed save: when Insert mode is exited, or when text is changed in Normal mode
            cancel_deferred_save = { "InsertEnter" }, -- Cancel save: if Insert mode is re-entered before delay ends
        },
        condition = nil,
        write_all_buffers = true, -- Write all buffers on save
        debounce_delay = 1000, -- Delay 1s before save
    })
end

return M
