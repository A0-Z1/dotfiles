" Variables
" {{{

" id of terminal job
let t:term_id = -1
" id of terminal buffer
let t:buf = -1
" New terminal window ratio size
let g:window_ratio_vert = 0.4
let g:window_ratio_hor = 0.3

"}}}

" Functions
"{{{

" create horizontal terminal
function! HorTerm(cmd)
    " if terminal does not exist, create it, with specified proportions
    if t:buf ==# -1
        exec float2nr(nvim_list_uis()[0].height*g:window_ratio_hor).'new | call termopen("' . a:cmd . '")'
        " determine terminal id and buffer
        let t:term_id = b:terminal_job_id
        let t:buf = bufnr()
    else
        " if it exists, open current iteration
        exec 'sbuffer +resize'.float2nr(nvim_list_uis()[0].height*g:window_ratio_hor).' '.t:buf
    endif
endfunction

" same, but vertical
function! VertTerm(cmd)
    if t:buf ==# -1
        exec float2nr(nvim_list_uis()[0].width*g:window_ratio_vert)."vnew \| call termopen(\"" . a:cmd . "\")"
        let t:term_id = b:terminal_job_id
        let t:buf = bufnr()
    else
        exec 'vert sbuffer '.t:buf.' | vertical resize'.float2nr(nvim_list_uis()[0].width*g:window_ratio_vert)
    endif
endfunction

" create terminal
function! CreateTerm(layout, cmd)
    " if window's open, send warning
    let l:winbuf = bufwinnr(t:buf)
    if l:winbuf != -1
        echom "A terminal is already open!"
        return
    endif

    " else create it
    if a:layout ==# "vert"
        call VertTerm(a:cmd)
    else
        call HorTerm(a:cmd)
    endif
endfunction

" kill the terminal
function! KillTerm()
    if t:term_id ==# -1
        echom "No terminal active!"
    else
        call chanclose(t:term_id)
        exec 'bd! '.t:buf
        let t:term_id = -1
        let t:buf = -1
        echom "Terminal Killed"
    endif
endfunction

" send a command to the terminal
function! SendCmd(cmd)
    if t:term_id ==# -1
        echom "No terminal active!"
    else
        call chansend(t:term_id, a:cmd)
    endif
endfunction

" send current line to the terminal
function! CurrentLine()
    exec "yank +"
    call SendCmd(@+)
endfunction

" send current selection to the terminal
function! CurrentSel()
    exec "'<,'>yank +"
    call SendCmd(@+)
endfunction

"}}}

" autcmd
" {{{
" Define actions for terminal buffer
augroup terminal_buffer
    autocmd!

    " When you open new tab, set t:term_id and buf to -1
    autocmd TabNew * let t:term_id=-1
    autocmd TabNew * let t:buf=-1

    " when move to terminal window, enter into insert mode
    autocmd TermOpen,BufEnter * if &buftype ==# "terminal" | startinsert | endif

    " Press ctrl+q to close terminal window (but not process)
    autocmd TermOpen,BufEnter * if &buftype ==# "terminal" | nnoremap <buffer><silent> <A-q> :q<CR> | endif
    autocmd TermOpen,BufEnter * if &buftype ==# "terminal" | tnoremap <buffer><silent> <A-q> <C-\><C-n>:q<CR> | endif

    " Don't show row numbers in terminal
    autocmd TermOpen * if &buftype ==# "terminal" | setlocal nonumber norelativenumber | endif
    " modify statusline
    autocmd TermOpen * if &buftype ==# "terminal" | let &l:statusline="\ %t" | endif

augroup END

augroup python_terminal
    autocmd!

    autocmd FileType python nnoremap <buffer><silent> <localleader>st :call CreateTerm("hor", "python")<CR>
    autocmd FileType python nnoremap <buffer><silent> <localleader>vt :call CreateTerm("vert", "python")<CR>
augroup END

"}}}

" remaps
" {{{
" Remap escape command for integrated terminal
tnoremap <silent> <A-e> <C-\><C-n>

" Create\delete terminal buffer in split window.
" If a terminal buffer is open but hidden, take it
" into active mode instead of creating another terminal
" buffer
" NB sbuffer +resizeM N means I am using the cmd resize. A command in sbuffer
" must be prefixed with +. Also, float2nr converts floats to ints. Necessary
" since window resizing only takes integers.
nnoremap <silent> <leader>st :call CreateTerm("hor", "bash")<CR>
nnoremap <silent> <leader>vt :call CreateTerm("vert", "bash")<CR>
nnoremap <silent> <leader>tq :call KillTerm()<CR>

" copy lines of code into the terminal
" but if there is no terminal, send a warning
nnoremap <silent> <leader>l :call CurrentLine()<CR>
" even with multiple lines selected,
" we use CurrentLine() because vim repeats the command
" for each line; if we used CurrentSel(), we would get
" the whole selection sent to the terminal many times
vnoremap <silent> <leader>l :call CurrentLine()<CR>
"}}}
