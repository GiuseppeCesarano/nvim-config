"Plugins
call plug#begin()
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'honza/vim-snippets'
    Plug 'rakr/vim-one'
    Plug 'itchyny/lightline.vim'
    Plug 'rhysd/vim-clang-format'
    Plug 'conweller/findr.vim'
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
call plug#end()

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
set signcolumn=yes

"Shortcuts
map <silent> <C-e> :CocCommand explorer<CR> 
map <silent> <C-i> :call Format()<CR>
map <silent> <C-p> :Findr<CR>
map <silent> <C-x> :CocList marketplace <CR>
inoremap <silent><expr> <C-space> coc#refresh()

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

"C/C++ Hightlight 
let g:lsp_cxx_hl_use_text_props = 1
hi default link LspCxxHlSymParameter Type

"Change if theme changes
hi default LspCxxHlGroupMemberVariable ctermfg=Red guifg=#E06C75 cterm=none gui=none
hi default LspCxxHlSymVariable ctermfg=Red guifg=#E06C75 cterm=none gui=none
hi default LspCxxHlGroupNamespace guifg=none cterm=none  gui=none  

"Formatters Settings
let g:prettier#config#tab_width = 4
let g:clang_format#style_options = { "BasedOnStyle" : "WebKit"}

"Custom Functions
fu! Format()
    if exists(":PrettierAsync") 
	:PrettierAsync<CR>
	echom "Code formatted using Prettier"
    else
	:ClangFormat
	echom "Code formatted using Clang-format"
    endif
endfunction
