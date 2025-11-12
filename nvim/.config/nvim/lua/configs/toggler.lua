return {
    setup = function()
        require("nvim-toggler").setup({
            -- Define custom word pairs to toggle
            inverses = {
                ["True"] = "False",
                ["true"] = "false",
                ["yes"] = "no",
                ["on"] = "off",
                ["left"] = "right",
                ["up"] = "down",
                ["enable"] = "disable",
                ["!="] = "==",
                [">"] = "<",
                [">="] = "<=",
                ["+"] = "-",
                ["1"] = "0",
            },
            remove_default_keybinds = true, -- Disable default <leader>i keybinding
            remove_default_inverses = true, -- Disable default toggle pairs
        })

        -- Set custom keybinding to <leader>~
        vim.keymap.set({ "n", "v" }, "<leader>~", require("nvim-toggler").toggle, { desc = "Toggle word" })
    end,
}
