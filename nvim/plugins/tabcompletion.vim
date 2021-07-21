function! s:TabComplete(direction, completion)
    " Check if the char before the char under the cursor is an 
    " underscore, letter, number, dot or opening parentheses.
    " If it is, and if the popup menu is not visible, use 
    " I_CTRL-X_CTRL-K ('dictionary' only completion)--otherwise, 
    " use I_CTRL-N to scroll downward through the popup menu or
    " use I_CTRL-P to scroll upward through the popup menu, 
    " depending on the value of a:direction.
    " If the char is some other character, insert a normal Tab:
    if searchpos('[_a-zA-Z0-9.(/]\%#', 'nb') != [0, 0] 
        if !pumvisible()
            if a:completion == 'path'
                return "\<C-X>\<C-F>"
            else
                return "\<C-X>\<C-O>"
            endif
        else
            if a:direction == 'down'
                return "\<C-N>"
            else
                return "\<C-P>"
            endif
        endif
    else
        return "\<Tab>"
    endif
endfunction

" Make the Tab key do code completion:
inoremap <silent> <Tab> 
         \<C-R>=<SID>TabComplete('down', 'omnifunc')<CR>

" Make Shift+Tab do code completion in the reverse direction:
inoremap <silent> <S-Tab> 
         \<C-R>=<SID>TabComplete('up', 'omnifunc')<CR>

inoremap <silent> <A-Tab> 
        \<C-R>=<SID>TabComplete('up', 'path')<CR>

