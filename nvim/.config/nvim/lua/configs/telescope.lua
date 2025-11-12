-- TODO:
-- is there a way to customize telescope UI?
-- some previews are left-right oriented, while some are top-bottom
-- standardize all telescope UI to use top-bottom orientation (top: preview, bottom: search)
-- -- actually, figure out which UI to standardize to?
-- note, this includes plugins that hook into telescope (e.g. harpoon, dressing, etc.)
-- note, telescope.lua needs to interact well with NVChad's default telescope setup
-- -- get claude to help if confused
-- TODO:
-- why are some searches strict while others are fuzzy? (e.g. <leader>fz vs <leader>fw)
-- -- when should search be fuzzy vs strict? should we always have 2 versions of every search type?
-- -- think about this for all telescope integrations in nvim (e.g. harpoon, dressing, etc.)
-- TODO:
-- why do searches automatically exclude git-ignored files? how to toggle on/off?
-- BUG:
-- telescope pickers wrap around when reaching end. disable wrapping
-- telescope pickers also don't have cursor centering & buffering. fix this

local M = {}

function M.setup()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
        defaults = {
            prompt_prefix = "  ",
            selection_caret = " ",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.6,
                    results_width = 0.45,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.9,
                height = 0.85,
                preview_cutoff = 120,
            },
            sorting_strategy = "ascending",
            scroll_strategy = "cycle",
            winblend = 0,
            mappings = {
                i = {
                    ["<esc"] = actions.close,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,
                    ["<C-n>"] = actions.move_selection_next,
                },
            },
        },
        pickers = {
            find_files = {
                theme = "dropdown",
                previewer = true,
            },
            harpoon = {
                theme = "dropdown",
                previewer = true,
            },
        },
        buffers = {
            theme = "dropdown",
            previewer = true,
        },
    })

    -- Safe load extensions if installed
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "harpoon")
end

M.keys = {
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "telescope find buffers" },
    { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "telescope live grep" },
}

return M
