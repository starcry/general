filetype plugin indent on                                                                                                                                                                                          
set tabstop=4
set shiftwidth=4
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
