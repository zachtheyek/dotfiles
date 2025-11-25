return {
    -- Package management (LSPs, formatters, linters, etc.)
    -- Uses NVChad defaults
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- Auto-install LSP servers (specified by mason_lspconfig.lua)
    {
        "williamboman/mason-lspconfig.nvim",
        opts = require("configs.mason_lspconfig"),
    },

    -- LSP client configs (specified by lspconfig.lua)
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("configs.lspconfig")
        end,
    },

    -- Preview LSP definitions & references inside floating window (specified by goto_preview.lua)
    {
        "rmagatti/goto-preview",
        dependencies = { "rmagatti/logger.nvim" },
        event = "BufEnter",
        config = function()
            require("configs.goto_preview").setup()
        end,
    },

    -- Syntax parsing engine (specified by treesitter.lua)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- Auto-update installed parsers
        opts = require("configs.treesitter"),
    },

    -- Show code context at top of window (specified by treesitter_context.lua)
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("configs.treesitter_context")
        end,
    },

    -- Render markdown files (specified by render_markdown.lua)
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" },
        opts = require("configs.render_markdown"),
    },

    -- TODO: come back to this later
    -- Code linter (specified by lint.lua)
    -- {
    --     "mfussenegger/nvim-lint",
    --     event = { "BufReadPre", "BufNewFile" },  -- Is this correct? Match conform.lua?
    --     config = function()
    --         require("configs.lint")
    --     end,
    -- },

    -- Code formatter (specified by conform.lua)
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = require("configs.conform"),
    },

    -- Code autocompletion (specified by blink.lua)
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = require("configs.blink"),
    },

    -- Code diagnostics (specified by trouble.lua)
    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
        keys = require("configs.trouble").keys,
    },

    -- Task navigation (specified by todo.lua)
    {
        "folke/todo-comments.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = require("configs.todo"),
    },

    -- Git integration for buffers (specified by gitsigns.lua)
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        -- TODO: come back to this later
        -- opts = require("configs.gitsigns"),
    },

    -- Enable telescope fuzzy finder (specified by telescope.lua)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                -- Makes telescope faster
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                enabled = vim.fn.executable("make") == 1, -- If not available, fallback to "base"
            },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("configs.telescope").setup()
        end,
        keys = require("configs.telescope").keys,
    },

    -- File navigation enhancements (specified by harpoon.lua)
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("configs.harpoon")
        end,
    },

    -- Floating terminal (specified by fterm.lua)
    {
        "numToStr/FTerm.nvim",
        config = function()
            require("configs.fterm").setup()
        end,
        keys = require("configs.fterm").keys,
    },

    -- Enhanced UI for messages, cmdline, and popupmenu (specified by noice.lua)
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                -- Notification manager (specified by notify.lua)
                "rcarriga/nvim-notify",
                config = function()
                    require("configs.notify").setup()
                end,
                keys = require("configs.notify").keys,
            },
        },
        opts = require("configs.noice"),
    },

    -- TODO: come back to this later
    -- Enhanced UI for LSP progress & notifications (specified by fidget.lua)
    -- {
    --     "j-hui/fidget.nvim",
    --     event = "LspAttach",
    --     opts = require("configs.fidget"),
    -- },

    -- View URLs in buffer with telescope (specified by urlview.lua)
    {
        "axieax/urlview.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("configs.urlview").setup()
        end,
        keys = require("configs.urlview").keys,
    },

    -- Tmux navigation integration (specified in mappings.lua & options.lua)
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },

    -- Auto-save sessions (specified by vimobsession.lua)
    {
        "tpope/vim-obsession",
        lazy = false,
        config = function()
            require("configs.vimobsession").setup()
        end,
    },

    -- NOTE: disabled because autosave too invasive to workflow
    -- Auto-save buffer (specified by autosave.lua)
    -- {
    --     "okuuva/auto-save.nvim",
    --     event = { "InsertLeave", "TextChanged" }, -- Load when Insert mode is exited, or when text is changed in Normal mode
    --     config = function()
    --         require("configs.autosave").setup()
    --     end,
    -- },

    -- File & image previews on filetree (specified by nvimtree.lua & image.lua)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            {
                "b0o/nvim-tree-preview.lua",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    -- {
                    --     "3rd/image.nvim",
                    --     build = ":Lazy load image.nvim",
                    --     opts = function()
                    --         return require("configs.image")
                    --     end,
                    -- },
                },
            },
        },
        opts = function()
            return require("configs.nvimtree").setup()
        end,
    },

    -- Improved base statuslines (specified by lualine.lua)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        -- TODO: come back to this later
        -- config = function()
        --     require("configs.lualine")
        -- end,
    },

    -- Start screen dashboard (specified by alpha.lua)
    {
        "goolord/alpha-nvim",
        lazy = false,
        priority = 999,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("configs.alpha")
        end,
    },

    -- TODO: come back to this later
    -- Extensible scrollbar (specified by scrollbar.lua)
    -- {
    --     "petertriho/nvim-scrollbar",
    --     event = "BufEnter",
    --     dependencies = { "lewis6991/gitsigns.nvim" },
    --     config = function()
    --         require("configs.scrollbar").setup()
    --     end,
    -- },

    -- Keymap hints (specified by whichkey.lua)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = require("configs.whichkey"),
    },

    -- UI improvements to vim.ui hooks (specified by dressing.lua)
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = require("configs.dressing"),
    },

    -- Enables "focus mode" (specified by zenmode.lua)
    {
        "folke/zen-mode.nvim",
        lazy = false,
        opts = require("configs.zenmode"),
        cmd = "Zen",
    },

    -- Dims inactive code portions (trigger hooked to zen mode)
    {
        "folke/twilight.nvim",
        lazy = false,
        opts = {},
    },

    -- Comfortable line number display using digits 1-4 (specified by comfy_linenumbers.lua)
    {
        "mluders/comfy-line-numbers.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- Use synchronous loading with high priority to avoid race conditions on startup
            require("comfy-line-numbers").setup(require("configs.comfy_linenumbers"))
        end,
    },

    -- Disable relative line numbers in insert mode
    {
        "sitiom/nvim-numbertoggle",
        lazy = false,
    },

    -- Color code highlighter (specified by colorizer.lua)
    {
        "norcalli/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            require("configs.colorizer").setup()
        end,
    },

    -- Indent guides (specified by indent_blankline.lua)
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = require("configs.indent_blankline"),
    },

    -- Auto-close pairs (specified by autopairs.lua)
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("configs.autopairs").setup()
        end,
    },

    -- TODO: remap key bindings to be more sensible. add surround.lua config file (https://github.com/tpope/vim-surround)
    -- Keybindings for modifying parentheses/quotes/etc.
    {
        "tpope/vim-surround",
        lazy = false,
    },

    -- TODO: remap key bindings to be more sensible. add surround.lua config file (https://github.com/numToStr/Comment.nvim)
    -- TODO: test vs tpope's vim-commentary (https://github.com/tpope/vim-commentary)
    -- Comment stuff out
    {
        "numToStr/Comment.nvim",
        lazy = false,
    },

    -- Invert text objects (specified by toggler.lua)
    {
        "nguyenvukhang/nvim-toggler",
        lazy = false,
        config = function()
            require("configs.toggler").setup()
        end,
    },

    -- TODO: come back to this later
    -- Draw ASCII diagrams (specified by venn.lua)
    -- {
    --     "jbyuki/venn.nvim",
    --     lazy = false,
    --     config = function()
    --         require("configs.venn").setup()
    --     end,
    -- },

    -- NOTE: nice-to-have, not enabled by default
    -- Practicing Vim movements
    -- {
    --     "ThePrimeagen/vim-be-good",
    --     cmd = "VimBeGood",
    -- },

    -- NOTE: nice-to-have, not enabled by default
    -- Practicing typing
    -- {
    --     "nvzone/typr",
    --     dependencies = "nvzone/volt",
    --     opts = {},
    --     cmd = { "Typr", "TyprStats" },
    -- },

    -- TODO: come back to this later
    -- Embed Neovim inside browser (specified by firenvim.lua)
    -- {
    --     "glacambre/firenvim",
    --     lazy = false,
    --     build = ":call firenvim#install(0)",
    --     config = function()
    --         require("configs.firenvim").setup()
    --     end,
    -- },
}
