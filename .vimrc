" replacing tabs with spaces
set expandtab
" when pressing a tab, a number of spaces will be added equal to the shiftwidth
set smarttab
set shiftwidth=4
" number of spaces in a tab
set tabstop=4
" number of spaces in a tab when deleting
set softtabstop=4
" set the list of displayed invisible characters
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:∙

" hotkeys to show invisible characters
noremap <F5> :set list!
inoremap <F5> <C-o>:set list!
cnoremap <F5> <C-c>:set list!

highlight extrawhitespace ctermbg=red guibg=red

noremap <F6> :match ExtraWhitespace /\s\+$/
inoremap <F6> <C-o> :match ExtraWhitespace /\s\+$/
cnoremap <F6> <C-c> :match ExtraWhitespace /\s\+$/
