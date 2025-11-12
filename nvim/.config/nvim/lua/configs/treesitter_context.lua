require("treesitter-context").setup({
    enable = true, -- Activates the plugin. Shows context at the top of the window
    multiwindow = true, -- Enables context display across all windows, not just the focused one
    max_lines = 7, -- Limit to 7 context lines per window
    min_window_height = 15, -- Only show context in windows with at least 15 lines of height (prevents context in small splits)
    line_numbers = true, -- Displays line numbers in the context lines, matching your main buffer's line numbering
    multiline_threshold = 5, -- Truncate multiline nodes that exceed 5 lines. Prevents huge blocks from dominating the context window
    trim_scope = "outer", -- When context gets too long, removes outer (top-level) scopes first rather than inner ones
    mode = "cursor", -- Shows context based on cursor position. Alternative is "topline" which bases it on the top visible line
    separator = "─", -- Horizontal line separator between context and main content for visual clarity
    zindex = 20, -- Sets the stacking order for the floating window. Higher numbers appear on top of lower ones
    on_attach = nil, -- No custom function to run when attaching to a buffer. Could use this to add buffer-specific behavior
})
