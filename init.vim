"Plugins
call plug#begin()
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'rakr/vim-one'
    Plug 'itchyny/lightline.vim'
    Plug 'honza/vim-snippets'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'skywind3000/asynctasks.vim'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-commentary'
    Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'
call plug#end()

let g:coc_global_extensions = [
	    \'coc-markdownlint',
	    \'coc-highlight',
	    \'coc-explorer',
	    \'coc-git',
	    \'coc-clangd',
	    \'coc-cmake',
	    \'coc-pairs',
	    \'coc-pyright',
	    \'coc-snippets',
	    \'coc-marketplace',
	    \'coc-tasks'
	    \]

"Auto cmd
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']

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
	    \'colorscheme': 'one',
	    \'separator': { 'left': "\ue0b0", 'right': "\ue0b2"},
	    \'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3"},
	    \ 'active': {
	    \   'left': [ [ 'mode', 'paste' ],
	    \             ['readonly', 'filename', 'modified' ] ]
	    \ }
	    \}

"Enable Theme
syntax on
colorscheme one
set background=dark

"Change if theme changes
hi default CocSemParameter guifg=#E06c75
hi default CocSemVariable guifg=#E06c75
hi default CocSemMethod guifg=#61AFEF
hi default CocSemFunction guifg=#61AFEF
hi default CocSemDependent guifg=#61AFEF
hi default CocSemNamespace guifg=#E5C07b 
hi default CocSemTypeParameter guifg=#E5C07b 
hi default CocSemClass guifg=#E5C07b 
hi default CocSemEnumMember guifg=#56B6C2 
hi default CocSemType guifg=#C678DD

"Comments in italic
hi Comment cterm=italic gui=italic

" tasks config
let g:asyncrun_open = 6

"Custom Functions
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'python','norg'},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
require('neorg').setup {
  load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/Documents/norg/work",
                    notes = "~/Documents/norg/notes",
                    gtd = "~/Documents/norg/gtd",
                },
		index = "inbox.norg"
            }
        },
    ["core.gtd.base"] = {
	config = {
	    workspace = "gtd",
	}},
        ["core.norg.concealer"] = {},
	["core.export"] = {},
	["core.export.markdown"] = {}
    }
}
EOF
