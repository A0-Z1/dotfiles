" Latex snippets
" autocmd! clears the autocommands previously defined in the group so that sourcing won't add duplicates (every time you source
" vim adds the same autocommands to the group (or outside of groups), making it
" become more and more sluggish)
augroup latex_snippets
    autocmd!

    autocmd Filetype tex iabbrev <buffer> texstart <ESC>:r ~/Templates/Latex/standard.tex<CR>kdd

    autocmd filetype tex iabbrev <buffer> texeq \begin{equation*}<newline><newline>\end{equation*}<up>

    autocmd filetype tex iabbrev <buffer> texal \begin{align*}<newline><newline>\end{align*}<up>

    autocmd filetype tex iabbrev <buffer> texfig \begin{figure}<newline>\centering<newline>\includegraphics[width=\textwidth]{}<newline>\caption{}<newline>\label{}<newline>\end{figure}<ESC>

    autocmd filetype tex iabbrev <buffer> texmat \begin{equation*}<newline>\begin{bmatrix}<newline><newline>\end{bmatrix}<newline>\end{equation*}<up><up><tab>

    autocmd filetype tex iabbrev <buffer> texmats \begin{align*}<newline>\begin{bmatrix}<newline><newline>\end{bmatrix}<newline>\end{align*}<up><up><tab>

    autocmd filetype tex iabbrev <buffer> texcase \begin{equation*}<newline>\begin{cases}<newline><newline>\end{cases}<newline>\end{equation*}<up><up><tab>

    autocmd filetype tex iabbrev <buffer> texcases \begin{align*}<newline>\begin{cases}<newline><newline>\end{cases}<newline>\end{align*}<up><up><tab>

    autocmd filetype tex iabbrev <buffer> texlisting \begin{lstlisting}<newline><newline>\end{lstlisting}<up>

    autocmd FileType tex iabbrev <buffer> texitem \begin{itemize}<newline>\item<newline>\end{itemize}<up><tab><ESC>A

    autocmd FileType tex iabbrev <buffer> texitem \begin{enumerate}<newline>\item<newline>\end{enumerate}<up><tab><ESC>A

    autocmd FileType tex iabbrev <buffer> texr <ESC>:r ~/Templates/Latex/coding/R_coding.tex<CR>

augroup END

augroup C_comments
    autocmd!

    autocmd FileType c iabbrev <buffer> ccc /* */<left><left><left>

augroup END

augroup SQL_comments
    autocmd!

    autocmd FileType sql iabbrev <buffer> ccc /* */<left><left><left>

augroup END

augroup html
    autocmd!

    autocmd FileType html inoremap <buffer><silent> ]] </<C-X><C-O>
    autocmd FileType html inoremap <buffer><silent> }} </<C-X><C-O><ESC><<A

augroup END
