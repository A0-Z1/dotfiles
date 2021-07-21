" Create floating window containing TODO buffer
function! TODO()
    " add TODO.md in the buffer list. This creates
    " a new file in the current directory (that is
    " the directory of the current buffer) if it doesn't
    " exist yet
    let name = expand("%:p:h")."/TODO.txt"

    execute "badd ".name
    let buf = bufnr(name)

    " get the current UI settings
    let ui = nvim_list_uis()[0]

    " define the size of the floating window
    let width = 70
    let height = 23
    " Create the floating window
    let opts = {'relative': 'editor',
                \ 'width': width,
                \ 'height': height,
                \ 'anchor': 'NW',
                \ 'col': (ui.width/2) - (width/2),
                \ 'row': (ui.height/2) - (height/2),
                \ 'style': 'minimal',
                \ }

    call nvim_open_win(buf, 1, opts)
    normal! G$zz
    " if TODO.txt is empty, start already in insert mode
    if line("$") ==# 1 && getline(1) ==# ""
        let completed = "Tasks Completed\n===============\n\n\n"
        let lefts = "Tasks Left\n==========\n\n[ ]  "
        let @" = "### TODO list for project directory '".expand("%:p:h:t")."'\n\n".completed.lefts
        " paste it all
        normal! p
        " mark to C and L the respective sections
        execute "3mark c"
        execute "7mark l"

        " Go to the end of file
        normal! G$

        startinsert
    endif

    " Define a bunch of mappings that only apply to this buffer:
    " Close easily even in insert mode and save only
    " when there are changes
    nnoremap <buffer><silent> <A-q> :x<CR>
    inoremap <buffer><silent> <A-q> <ESC>:x<CR>

    " Every time you go to a newline, add
    " a [ ] at the beginning
    inoremap <buffer><silent> <CR> <CR><CR>[ ] 
    nnoremap <buffer><silent> o o<CR>[ ] 
    nnoremap <buffer><silent> O O<ESC>O[ ] 

    " Toggle 'completed' mark in the current line
    nnoremap <buffer><silent> <leader>x :call <SID>ToggleCompleted()<CR>

endfunction

" Toggle 'completed' in TODO window
function! s:ToggleCompleted()
    " Go where the gap is
    normal! 2|x
    if @- ==# " "
        " Write an X to mark as completed
        normal! iX
        " delete the entire line
        execute ".-1,.d"
        " Now go into the 'Task Completed section'
        normal! `lkk
        " and now paste and return to where you were
        normal! P``

    elseif @- ==# "X"
        " Mark it as uncompleted
        execute "normal! i "
        " delete the entire line
        execute ".-1,.d"
        " Now go to the end of the file and paste the line
        " and return to where you were
        normal! Gp``
    else
        silent! normal! u
        execute "echohl WarnMessage | echo 'You are not on a TODO entry!' | echohl None"
    endif
endfunction

" Call TODO window
command! TODO call TODO()
nnoremap <silent> <leader>T :call TODO()<CR>
