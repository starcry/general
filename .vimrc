filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
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
set autoindent
set paste
set background=dark
