let g:lf = -1

function! LfChooser()
    let g:temp = tempname()
    " launch lf
    execute 'edit term://lf --selection-path ' . shellescape(g:temp)
    " determine its buffer
    let g:lf = bufnr()

endfunction

" open the files selected
function! Opener(storage)
    if !filereadable(a:storage)
        redraw!
        " Nothing to read.
        return
    endif

    let names = readfile(a:storage)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction

" every time a terminal buffer is closed, check
" if it was a lf instance. If it was, then open
" the files
augroup lf
    autocmd!

    autocmd TermClose * if g:lf !=# -1 | call Opener(g:temp) | filetype detect | exec 'bd! '.g:lf | let g:lf = -1 | endif
augroup END

command! -bar LfChoose call LfChooser()
nnoremap <silent> <A-f> :<C-U>LfChoose<CR>
