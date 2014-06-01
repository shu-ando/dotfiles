set nocompatible
set t_Co=256

" IMPORT PLUGINS {{{1
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

" PLUGIN SETTINGS {{{1
" LIGHTLINE {{{2
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

let g:mline_bufhist_limit = 4

let g:mline_bufhist_exclution_pat = '^$\|.jax$\|vimfiler:\|\[unite\]\|tagbar'

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
"}}}

" EMMET {{{2
let g:user_emmet_mode='a'
let g:user_emmet_leader_key = '<c-y>'
let g:user_emmet_settings = {
			\  'lang' : 'ja',
			\  'indentation' : '  '
			\}
"}}}

" VIMFILER {{{2
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_force_overwrite_statusline = 0
"}}}

" UNITE {{{2
call unite#custom_default_action('source/bookmark/directory', 'vimfiler')
let g:unite_force_overwrite_statusline = 0
"}}}

" MEMOLIST {{{2
let g:memolist_memo_suffix = "md"
let g:memolist_qfixgrep = 1
"}}}

" NEOCOMPLETE {{{2
let g:acp_enableatstartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"}}}

" VIMSHELL {{{2
let g:vimshell_force_overwrite_statusline = 0
""}}}

" GUNDO {{{2
let g:gundo_width = 40
let g:gundo_right = 1
"}}}

" TAGBAR {{{2
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
""}}}
"
" YCM {{{2
" let g:ycm_key_list_previous_completion=['<up>']
" let g:ultisnipsexpandtrigger="<c-j>"
" let g:ultisnipslistsnippets="<c-tab>"
"}}}

" ULTISNIPS {{{2
" let g:UltiSnipsJumpForwardTrigger="<Tab>"
" let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
" let g:UltiSnipsEditSplit="vertical"
"}}}
" }}}

" BASIC SETTINGS {{{1
set autoread
set hidden
set switchbuf=useopen
set nowritebackup
set noswapfile
set nobackup
set clipboard=unnamedplus,autoselect

set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

set backspace=indent,eol,start
set formatoptions=lmoq
set whichwrap=b,s,h,l,>,<,[,]
set matchpairs& matchpairs+=<:>

set wildmenu
set wildmode=list:full

set virtualedit+=block
set wrapscan
set ignorecase
set smartcase
set hlsearch
"set incsearch

function! ZenkakuSpace()
	highlight ZenkakuSpace cterm=underline ctermfg=darkgray gui=underline
endfunction
if has('syntax')
	augroup ZenkakuSpace
		autocmd!
		autocmd ColorScheme       * call ZenkakuSpace()
		autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
	augroup END
	call ZenkakuSpace()
endif
set display=uhex
set cursorline
set showmatch
set matchtime=3
set showcmd
set showmode
set number
set wrap
if exists('&ambiwidth')
	set ambiwidth=double
endif
set list
"◂, ↲,
set listchars=tab:»-,trail:\ ,eol:«,extends:»,precedes:«,nbsp:%
set notitle
" set scrolloff=5
set textwidth=0
set colorcolumn=80

"set showtabline=2
set laststatus=2

set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,sjis,cp932
set fileformat=unix
set ffs=unix,dos

autocmd BufWritePre * :%s/\s\+$//ge
autocmd BufNewFile,BufRead *.html set ts=2 sw=2 sts=2 et

augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

" set printfont="migu 1m:h12"
" set printoptions=number:y
" set printoptions=syntax:a
set printoptions=left:10mm,right:10mm,top:10mm,bottom:10mm
let g:html_use_css = 1
let g:use_xhtml = 1

set foldmethod=marker
colorscheme molokai
syntax on
" }}}

" KEY MAPPING {{{1
" BASIC MAPPING {{{2
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
"}}}
" nmap R <Plug>(operator-replace)

" Toggle {{{2
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>
nnoremap <silent> [toggle]n :setl number!<CR>:setl number?<CR>
nnoremap <silent> [toggle]p :setl paste!<CR>:setl paste?<CR>
"}}}

" Go file setting {{{2
au FileType go nmap <Leader>gi  <Plug>(go-import)
au FileType go nmap<Leader>gd <Plug>(go-doc)
au FileType go nmap<Leader>gf <Plug>(go-fmt)
au FileType go nmap<Leader>gr <Plug>(go-run)
au FileType go nmap<Leader>gb  <Plug>(go-build)
au FileType go nmap <Leader>gt  <Plug>(go-test)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
"}}}

" Emacs like setting {{{2
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
inoremap <C-l> <C-o>zz
inoremap <C-k> <C-o>D
"inoremap <C-u> <C-o>d1
""inoremap <C-x>u <C-o>u
"inoremap <C-y> <C-o>P
"inoremap <C-Space> <C-n>
inoremap <C-x>s <Esc>:w<CR>a
inoremap <C-x>c <Esc>:wq<CR>
"}}}

" CommandLine Emacs like movement {{{2
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-e> <End>
cnoremap <C-a> <Home>
"}}}

" Splitter {{{2
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
"}}}

" NeoSnippet {{{2
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

if has('conceal')
  set conceallevel=2 concealcursor=i
endif
"}}}

" Plugin Leader {{{2
nnoremap <silent> <Leader>gu :GundoToggle<CR>
nnoremap <silent> <leader>l  :TagbarToggle<CR>

nnoremap <silent> <Leader>fe :VimFilerBufferDir -quit<CR>
nnoremap <silent> <Leader>fi :VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

nnoremap <silent> <Leader>mn :MemoNew<CR>
nnoremap <silent> <Leader>ml :MemoList<CR>
nnoremap <silent> <Leader>mg :MemoGrep<CR>

nmap <C-l> <Plug>(openbrowser-smart-search)
"}}}

"}}}

