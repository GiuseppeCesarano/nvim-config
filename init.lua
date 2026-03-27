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
		    blink_indent = true,
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
	'saghen/blink.cmp',
	dependencies = 'rafamadriz/friendly-snippets',
	opts = {
	    fuzzy = {
		implementation = "lua", 
		prebuilt_binaries = {
		    download = false, 
		},
	    },

	    keymap = {
		preset = 'none',
		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<C-e>']     = { 'hide' },
		['<CR>']      = { 'accept', 'fallback' },
		['<Tab>']     = { 'select_next', 'snippet_forward', 'fallback' },
		['<S-Tab>']   = { 'select_prev', 'snippet_backward', 'fallback' },
		['<Up>']      = { 'select_prev', 'fallback' },
		['<Down>']    = { 'select_next', 'fallback' },
		['<C-p>']     = { 'select_prev', 'fallback' },
		['<C-n>']     = { 'select_next', 'fallback' },
		['<C-b>']     = { 'scroll_documentation_up', 'fallback' },
		['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
	    },

	    appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = 'mono'
	    },

	    completion = {
		menu = { 
		    border = "none",
		    draw = {
			columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
		    }
		},
		documentation = { 
		    auto_show = true, 
		    window = { border = "none" } 
		},
		ghost_text = { enabled = true }
	    },

	    sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	    },

	    signature = { enabled = true, window = { border = "none" } }
	}, 
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
        'saghen/blink.indent',
        opts = {
            static = {
                char = "|", 
            },
	    scope = {
                char = "|", 
	    },
        },
    },

    { "folke/zen-mode.nvim" },
})

-- ============================================================
-- LSP Config
-- ============================================================

local capabilities = require('blink.cmp').get_lsp_capabilities()

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
-- Diagnostic Customization
-- ============================================================

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌵 ", Info = "󰋽 " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN]  = "󰀪 ",
            [vim.diagnostic.severity.HINT]  = "󰌵 ",
            [vim.diagnostic.severity.INFO]  = "󰋽 ",
        },
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        border = "none", 
        source = "always",
        header = "", 
        prefix = "",
    },
})

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
opt.signcolumn     = "number"

-- ============================================================
-- Modern Keymaps
-- ============================================================

local telescope = require("telescope.builtin");

vim.keymap.set("n", "<C-e>", function() require("nvim-tree.api").tree.toggle() end, { silent = true, desc = "Toggle NvimTree" })
vim.keymap.set("n", "<C-i>", function() vim.lsp.buf.format({ async = true }) end, { silent = true, desc = "Format Buffer" })
vim.keymap.set("n", "<C-p>", function() telescope.find_files() end, { silent = true, desc = "Telescope Files" })
vim.keymap.set("n", "<C-S-p>", function() telescope.builtin() end, { silent = true, desc = "Telescope Pickers" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true, desc = "LSP Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { silent = true, desc = "LSP Declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { silent = true, desc = "LSP Implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { silent = true, desc = "LSP References" })
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { silent = true, desc = "LSP Signature Help" })

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = false, desc = "LSP Rename" })
vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, { silent = false, desc = "LSP Code Action" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true, desc = "Open Diagnostic Float" })

vim.keymap.set("n", "[", vim.diagnostic.goto_prev, { silent = true, desc = "Prev Diagnostic" })
vim.keymap.set("n", "]", vim.diagnostic.goto_next, { silent = true, desc = "Next Diagnostic" })
