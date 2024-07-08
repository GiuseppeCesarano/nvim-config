"Plugins
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
call plug#end()

let g:coc_global_extensions = [
	    \'coc-highlight',
	    \'coc-explorer',
	    \'coc-git',
	    \'coc-clangd',
	    \'coc-zig',
	    \'coc-cmake',
	    \'coc-pairs',
	    \'coc-pyright',
	    \'coc-snippets',
	    \'coc-marketplace'
	    \]

"Auto cmd
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']
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
map <silent> <C-e> :CocCommand explorer<CR> 
map <silent> <C-i> <Plug>(coc-format)
map <silent> <C-x> :CocList marketplace <CR>
map <silent> <C-b> :CocList tasks<CR>
inoremap <silent><expr> <C-space> coc#refresh()
nnoremap <silent> K :call <SID>show_documentation()<CR>
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"


nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf  <Plug>(coc-fix-current)

"Enable Ture Color in vim 
if (empty($TMUX))
    if (has("nvim"))
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    if (has("termguicolors"))
	set termguicolors
    endif
endif

"Settings For LightLine
let g:lightline = {
	    \'colorscheme': 'onedark',
	    \ 'active': {
	    \   'left': [ [ 'mode', 'paste' ],
	    \             ['readonly', 'filename', 'modified' ] ]
	    \ }
	    \}

"Enable Theme
syntax on
colorscheme onedark
let g:onedark_terminal_italics = 1
let g:onedark_hide_endofbuffe = 1

"Change if theme changes
let g:coc_default_semantic_highlight_groups = 1
hi default CocSemTypeParameter guifg=#E06C75
hi default CocSemTypeVariable guifg=#E06C75
hi default COcSemTypeTypeParameter guifg=#E5C07b 

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
