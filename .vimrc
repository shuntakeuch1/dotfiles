""dein Scripts-----------------------------
"if &compatible
"    set nocompatible               " Be iMproved
"endif
"
"" Required:
"set runtimepath^=/Users/takeuchishun/.vim/bundle/repos/github.com/Shougo/dein.vim
"
"" Required:
"call dein#begin(expand('/Users/takeuchishun/.vim/bundle'))
"
"" Let dein manage dein
"" Required:
"call dein#add('Shougo/dein.vim')
"call dein#add('Shougo/unite.vim')
""call dein#add('Shougo/neossh.vim')
""call dein#add('Shougo/vimfiler')
""call dein#add('Shougo/vimproc')
"call dein#add('tomasr/molokai')
"
"" Add or remove your plugins here:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')
"
"" You can specify revision/branch/tag.
"call dein#add('Shougo/vimshell', { 'rev': '3787e5' })
""call dein#add('scrooloose/nerdtree')
"
"" Required:
"call dein#end()
"
"" Required:
"filetype plugin indent on
"
"" If you want to install not installed plugins on startup.
"if dein#check_install()
"    call dein#install()
"endif
"
""    "End dein Scripts-------------------------

noremap <C-j> <esc>
noremap! <C-j> <esc>
"nnoremap <silent><C-e> :NERDTreeToggle<CR>
set number
set title
set ambiwidth=double
set tabstop=4
set expandtab
set shiftwidth=4
set smartindent
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set nrformats-=octal
set hidden
set history=50
set virtualedit=block
set whichwrap=b,s,[,],<,>
set backspace=indent,eol,start
set wildmenu
let g:netrw_bufsettings = 'noma nomod number nobl nowrap ro'
" netrwは常にtree view
let g:netrw_liststyle = 3
" CVSと.で始まるファイルは表示しない
let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'
" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
let g:netrw_alto = 1
let g:vimfiler_as_default_explorer=1
"colorscheme molokai
"autocmd VimEnter * execute 'NERDTree'
