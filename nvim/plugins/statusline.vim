" Variables
" {{{
" This variables indicates whether to show time
" on statusline or not
let g:time = -1
"}}}

" Colors
" {{{
" Set StatusLine colors
hi StatusLine gui=bold guibg=silver guifg=black
" Color groups for statusline
hi User1 gui=bold guibg=grey60 guifg=darkred
hi User2 gui=bold guibg=silver guifg=red
hi User3 gui=bold guibg=silver guifg=#5f0000
hi User4 gui=bold guibg=silver guifg=#875f00
hi User5 gui=bold guibg=silver guifg=#005f00
hi User6 gui=bold guibg=silver guifg=green

" }}}

" Commands and mappings
" {{{
" Display time in statusline
command! -nargs=1 Time call <SID>Time("<args>") | call ActiveStatus()  " NB there is also the command redrawstatus that redraws the statusline, but it doesn't really work in this case
" Toggle time in statusline
command! ToggleTime let g:time *= -1 | call ActiveStatus()
" Toggle time
nnoremap <silent> <F3> :ToggleTime<CR>

"}}}

" Autocommands
" {{{
" Switch between active and passive statusline
augroup statuslines
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter,TermOpen,BufWritePost,TextChanged,TextChangedI * call ActiveStatus()
    autocmd WinLeave * call PassiveStatus()
augroup END
"}}}

" Functions
" {{{

" Display Git branching
function! Branches()
    let branch = FugitiveStatusline()
    if branch ==# ""
        let status  = ""
    else
        let status = " ".branch[5:-3]." "
    endif

    return status
endfunction

function! ActiveStatus()
    if &buftype ==# "terminal" || &filetype ==# "nerdtree" || &buftype ==# "quickfix"
        let &l:statusline="\ %t\ "
    else
        let &l:statusline="%3v " " Display current column number

        let &l:statusline.=" >> %{expand('%:p:h:t')}/%t%r%m << %P" " Display filename, modified flag

        let &l:statusline.="%=" " Move to the righthand side
        let &l:statusline.=StlTimeFocus() " Show time
        let &l:statusline.="%{Spelling()}" " Show spelling if any
        let &l:statusline.="%{Branches()}" " Display current Git branch
        " let &l:statusline.='%1*\ '.TypeFile().'\ %*' ' Show filetype
        " setlocal statusline+=%1*\ %7{DispMode()}\ %* " Show mode
    endif
endfunction

function! PassiveStatus()
    if &buftype ==# "terminal" || &filetype ==# "nerdtree" || &buftype ==# "quickfix"
        let &l:statusline="\ %t"
    else
        let &l:statusline="%3v " " Display current column number

        let &l:statusline.=" << %{expand('%:p:h:t')}/%t%r%m >> %P" " Display filename, modified flag

        let &l:statusline.="%=" " Move to the righthand side
        let &l:statusline.=StlTimePassive()
        let &l:statusline.="%{Spelling()}" " Show spelling if any
        let &l:statusline.="%{Branches()}" " Display current Git branch
        " let &l:statusline.='\ '.TypeFile().'\ ' ' Show filetype
    endif
endfunction

" Changes the color of filename in statusline
" if the file has been changed
function! Modified()
    let str = "%{expand('%:p:h:t')}/%t%r%m"
    if &modified
        let status = "%5*".str."%*"
    else
        let status = "%3*".str."%*"
    endif

    return status
endfunction

" Displays filetype. None if no filetype
function! TypeFile()
    if &filetype !=# ""
        let status = "%Y"
    else
        let status = "NONE"
    endif

    return status
endfunction

function! StlTimeFocus()
    if g:time ==# 1
        let status = "%{strftime(\"%H:%M\")} "
    else
        let status = ""
    endif

    return status
endfunction

function! StlTimePassive()
    if g:time ==# 1
        let status = "--:-- "
    else
        let status = ""
    endif

    return status
endfunction

" Disable display of time in statusline
function! s:Time(var)
    if a:var == "on"
        let g:time = 1
    elseif a:var == "off"
        let g:time = -1
    endif
endfunction

" This function checks if spell is active,
" and what language is using.
function! Spelling()
    if &spell
        let status = "SPELL:".&spelllang." "
    else
        let status = ""
    endif

    return status
endfunction

" This function displays the mode
" Useless if you have showmode set
function! DispMode()
    let mymode = mode()
    if mymode ==# "n"
        let result = "NORMAL"
    elseif mymode ==# "i"
        let result = "INSERT"
    elseif mymode ==# "R"
        let result = "REPLACE"
    elseif mymode ==# "v"
         let result = "VISUAL"
    elseif mymode ==# "V"
         let result = "V-LINE"
    elseif mymode ==# "\<C-v>"
         let result = "V-BLOCK"
    elseif mymode ==# "c"
        let result = "COMMAND"
    elseif mymode ==# "t"
        let result = " TERM"
    else
         let result = "NORMAL"
    endif

    return result
endfunction
"}}}
