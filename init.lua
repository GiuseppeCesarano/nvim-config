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
                        Comment = { fg = colors.overlay2, style = { "italic" } }
                    }
                end,
                integrations = {
                    cmp = true,
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
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set("n", "l", api.node.open.edit,           opts("Open file or folder"))
                vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close parent or folder"))
                vim.keymap.set("n", "<C-e>", api.tree.toggle,          opts("Toggle tree"))
            end

            require("nvim-tree").setup({
                on_attach = on_attach,
                renderer = {
                    highlight_opened_files = "all",
                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("zls", {
                capabilities = capabilities,
                root_markers = { ".git", "build.zig" },
                settings = {
                    zls = { enable_build_on_save = true },
                },
            })
            vim.lsp.enable("zls")

            vim.lsp.config("clangd", {
                capabilities = capabilities,
            })
            vim.lsp.enable("clangd")
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                }),
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = require("telescope.themes").get_ivy({
                    winblend = 10,
                    border = false,
                })
            })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "|" },
                scope = { enabled = true },
            })
        end,
    },

    { "folke/zen-mode.nvim" },
})

-- ============================================================
-- Options
-- ============================================================
local opt = vim.opt

-- Row numbers
opt.number         = true
opt.relativenumber = true
opt.showmatch      = true
opt.visualbell     = true

-- Search
opt.hlsearch   = true
opt.smartcase  = true
opt.ignorecase = true
opt.incsearch  = true

-- Indentation
opt.autoindent  = true
opt.shiftwidth  = 4
opt.smartindent = true
opt.smarttab    = true
opt.softtabstop = 4
opt.cindent     = true

-- Misc
opt.cmdheight   = 2
opt.updatetime  = 300
opt.shortmess:append("c")
opt.ruler       = true
opt.hidden      = true
opt.foldenable  = false
opt.undolevels  = 1000
opt.backspace   = { "indent", "eol", "start" }
opt.signcolumn  = "number"

-- True colour
opt.termguicolors = true

-- Disable terrible SQL completion maps
vim.g.omni_sql_no_default_maps = 1

-- ============================================================
-- Filetype associations
-- ============================================================
vim.api.nvim_create_augroup("custom_filetype", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group   = "custom_filetype",
    pattern = { "*.glsl", "*.vert", "*.tesc", "*.tese", "*.frag", "*.geom", "*.comp" },
    command = "set filetype=glsl",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group   = "custom_filetype",
    pattern = { "*.wgsl" },
    command = "set filetype=wgsl",
})

-- ============================================================
-- Keymaps
-- ============================================================
local map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<C-e>",   "<cmd>NvimTreeToggle<cr>")
map("n", "<C-i>",   "<cmd>lua vim.lsp.buf.format()<cr>")
map("n", "<C-p>",   "<cmd>Telescope find_files<cr>")
map("n", "<C-S-p>", "<cmd>Telescope builtin<cr>")
map("n", "gd",      "<cmd>lua vim.lsp.buf.definition()<cr>")
map("n", "gD",      "<cmd>lua vim.lsp.buf.declaration()<cr>")
map("n", "gi",      "<cmd>lua vim.lsp.buf.implementation()<cr>")
map("n", "gr",      "<cmd>lua vim.lsp.buf.references()<cr>")
map("n", "gs",      "<cmd>lua vim.lsp.buf.signature_help()<cr>")
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>",       { silent = false })
map("n", "<leader>qf", "<cmd>lua vim.lsp.buf.code_action()<cr>",  { silent = false })
map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>")
