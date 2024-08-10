call plug#begin() 
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'itchyny/lightline.vim'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
call plug#end()

lua require('config')

"Auto cmd
augroup custom_filetype
    autocmd!
    autocmd BufRead,BufNewFile *.glsl,*.vert,*.tesc,*.tese,*.frag,*.geom,*.comp set filetype=glsl
    autocmd BufRead,BufNewFile *.wgsl set filetype=wgsl
augroup END

"Row Numbers Settings
set number	
set showmatch	
set visualbell

"Search Settings
set hlsearch
set smartcase
set ignorecase
set incsearch

"Spacesing Settings
set autoindent	
set shiftwidth=4
set smartindent	
set smarttab	
set softtabstop=4	
set cindent

"Other Settings
set cmdheight=2
set updatetime=300
set shortmess+=c
set ruler	
set hidden
set nofoldenable    
set undolevels=1000	
set backspace=indent,eol,start	 
set signcolumn=number

"Shortcuts
nmap <silent> <C-e> :NvimTreeToggle explorer<cr> 
nmap <silent> <C-i> <cmd>lua vim.lsp.buf.format()<cr>
nmap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nmap <silent> gD <cmd>lua vim.lsp.buf.declaration()<cr>
nmap <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
nmap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nmap <silent> gs <cmd>lua vim.lsp.buf.signature_help()<cr>
nmap <leader>rn <cmd>lua vim.lsp.buf.rename()<cr>
nmap <leader>qf  <cmd>lua vim.lsp.buf.code_action()<cr>

"Enable Ture Color in vim 
set termguicolors

"Enable Theme
syntax on
colorscheme catppuccin-macchiato
let g:lightline = {'colorscheme': 'catppuccin'}

"Comments in italic
hi Comment cterm=italic gui=italic

"Custom Functions
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
	execute 'h '.expand('<cword>')
    else
	call CocAction('doHover')
    endif
endfunction

"Disable orrendus SQL complete
let g:omni_sql_no_default_maps = 1
