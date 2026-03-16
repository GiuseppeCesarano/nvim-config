-- ============================================================
-- Bootstrap lazy.nvim
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- Plugin Spec
-- ============================================================
require("lazy").setup({
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato",
                custom_highlights = function(colors)
                    return {
                        Comment = { fg = colors.overlay2, style = { "italic" } },
                    }
                end,
                integrations = {
                    nvimtree = true,
                    telescope = { enabled = true },
                    lualine = {
                        all = function(colors)
                            return {
                                normal = {
                                    a = { bg = colors.lavender, fg = colors.mantle, gui = "italic,bold" },
                                    b = { fg = colors.lavender },
                                },
                                insert = {
                                    a = { bg = colors.green, fg = colors.base, gui = "bold" },
                                },
                            }
                        end,
                    },
                },
            })
            vim.cmd.colorscheme("catppuccin-macchiato")
        end,
    },

    -- Completion Engine & Snippets
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Load friendly-snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), 
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin-nvim",
                    icons_enabled = true,
                    globalstatus = true,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    { "nvim-tree/nvim-web-devicons", lazy = true },
    "tpope/vim-sleuth",
    "tpope/vim-commentary",
    "tpope/vim-fugitive",

    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            local function on_attach(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set("n", "l", api.node.open.edit,             opts("Open file or folder"))
                vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close parent or folder"))
                vim.keymap.set("n", "<C-e>", api.tree.toggle,            opts("Toggle tree"))
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
                renderer = { highlight_opened_files = "all" },
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = require("telescope.themes").get_ivy({ winblend = 10, border = false })
            })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({ indent = { char = "|" }, scope = { enabled = true } })
        end,
    },

    { "folke/zen-mode.nvim" },
})

-- ============================================================
-- LSP Config
-- ============================================================
-- We use cmp_nvim_lsp to tell the server we support completion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("zls", {
    cmd          = { "zls" },
    filetypes    = { "zig", "zir" },
    root_markers = { "build.zig", "build.zig.zon", ".git" },
    capabilities = capabilities,
    settings = { zls = { enable_build_on_save = true } },
})
vim.lsp.enable("zls")

vim.lsp.config("clangd", {
    cmd          = { "clangd" },
    filetypes    = { "c", "cpp", "objc", "objcpp", "cuda" },
    capabilities = capabilities,
    root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },
})
vim.lsp.enable("clangd")

-- ============================================================
-- Options
-- ============================================================
local opt = vim.opt
opt.number         = true
opt.relativenumber = true
opt.hlsearch       = true
opt.smartcase      = true
opt.ignorecase     = true
opt.incsearch      = true
opt.autoindent     = true
opt.shiftwidth     = 4
opt.softtabstop    = 4
opt.termguicolors  = true
opt.completeopt    = { "menu", "menuone", "noselect" }

-- ============================================================
-- Keymaps
-- ============================================================
local map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<C-e>",      "<cmd>NvimTreeToggle<cr>")
map("n", "<C-i>",      "<cmd>lua vim.lsp.buf.format()<cr>")
map("n", "<C-p>",      "<cmd>Telescope find_files<cr>")
map("n", "gd",         "<cmd>lua vim.lsp.buf.definition()<cr>")
map("n", "<leader>e",  "<cmd>lua vim.diagnostic.open_float()<cr>")
