set nocompatible

" Plugins ----------------------------------------
filetype plugin indent off

if has('vim_starting')
	set rtp+=~/.vim/bundle/neobundle.vim/
	set rtp+=$GOROOT/misc/vim/
	set rtp+=$GOPATH/src/github.com/nsf/gocode/vim/
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
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
"NeoBundle 'Shougo/neocomplcache'
"NeoBundle 'Shougo/neocomplete'
"NeoBundle 'ujihisa/unite-locate'
NeoBundle 'tpope/vim-surround'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'tomtom/tcomment_vim'
"NeoBundle 'taglist.vim'
"NeoBundle 'ref.vim'
"NeoBundle 'fugitive.vim'
"NeoBundle 'thinca/vim-quickrun'
"NeoBundle 'thinca/vim-localrc'
"NeoBundle 'dbext.vim'
"NeoBundle 'rails.vim'
"NeoBundle 'Gist.vim'
"NeoBundle 'motemen/hatena-vim'
"NeoBundle 'mattn/webapi-vim'
"NeoBundle 'mattn/unite-advent_calendar'
"NeoBundle 'open-browser.vim'
"NeoBundle 'ctrlp.vim'
"NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'tomasr/molokai'

filetype plugin indent on

colorscheme molokai

" EMMET ------------------------------------------
let g:user_emmet_leader_key = '<C-r>'
let g:user_emmet_settings = {
			\  'lang' : 'ja',
			\  'indentation' : '  '
			\}

let g:vimfiler_as_default_explorer = 1

"autocmd FileType go setlocal omnifunc=syntaxcomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

" File -------------------------------------------
set autoread
"set hidden  " 編集中でも他ファイル開ける
set noswapfile nobackup " スワップファイル, バックアップを取らない
autocmd BufWritePre * :%s/\s\+$//ge " 保存時に行末の空白を除去する
autocmd FileType go autocmd BufWritePre <buffer> Fmt
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
" set clipboard=unnamed, autoselect " バッファにクリップボードを利用する

" Complement Command -----------------------------
set wildmenu
set wildmode=list:full

" Search -----------------------------------------
set virtualedit+=block " 矩形選択で行末を超えてブロック選択できる
set wrapscan " 最後まで検索したら元に戻る
set ignorecase " 大文字小文字無視
set smartcase " 大文字で始めたら大文字小文字無視しない
set hlsearch " 検索文字をハイライト
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
set display=uhex " 印字不可能文字を16進数で表示
set cursorline " カーソル行をハイライト
set showmatch " 括弧の対応をハイライト
set showcmd " 入力中のコマンドを表示
set showmode " 現在のモードを表示
set number " 行番号表示
set wrap " 画面幅で折り返す
set list " 不可視文字表示
set listchars=tab:»-,trail:\ ,eol:↲,extends:»,precedes:«,nbsp:% " 不可視文字の表示方法
set notitle " タイトル書き換えない
" set scrolloff=5 " 行送り

" StatusLine -------------------------------------
hi User1 ctermfg=253  ctermbg=63
hi User2 ctermfg=253  ctermbg=62
hi User3 ctermfg=253  ctermbg=61
hi User4 ctermfg=253  ctermbg=69
hi User5 ctermfg=253  ctermbg=68
hi User6 ctermfg=253  ctermbg=67
hi User7 ctermfg=253  ctermbg=66   gui=bold
hi User8 ctermfg=253  ctermbg=65
hi User9 ctermfg=253  ctermbg=64
hi User0 ctermfg=253  ctermbg=31
set laststatus=2
set statusline=
set statusline+=%1*\[%n]                                  " buffernr
set statusline+=%2*\ %<%f\                                " file+path
set statusline+=%3*\ %y\                                  " filetype
set statusline+=%4*\ %{''.(&fenc!=''?&fenc:&enc).''}      " encoding
set statusline+=%5*\ %{(&bomb?\",bom\":\"\")}\            " encoding2
set statusline+=%6*\ %{&ff}\                              " fileformat (dos/unix..)
set statusline+=%7*\ %{&spelllang}\                       " spellanguage & highlight on?
set statusline+=%8*\ %=\ row:%l/%L\ (%3p%%)\              " rownumber/total (%)
set statusline+=%9*\ col:%03c\                            " colnr
set statusline+=%0*\ \ %m%r%w\ %P\ \                      " modified? readonly? top/bot.


" Charset, Line editing --------------------------
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,sjis,cp932
set fileformat=unix
set ffs=unix,dos


" Insert mode like emacs
" Use <tab> to indent
inoremap <tab> <C-o>==<End>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-e> <End>
inoremap <C-a> <Home>
inoremap <C-h> <Left><C-o>x
inoremap <C-d> <Del>
" カーソル位置の行をウィンドウの中央に来るようにスルロール
inoremap <C-l> <C-o>zz
" カーソル以降の文字を削除
inoremap <C-k> <C-o>D
" カーソル以前の文字を削除
inoremap <C-u> <C-o>d0
" アンドゥ
inoremap <C-x>u <C-o>u
" 貼りつけ
inoremap <C-y> <C-o>P
" カーソルから単語末尾まで削除
inoremap <F1>d <C-o>dw
" ファイルの先頭に移動
inoremap <F1>< <Esc>ggI
" ファイルの末尾に移動
inoremap <F1>> <Esc>GA
" 下にスクロール
inoremap <C-v> <C-o><C-f>
" 上にスクロール
inoremap <F1>v <C-o><C-b>
" Ctrl-Space で補完
" Windowsは <Nul>でなく <C-Space> とする
inoremap <C-Space> <C-n>
" 保存
inoremap <C-x>s <Esc>:w<CR>a
inoremap <C-x>c <Esc>:wq<CR>
" 選択
inoremap <C-2> <Esc><C-v>
inoremap <C-3> <Esc><C-V>


cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-e> <End>
cnoremap <C-a> <Home>

" ディレクトリ
let g:netrw_liststyle=3

" When insert change statusline.
let g:hi_insert = 'hi StatusLine gui=None guifg=Black guibg=Yellow cterm=None ctermfg=Black ctermbg=Yellow'
if has('syntax')
	augroup InsertHook
		autocmd!
		autocmd InsertEnter * call s:StatusLine('Enter')
		autocmd InsertLeave * call s:StatusLine('Leave')
	augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
	if a:mode == 'Enter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_insert
	else
		highlight clear StatusLine
		silent exec s:slhlcmd
	endif
endfunction

function! s:GetHighlight(hi)
	redir => hl
	exec 'highlight '.a:hi
	redir END
	let hl = substitute(hl, '[\r\n]', '', 'g')
	let hl = substitute(hl, 'xxx', '', '')
	return hl
endfunction
highlight Normal ctermbg=none

" プリント
" set printfont="Migu 1M:h12"
" set printoptions=number:y
" set printoptions=syntax:a
 set printoptions=left:10mm,right:10mm,top:10mm,bottom:10mm


