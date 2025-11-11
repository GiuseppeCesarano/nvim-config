vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.lsp.config('*', {
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	  root_markers = { '.git' },
})
vim.lsp.enable('zls')
vim.lsp.enable('clangd')


local function nvim_tree_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set('n', "<C-e>", api.tree.toggle, opts("Toggle tree"))
	vim.keymap.set('n', 'l', api.node.open.edit, opts("Open file or folder"))
	vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts("Close parent or folder"))
end

require("nvim-tree").setup({
	on_attach = nvim_tree_attach
})

require("catppuccin").setup({
    integrations = {
        cmp = true,
        nvimtree = true,
	telescope = {
	    enabled = true,
	}
    }
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	window = {
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}
	)
})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostics float" })
