-- Enable true color
vim.opt.termguicolors = true

-- Fix runtime path for lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/lazy/lazy.nvim")

-- Plugin manager setup
require("lazy").setup({
    -- Theme
    { "ellisonleao/gruvbox.nvim", priority = 1000 },

    -- File explorer
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

    -- Treesitter for syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- Telescope for fuzzy finding
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- GitHub Copilot
    { "github/copilot.vim" },

    -- Completion & Snippets
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },

    -- Clipboard
    { "swaits/universal-clipboard.nvim", opts = {} },

    -- LSP config with mason and cmp integration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local servers = { "lua_ls", "pyright", "ts_ls", "bashls", "texlab" }

            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities,
                })
            end
        end,
    },

    -- LaTeX support
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_syntax_enabled = 1
            vim.g.vimtex_syntax_math_enabled = 1
            vim.g.vimtex_syntax_math_strict = 1
            vim.g.vimtex_syntax_math_delimiter = 1
            vim.g.vimtex_syntax_math_delimiter_strict = 1
            vim.g.vimtex_view_automatic = 1
        end,
    }
})

-- Gruvbox theme setup
require("gruvbox").setup({
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,
    contrast = "hard",
    palette_overrides = {},
    overrides = {
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        EndOfBuffer = { fg = "#3c3836" },
    },
    dim_inactive = false,
    transparent_mode = true,
})
vim.cmd.colorscheme("gruvbox")

-- Basic UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars:append({ eob = "~" })

-- nvim-tree config
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Auto-open tree if Neovim starts with folder
local function open_nvim_tree_on_startup(data)
    local directory = vim.fn.isdirectory(data.file) == 1
    if directory then
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
    end
end
vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = open_nvim_tree_on_startup
})

-- Treesitter config
require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = { "lua", "python", "javascript", "html", "css", "bash" },
})

-- Telescope keybindings
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })

-- Completion config
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
})
