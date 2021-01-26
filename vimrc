filetype plugin indent on
set tabstop=2
set shiftwidth=2
set cursorline
set cursorcolumn
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
set statusline+=%F%=%l/%c
set hlsearch
set laststatus=2
syntax on
set colorcolumn=80
set paste
set background=dark
call plug#begin()
Plug 'preservim/nerdtree'
"Plug 'roxma/nvim-completion-manager'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'PProvost/vim-ps1'
call plug#end()
autocmd VimEnter * NERDTree
set autoindent
"!alias ocp="xclip -i -sel c"
set expandtab

if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif
