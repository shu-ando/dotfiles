set nocompatible
set t_Co=256

" **Import Plugins** {{{1
" Plugins ----------------------------------------
filetype plugin indent off

if has('vim_starting')
	set rtp+=~/.vim/bundle/neobundle.vim/
end
call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-fold'
NeoBundle 'kana/vim-textobj-entire'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'kannokanno/previm'
NeoBundle 'godlygeek/tabular'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'fholgado/minibufexpl.vim'
NeoBundle 'fatih/vim-go'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'othree/html5.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'w0ng/vim-hybrid'

filetype plugin indent on
"}}}

colorscheme molokai

" **Plugin Settings** {{{1
" EMMET ------------------------------------------
let g:user_emmet_mode='a'
let g:user_emmet_leader_key = '<C-r>'
let g:user_emmet_settings = {
			\  'lang' : 'ja',
			\  'indentation' : '  '
			\}

let g:vimfiler_as_default_explorer = 1
" let g:ycm_key_list_previous_completion=['<Up>']
" let g:UltiSnipsExpandTrigger="<C-j>"
" let g:UltiSnipsListSnippets="<C-Tab>"
"
" let g:UltiSnipsJumpForwardTrigger="<Tab>"
" let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
" let g:UltiSnipsEditSplit="vertical"

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

let g:mline_bufhist_queue = []

" 表示数
let g:mline_bufhist_limit = 4

" 除外パターン
let g:mline_bufhist_exclution_pat = '^$\|.jax$\|vimfiler:\|\[unite\]\|tagbar'

" 表示非表示切り替え
let g:mline_bufhist_enable = 1
command! Btoggle :let g:mline_bufhist_enable = g:mline_bufhist_enable ? 0 : 1 | :redrawstatus!


function! Mline_bufhist()
    if &filetype =~? 'unite\|vimfiler\|tagbar' || !&modifiable || len(g:mline_bufhist_queue) == 0 || g:mline_bufhist_enable == 0
        return ''
    endif

    let current_buf_nr = bufnr('%')
    let buf_names_str = ''
    let last = g:mline_bufhist_queue[-1]
    for i in g:mline_bufhist_queue
        let t = fnamemodify(i, ':t')
        let n = bufnr(t)

        if n != current_buf_nr
            let buf_names_str .= printf('[%d]:%s' . (i == last ? '' : ' | '), n, t)
        endif
    endfor

    return buf_names_str
endfunction


function! s:update_recent_buflist(file)
    if a:file =~? g:mline_bufhist_exclution_pat
        " exclusion from queue
        return
    endif

    if len(g:mline_bufhist_queue) == 0
        " init
        for i in range(min( [ bufnr('$'), g:mline_bufhist_limit + 1 ] ))
            let t = bufname(i)
            if bufexists(i) && t !~? g:mline_bufhist_exclution_pat
                call add(g:mline_bufhist_queue, fnamemodify(t, ':p'))
            endif
        endfor
    endif

    " update exist buffer
    let idx = index(g:mline_bufhist_queue, a:file)
    if 0 <= idx
        call remove(g:mline_bufhist_queue, idx)
    endif

    call insert(g:mline_bufhist_queue, a:file)

    if g:mline_bufhist_limit + 1 < len(g:mline_bufhist_queue)
        call remove(g:mline_bufhist_queue, -1)
    endif
endfunction


let g:memolist_memo_suffix = "md"
let g:memolist_qfixgrep = 1

" Neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'




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
" }}}

" **BASIC SETTINGS** {{{1

" File -------------------------------------------
set autoread
set hidden  " 編集中でも他ファイル開ける
"set switchbuf=useopen " 既にあるバッファを開く
set nowritebackup
set noswapfile
set nobackup
set clipboard=unnamedplus,autoselect
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
"set showtabline=2
set laststatus=2

" Charset, Line editing --------------------------
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,sjis,cp932
set fileformat=unix
set ffs=unix,dos
" }}}

augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END



let mapleader=','

inoremap jj <Esc>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
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

nmap R <Plug>(operator-replace)

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
au FileType go nnoremap <Leader>gi  <Plug>(go-import)
au FileType go nnoremap<Leader>gd <Plug>(go-doc)
au FileType go nnoremap<Leader>gf <Plug>(go-fmt)
au FileType go nnoremap<Leader>gr <Plug>(go-run)
au FileType go nnoremap<Leader>gb  <Plug>(go-build)
au FileType go nnoremap <Leader>gt  <Plug>(go-test)
au FileType go nnoremap gd <Plug>(go-def)
au FileType go nnoremap <Leader>ds <Plug>(go-def-split)
au FileType go nnoremap <Leader>dv <Plug>(go-def-vertical)
au FileType go nnoremap <Leader>dt <Plug>(go-def-tab)

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

" 補完
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


nnoremap <Leader>mn :MemoNew<CR>
nnoremap <Leader>ml :MemoList<CR>
nnoremap <Leader>mg :MemoGrep<CR>

nnoremap <Leader>W :silent ! start google-chrome %<CR>


au BufNewFile,BufRead *.html set ts=2 sw=2 sts=2

" プリント
" set printfont="Migu 1M:h12"
" set printoptions=number:y
" set printoptions=syntax:a
 set printoptions=left:10mm,right:10mm,top:10mm,bottom:10mm
let g:html_use_css = 1
let g:use_xhtml = 1

set foldmethod=marker
