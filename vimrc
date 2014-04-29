set nocompatible
set t_Co=256

" Plugins ----------------------------------------
filetype plugin indent off

if has('vim_starting')
	set rtp+=~/.vim/bundle/neobundle.vim/
end
call neobundle#rc(expand('~/.vim/bundle/'))

"NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }


"NeoBundle 'Shougo/neocomplete'
"NeoBundle 'dbext.vim'
"NeoBundle 'mattn/unite-advent_calendar'
"NeoBundle 'mattn/webapi-vim'
"NeoBundle 'ref.vim'
"NeoBundle 'thinca/vim-localrc'
"NeoBundle 'ujihisa/unite-locate'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'fatih/vim-go'
NeoBundle 'godlygeek/tabular'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tomasr/molokai'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tyru/open-browser.vim'

filetype plugin indent on

colorscheme molokai

" EMMET ------------------------------------------
let g:user_emmet_leader_key = '<C-r>'
let g:user_emmet_settings = {
			\  'lang' : 'ja',
			\  'indentation' : '  '
			\}

let g:vimfiler_as_default_explorer = 1
let g:ycm_key_list_previous_completion=['<Up>']
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsListSnippets="<C-Tab>"

let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsEditSplit="vertical"

call unite#custom_default_action('source/bookmark/directory', 'vimfiler')

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? '⭠ '._ : ''
  endif
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

let g:gundo_width = 40
"let g:gundo_preview_height = 40
let g:gundo_right = 1


let g:tagbar_indent = 1

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
	\ }

" File -------------------------------------------
set autoread
set hidden  " 編集中でも他ファイル開ける
set switchbuf=useopen " 既にあるバッファを開く
set nowritebackup noswapfile nobackup " スワップファイル, バックアップを取らない
autocmd BufWritePre * :%s/\s\+$//ge " 保存時に行末の空白を除去する
syntax on " シンタックスカラー ON

" Indent -----------------------------------------
set tabstop=4  " Tab文字を画面上で何文字分に展開するか
set shiftwidth=4 " cindentやautoindent時に挿入されるインデントの幅
set softtabstop=4 " Tabキー押下時に挿入される空白の量、0の場合はtabstopと同じ
set autoindent " 自動インデント, スマートインデント

" Assist imputting -------------------------------
set backspace=indent,eol,start " バックスペースで特殊記号も削除可能
set formatoptions=lmoq " 整形オプション, マルチバイト系を追加
set whichwrap=b,s,h,l,>,<,[,] " カーソルを行頭、行末で止まらないようにする
set matchpairs& matchpairs+=<:>

" Complement Command -----------------------------
set wildmenu
set wildmode=list:full

" Search -----------------------------------------
set virtualedit+=block " 矩形選択で行末を超えてブロック選択できる
set wrapscan           " 最後まで検索したら元に戻る
set ignorecase         " 大文字小文字無視
set smartcase          " 大文字で始めたら大文字小文字無視しない
set hlsearch           " 検索文字をハイライト
"set incsearch " インクリメンタルサーチ

" View -------------------------------------------
" 全角スペースの表示
function! ZenkakuSpace()
	highlight ZenkakuSpace cterm=underline ctermfg=darkgray gui=underline
endfunction
if has('syntax')
	augroup ZenkakuSpace
		autocmd!
		" ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
		autocmd ColorScheme       * call ZenkakuSpace()
		" 全角スペースのハイライト指定
		autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
	augroup END
	call ZenkakuSpace()
endif
set display=uhex         " 印字不可能文字を16進数で表示
set cursorline           " カーソル行をハイライト
set showmatch            " 括弧の対応をハイライト
set matchtime=3          " 対応括弧のハイライト表示3秒
set showcmd              " 入力中のコマンドを表示
set showmode             " 現在のモードを表示
set number               " 行番号表示
set wrap                 " 画面幅で折り返す
if exists('&ambiwidth')
	set ambiwidth=double
endif
set list                 " 不可視文字表示
"◂, ↲,
set listchars=tab:»-,trail:\ ,eol:«,extends:»,precedes:«,nbsp:% " 不可視文字の表示方法
set notitle " タイトル書き換えない
" set scrolloff=5 " 行送り
set textwidth=0
set colorcolumn=80

" StatusLine -------------------------------------
set laststatus=2

" Charset, Line editing --------------------------
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,sjis,cp932
set fileformat=unix
set ffs=unix,dos

let mapleader=','

inoremap jj <Esc>
nmap <silent> <Esc><Esc> :nohlsearch<CR>
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap j gj
nnoremap k gk
nnoremap / /\v

" T + ? で各種設定をトグル
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>
nnoremap <silent> [toggle]n :setl number!<CR>:setl number?<CR>

nnoremap <silent> <Leader>gu :GundoToggle<CR>
nnoremap <silent> <leader>l  :TagbarToggle<CR>

" vimfiler
" 現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :VimFilerBufferDir -quit<CR>
" IDE風に開く
nnoremap <silent> <Leader>fi :VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>
"Go-vim Mapping
au FileType go nmap <Leader>gi  <Plug>(go-import)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gf <Plug>(go-fmt)
au FileType go nmap <Leader>gr <Plug>(go-run)
au FileType go nmap <Leader>gb  <Plug>(go-build)
au FileType go nmap <Leader>gt  <Plug>(go-test)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

" Insert mode like emacs
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-e> <End>
inoremap <C-a> <Home>
inoremap <C-h> <Left><C-o>x
" inoremap { {}<LEFT>
" inoremap ( ()<LEFT>
" inoremap [ []<LEFT>
" inoremap " ""<LEFT>

"inoremap <C-d> <Del>
" カーソル位置の行をウィンドウの中央に来るようにスクロール
inoremap <C-l> <C-o>zz
" カーソル以降の文字を削除
inoremap <C-k> <C-o>D
" カーソル以前の文字を削除
"inoremap <C-u> <C-o>d1
" アンドゥ
""inoremap <C-x>u <C-o>u
" 貼りつけ
inoremap <C-y> <C-o>P
" Ctrl-Space で補完
" Windowsは <Nul>でなく <C-Space> とする
"inoremap <C-Space> <C-n>
" 保存
inoremap <C-x>s <Esc>:w<CR>a
inoremap <C-x>c <Esc>:wq<CR>

cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-e> <End>
cnoremap <C-a> <Home>

nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

"
" プリント
" set printfont="Migu 1M:h12"
" set printoptions=number:y
" set printoptions=syntax:a
 set printoptions=left:10mm,right:10mm,top:10mm,bottom:10mm
let g:html_use_css = 1
let g:use_xhtml = 1


