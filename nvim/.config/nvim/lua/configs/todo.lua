-- BUG: sometimes todos aren't highlighted on buffers that were closed on startup
-- TODO:
-- currently only using for highlighting
-- learn advanced features (how to jump between marks? can unify with lsp warnings & git marks?)
-- integrate with other tools (e.g. telescope picker + dressings UI)
-- https://github.com/folke/todo-comments.nvim?tab=readme-ov-file#-usage
-- tweak configs & bindings to preference
-- small thought: desired behavior is keyword searches are case-sensitive
-- is this currently implemented?
-- idea: implement highlighting in file previews (nvim tree, fzf)
-- Note: how do i actually use this? how to pull up menu to see all todos? how to jump between todos in current file? how to search todos across code base?

local M = {
    highlight = {
        multiline = false, -- disable multiline todo comments
        -- only highlight commented keywords, nothing else
        -- note main accepted keywords: FIX, TODO, HACK, WARN, PERF, NOTE, TEST
        before = "",
        keyword = "wide_bg",
        after = "",
        comments_only = true,
    },

    search = {
        -- BUG: doesn't catch keywords without ":"

        -- Default match includes KEYWORD + ":"
        -- Setting to no ":" leads to more FPs, but needed to catch (begin) & (end) blocks
        pattern = [[\b(KEYWORDS)\b]],
    },
}

-- Default key bindings for navigating todo's
vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next todo" })

vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo" })

return M
