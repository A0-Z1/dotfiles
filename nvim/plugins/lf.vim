function! LfChooser()
    let temp = tempname()
    exec 'silent !$TERM --app-id file_browser lf --selection-path ' . shellescape(temp)
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
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

" invoke ranger to select files
command! -bar LfChoose call LfChooser()
nnoremap <silent> <A-f> :<C-U>LfChoose<CR>
