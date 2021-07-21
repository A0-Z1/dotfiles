" Display Git branching
function! Branches()
    let branch = FugitiveStatusline()
    if branch ==# ""
        let status  = ""
    else
        let status = " ".branch[5:-3]."  "
    endif

    return status
endfunction

" This function checks if spell is active,
" and show it on the statusline
function! Spelling()
    if &spell
        let status = "[".&spelllang."] "
    else
        let status = ""
    endif

    return status
endfunction

function! CurDir()
    return b:netrw_curdir
endfunction

" for netrw
augroup netrw
    autocmd!
    autocmd BufAdd * if &filetype ==# "netrw" | let &l:statusline=" %{CurDir()} %r%m" | endif
augroup END


set statusline=%<%f\%h%m%r\ %{Branches()}%=%{Spelling()}%-14.(%l,%c%V%)\ %P

