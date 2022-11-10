"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTHOR:  Christopher Pane (hahdookin) 
" FILE:    plugins.vim
" DESC:    vimrc for plugin configurations
" EMAIL:   ChrisPaneCS@gmail.com
" WEBSITE: https://chrispane.dev
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General
let g:colorscheme = "spaceduck"
try
    exec "colorscheme " . g:colorscheme
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    let g:colorscheme = "default"
endtry

""""""""""""""""""""""""""""""
" => Buftabline
""""""""""""""""""""""""""""""
let g:buftabline_indicators = 1 " Show 'modified' in buftab

""""""""""""""""""""""""""""""
" => Shell section
""""""""""""""""""""""""""""""
au FileType gitcommit call setpos('.', [0, 1, 1, 0])

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => miniterm.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:terminal_proportion = 0.28 " Amount of screen occupied by toggled terminal

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lightline settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': g:colorscheme,
      \ 'active': {
      \   'left': [ ['mode'], ['filename', 'modified'], ['fugitive', 'readonly' ] ],
      \   'right': [ [ 'lineinfo'] , ['percent'], ['filetype', 'paste'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}',
      \   'paste': '%{&lines}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FZF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF buffers
nnoremap <leader>ff :Buffers<CR>
nnoremap <leader>fl :Lines<CR>

" FZF Files depending on whether or not in a git repo
function FuzzyFiles()
    GFiles
    " Error 128 occurs when not in Git repo path
    if v:shell_error == 128
        Files
    endif
endfunction
nnoremap <leader>fg :call FuzzyFiles()<CR>

" FZF in cur (d)ir
nnoremap <leader>fd :FZF<CR>
" FZF (i)n
nnoremap <leader>fi :FZF


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Rainbow Parenthesis
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 0
noremap <leader>rr :RainbowToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => COC.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=300
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Tab will complete current best match if the PUM is visible, else it will
" just enter a \t
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<TAB>"
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use  and  to navigate diagnostics
" Use  to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

fun! DoCocActionOrNormal(map, feature, action)
    if CocHasProvider(a:feature)
        call CocActionAsync(a:action)
    else
        call feedkeys(a:map, 'n')
    endif
endfun

" GoTo code navigation.
nmap <silent> gd :call DoCocActionOrNormal("gd", "definition", "jumpDefinition")<CR>
nmap <silent> gy :call DoCocActionOrNormal("gy", "typeDefinition", "jumpTypeDefinition")<CR>
nmap <silent> gi :call DoCocActionOrNormal("gi", "implementation", "jumpImplementation")<CR>
nmap <silent> gr :call DoCocActionOrNormal("gr", "reference", "jumpReferences")<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call DoCocActionOrNormal("K", "hover", "doHover")<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example:  for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
"nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add  command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add  command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add  command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Startscreen
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:start_screen_mru_count = 7 " Number of MRU files to show on start screen
" Path patterns to ignore when showing MRU on start screen
let g:start_screen_mru_ignore = [
    \ "^/usr/share/",
    \ "vimwiki"
    \]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimwiki
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Date stuff
let g:date_format = "%a %b %d %l:%M%p %Y %Z"
fun! InsertDate()
    return systemlist('date --date="' . input("Date: ") . '" +"' . g:date_format . '"')[0]
endfun
noremap <leader>ad  :exec "normal! a<" . InsertDate() . ">"<CR>

augroup VimwikiDates
    au!
    au BufReadPost,BufWritePost *.wiki call DateHighlighting()
augroup END

let g:date_positions = []

fun! DateHighlighting()
    let g:date_positions = []
    let save_view = winsaveview()
    let save_pos = getpos('.')
    let bn = bufnr()
    normal gg0
    hi DatePAST ctermfg=DarkGrey
    hi DateLTDAY ctermfg=DarkRed
    hi DateLT2DAY ctermfg=Red
    hi DateLTWEEK ctermfg=Yellow
    hi DateLTMONTH ctermfg=Green
    hi DateGTMONTH ctermfg=Blue
    if empty(prop_type_get('DateLTDAY', {'bufnr': bn}))
        call prop_type_add('DatePAST', { 'bufnr': bn, 'highlight': 'DatePAST', 'combine': 0 })
        call prop_type_add('DateLTDAY', { 'bufnr': bn, 'highlight': 'DateLTDAY', 'combine': 0 })
        call prop_type_add('DateLT2DAY', { 'bufnr': bn, 'highlight': 'DateLT2DAY', 'combine': 0 })
        call prop_type_add('DateLTWEEK', { 'bufnr': bn, 'highlight': 'DateLTWEEK', 'combine': 0 })
        call prop_type_add('DateLTMONTH', { 'bufnr': bn, 'highlight': 'DateLTMONTH', 'combine': 0 })
        call prop_type_add('DateGTMONTH', { 'bufnr': bn, 'highlight': 'DateGTMONTH', 'combine': 0 })
    endif
    while search('<.\{-}>', 'W') != 0
        let [_, lnum, col, _] = getpos('.')
        normal f>
        let endpos = col('.')
        let date = getline('.')[col : endpos - 2]
        let now = localtime()
        let then = strptime(g:date_format, date)
        if !then
            " call prop_add(lnum, col, {'bufnr': bn, 'length': endpos - col + 1, 'type': 'DateGTMONTH' })
            continue
        endif


        let diff = then - now

        let bn = bufnr()
        call add(g:date_positions, {'lnum': lnum, 'col': col, 'diff': diff, 'bufnr': bn, 'text': getbufline(bn, lnum)[0]})

        let one_day = 86400
        let two_day = one_day * 2
        let one_week = one_day * 7
        let one_month = one_day * 31
        let one_year = one_day * 365

        let type = ""
        if diff < 0
            let type = 'DatePAST'
        elseif diff < one_day
            let type = 'DateLTDAY'
        elseif diff < two_day
            let type = 'DateLT2DAY'
        elseif diff < one_week
            let type = 'DateLTWEEK'
        elseif diff < one_month
            let type = 'DateLTMONTH'
        else
            let type = 'DateGTMONTH'
        endif

        call prop_add(lnum, col, {'bufnr': bn, 'length': endpos - col + 1, 'type': type })
    endwhile
    call setpos('.', save_pos)
    call winrestview(save_view)
    " Sort positions [ [row, col, diff], ... ] by the difference a.k.a. Time
    " between now and the date.
    eval g:date_positions->sort({i1,i2 -> i1['diff'] - i2['diff']})
    call setqflist(g:date_positions, 'r')
endfun

let g:vimwiki_conceal_pre = 1

fun! InsertStandup()
    let text = ["== Work ==",
                \ "=== Done ===", "",
                \ "=== Will Do ===", "",
                \ "=== Blockers ===", ""]
    call append(line('.') - 1, text)
endfun
command! InsertStandup :call InsertStandup()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => minifuzzy.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Builds a Unix find command that ignores directories present in the
" "ignore_directories" list
let g:ignore_directories = [ 'node_modules', '.git' ]
fun! BuildFindCommand()
    let cmd_exprs = g:ignore_directories
                    \ ->mapnew('"-type d -name " . v:val . " -prune"')
    call add(cmd_exprs, '-type f -print')
    return 'find . ' . cmd_exprs->join(' -o ')
endfun

nnoremap <space> :MinifuzzyBuffers<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gruvbox
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gruvbox_bold = 0
let g:gruvbox_italic = 0
let g:gruvbox_contrast_dark = "medium"

