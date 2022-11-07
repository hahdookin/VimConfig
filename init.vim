"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTHOR:  Christopher Pane (hahdookin) 
" FILE:    init.vim
" DESC:    vimrc for all non-plugin configurations
" EMAIL:   ChrisPaneCS@gmail.com
" WEBSITE: https://chrispane.dev
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set plugin directories
set packpath-=~/.vim
set packpath+=~/.vim/common
if has("nvim")
    set packpath+=~/.vim/nvim
else
    set packpath+=~/.vim/vim
endif

let mapleader = ","

let g:colorscheme = "default"

filetype plugin indent on
syntax enable

if has('termguicolors')
    set termguicolors
endif

set history=500

" Set to auto read when a file is changed from the outside
set autoread
" au FocusGained,BufEnter * checktime

" 7 lines to the cursor
set so=7

let $LANG='en'
set langmenu=en
set encoding=utf8
set ffs=unix,dos,mac
set clipboard+=unnamedplus

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set hidden
set switchbuf=
set stal=2

" set splitbelow
set splitright

set wildmenu
set wildignore=*.o,*~,*.pyc
set wildignorecase
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set wildmode=full
set wildoptions=pum

set number relativenumber
set cursorline
set equalalways
set ruler

set cmdheight=1
set showcmd

set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch
set magic

set lazyredraw

" Matching delims
set showmatch
set mat=2

" Disable error notifs
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set belloff=all

" Disable backup
set nobackup
set nowb
set noswapfile

" Tabs
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Indent
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Always show the status line
set laststatus=2

" Change cursor shape depending on insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Get termguicolors to work on st
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

exec "colorscheme " . g:colorscheme
" set bg=light
set bg=dark

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map 0 ^
map ' `
nnoremap Y y$

nnoremap <silent><leader>no :nohlsearch<CR>

" Tab through buffers
nnoremap <silent><TAB> :bnext<CR>
nnoremap <silent><S-TAB> :bprev<CR>

" Spell checking
map <leader>ss :setlocal spell!<cr>

" Close windows
noremap <leader>cl :close<CR>

" Window navigation
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"  Window navigation in terminal
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l

" Escape in terminal mode
tnoremap <leader><Esc> <c-\><c-n>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

" autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimgrep
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! BuffersList()
    return range(1, bufnr('$'))
            \ ->filter('buflisted(v:val)')
            \ ->map('bufname(v:val)')
endfun
noremap <leader>v :vim 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't close window, when deleting a buffer
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction
command! Bclose call <SID>BufcloseCloseIt()
nnoremap <leader>bd :Bclose<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :e! ~/.vim/init.vim<CR>
map <leader>m :source %<CR>
autocmd! BufWritePost ~/.vim/init.vim,~/.vim/plugins.vim,~/.vim/nvim.lua,~/.vim/vim9.vim source ~/.vimrc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Persistent undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim/temp/undo
    set undofile
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Quickfix stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent>]Q :clast<CR>
map <silent>[Q :cfirst<CR>
map <silent>]q :cnext<CR>
map <silent>[q :cprev<CR>
map <silent><leader>cc :call ToggleQuickFix()<CR>
map <silent><leader>ll :call ToggleLocList()<CR>

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
        lclose
    endif
endfunction
function! ToggleLocList()
    try
        if empty(filter(getwininfo(), 'v:val.quickfix'))
            lopen
        else
            cclose
            lclose
        endif
    catch /E776/
        return
    endtry
endfunction

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => netrw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_starting_directory = getcwd()
let g:netrw_last_directory = g:vim_starting_directory
let g:netrw_proportion = 0.18    " Amount of screen occupied by netrw :Lexplore

" netrw settings
let g:netrw_banner = 0 " Hide banner
let g:netrw_altv = 1 "
let g:netrw_altfile = 1
let g:netrw_winsize = -1 * floor(&columns * g:netrw_proportion) " Abs value = number of columns explorer takes up
let g:netrw_keepdir = 0
let g:netrw_browse_split = 4 " Split into previous window
let g:netrw_localcpdircmd = 'cp -r' " Recursively copy dir
let g:netrw_liststyle = 3
augroup Netrw
    autocmd!
    autocmd FileType netrw call s:NetrwMapping()
augroup END

nnoremap gx :exec '!"$BROWSER" ' . shellescape("<cWORD>")<CR>

" Netrw mappings
function! s:NetrwMapping()
    if hasmapto('<Plug>NetrwRefresh')
        unmap <buffer> <C-l>
    endif
    " Ranger-like navigation
    nmap <buffer> h -^
    nmap <buffer> l <CR>

    nmap <buffer> . gh
    nmap <buffer> P <C-w>z

    nmap <buffer> <C-r> :e .<CR>

    nmap <buffer> <C-g> :Bclose<CR>:exec "e " . g:vim_starting_directory<CR>
endfunction

function s:ToggleLex()
    " call s:CleanUselessBuffers()
    " Clean useless buffers
    for buf in getbufinfo()
        if buf.name == "" && buf.changed == 0 && buf.loaded == 1
            :execute ':bdelete ' . buf.bufnr
        endif
    endfor

    " let g:netrw_last_directory = getcwd()

    " we iterate through the buffers again because some netrw buffers are
    " skipped after we browsed to a different location and hence the name
    " of the window changed (no longer '')
    let flag = 0
    for buf in getbufinfo()
        if (get(buf.variables, "current_syntax", "") == "netrwlist") && buf.changed == 0 && buf.loaded == 1
            :execute  ':bwipeout ' . buf.bufnr
            let flag = 1
        endif
    endfor

    if !flag
        let g:netrw_winsize = -1 * floor(&columns * g:netrw_proportion)
        :Lexplore
        " exec "e " . g:netrw_last_directory
    endif
endfunction
nnoremap <silent> <leader>tf :call <SID>ToggleLex()<CR>

hi! link netrwMarkFile Todo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuzzy-finding fallback if no plugins available
fun! MyFuzFunc(A, L, P)
    let l:results = split(system("find . -type f -not -path '*/\\.git/*'"), "\n")
    return matchfuzzy(l:results, a:A)
endfun

set wcm=<C-Z>
cnoremap <C-TAB> <C-Z><C-P>
command! -nargs=1 -complete=customlist,MyFuzFunc Find edit <args>
nnoremap <C-p> :Find ./<C-Z><C-P>
" set path+=**

" Toggle a terminal window at the bottom of the screen
" let g:toggled = #{init: 0, bufnr: 0, winnr: 0, open: 0}
" function ToggleTerm()
"     if !g:toggled.init
"         " Start a terminal buffer and remember its buffer number
"         if has("nvim")
"             bot split term://bash
"         else
"             bot terminal ++kill=hup
"         endif
"         let g:toggled.bufnr = uniq(map(filter(getwininfo(), 'v:val.terminal'), 'v:val.bufnr'))[0]
"         let g:toggled.init = 1
"     endif
"     if g:toggled.open
"         call win_execute(g:toggled.winnr, 'close')
"         let g:toggled.open = 0
"     else
"         exec "bot sbuffer " . g:toggled.bufnr
"         exec "resize " . float2nr(&lines * g:terminal_proportion)
"         setlocal winfixheight
"         setlocal nonumber norelativenumber
"         let g:toggled.winnr = win_getid()
"         let g:toggled.open = 1
"     endif
" endfunction

" " Toggle term maps
" nnoremap <silent> <leader>tt :call ToggleTerm()<CR>
" tnoremap <silent> <leader>tt <C-\><C-n>:call ToggleTerm()<CR>
