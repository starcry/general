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
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'preservim/nerdtree'
"Plug 'roxma/nvim-completion-manager'
Plugin 'ncm2/ncm2'
Plugin 'roxma/nvim-yarp'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'PProvost/vim-ps1'
Plugin 'vim-terraform'
call vundle#end()
autocmd VimEnter * NERDTree
set autoindent
"!alias ocp="xclip -i -sel c"
set expandtab

if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif

set backspace=indent,eol,start

autocmd BufWritePre * :%s/\s\+$//e

#! this is a test
let $BASH_ENV = "~/.vim_bash_env"
