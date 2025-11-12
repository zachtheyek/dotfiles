require("nvchad.mappings")

local map = vim.keymap.set

-- Insert blank line above/below cursor & stay in normal mode
map("n", "<Enter>", "o<ESC>")
map("n", "<M-Enter>", "O<ESC>")

-- Move highlighted lines
map("v", "<S-j>", ":m '>+1<CR>gv-gv")
map("v", "<S-k>", ":m '<-2<CR>gv-gv")

-- Append proceeding lines & keep cursor position constant
map("n", "<S-j>", "mzJ`z")

-- Scroll & center cursor on page
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center cursor on page while cycling through search results
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Select all in file & place cursor at top/bottom of file
map("n", "<C-a>", "GVgg")
map("n", "<C-A>", "ggVG")

-- Find & replace all instances of current cursor word in file
map("n", "<leader>R", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace current cursor word" })

-- Paste/delete without yanking
map({ "n", "x" }, "x", '"_x')
map("x", "<leader>d", [["_d]], { desc = "Delete without yanking" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Make current file executable
map("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })

-- Open URL under cursor in browser
map("n", "gx", function()
    local url = vim.fn.expand("<cfile>")
    if url:match("^https?://") then
        vim.fn.jobstart({ "open", url }, { detach = true })
    else
        vim.notify("No URL under cursor", vim.log.levels.WARN)
    end
end, { desc = "Open URL under cursor" })

-- Override NVChad's window navigation with vim-tmux-navigator bindings
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux navigate left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux navigate down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux navigate up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux navigate right" })

-- Delete NVChad's <leader>h mapping (conflicts with harpoon)
-- NVChad default: <leader>h -> new horizontal term
vim.keymap.del("n", "<leader>h")

-- Delete NVChad's <leader>th mapping (conflicts with fterm)
-- NVChad's default: <leader>th -> toggle telescope themes
vim.keymap.del("n", "<leader>th")
