"""  _ __   ___  _____   _(_)_ __ ___  
""" | '_ \ / _ \/ _ \ \ / / | '_ ` _ \ 
""" | | | |  __/ (_) \ V /| | | | | | |
""" |_| |_|\___|\___/ \_/ |_|_| |_| |_|


" Put all the nvim options here
"{{{

" Enable showmode (show current mode in command line)
set showmode

" Enable row numbers
set number relativenumber

" Enable cursorline
set cursorline

" Highlight searches
set hlsearch

" Do case insensitive searches
set ignorecase smartcase

" Show incremental search results as you type
set incsearch

" Enable autoindent
set autoindent expandtab tabstop=4 shiftwidth=4

" Regulate positions of new windows
set splitbelow splitright

" To leave buffers that have changes: when you close the window
" or change buffer, the previous buffer on that
" window becomes hidden; it is still loaded
" but you cannot see it. Usually you cannot hide buffers with changes
" (risky if you don't know how vim buffers work)
set hidden

" Set cursor behaviour
set guicursor=n-v:block-Cursor-blinkon0,c-ci-cr:blinkon0,i:ver25-blinkon500-Cursor,r:hor25-Cursor

" Enable 24bit colors in TUI
set tgc

" Save undo trees in files
set undofile
set undodir=~/.local/share/nvim/undo
" Number of undo saved
set undolevels=10000

" Set grep engine with the Perl -P option
let &grepprg="grep -nP $* /dev/null"

set nocompatible
filetype plugin on
syntax on

"}}}


" Put all the user-defined variables here
" {{{

" Make every .tex file become filetype latex
let g:tex_flavor="latex"

" enable python for virtualenvs
let g:python3_host_prog = '/home/a0z1/.venv/neovim/bin/python3'

" }}}


" Put all the plugins here
"{{{

call plug#begin('~/.local.share/nvim/plugged')

" R integration
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}

" LaTeX integration
Plug 'lervag/vimtex'

" Add integration with Git
Plug 'tpope/vim-fugitive'

" Add better python completion
Plug 'rkulla/pydiction'

" vimwiki
Plug 'vimwiki/vimwiki'

" colorscheme
Plug 'morhetz/gruvbox'

call plug#end()

"}}}


" Put all the plugin settings here
"{{{
let g:pydiction_location = '/home/a0z1/.local.share/nvim/plugged/pydiction/complete-dict'

" netwr settings
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0

"}}}


" Put all the highlight settings here
"{{{

" Launch colorscheme
augroup gruvbox
    autocmd!

    autocmd VimEnter * ++nested colorscheme gruvbox
    " Highlight line
    autocmd VimEnter * hi cursorline gui=none guifg=none guibg=grey25
    " Highlight cursorcolumn
    autocmd VimEnter * hi cursorcolumn gui=none guifg=none guibg=grey40

augroup END

"}}}


" Put all the global mappings and commands here
"{{{

let mapleader = ","
let maplocalleader ="\\"

" Toggle NerdTree window
nnoremap <silent> <A-n> :Explore<CR>

" View the current buffers
nnoremap <silent> <leader>b :ls<CR>:buffer<SPACE>

" Switch to prev/next buffer
nnoremap <silent> <leader>n :bnext<CR>
nnoremap <silent> <leader>N :bprevious<CR>

" Remap to go to middle of text line
nnoremap <silent> gm :call cursor(0, virtcol('$')/2)<CR>

" Remap cursorcolumn
nnoremap <silent> <leader><SPACE> :set cursorcolumn!<CR>

" Go quickly to init.vim
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<CR>

" Source init.vim
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>

" Open a new tab
nnoremap <silent> <A-t>t :tabnew<CR>
"Close current tab
nnoremap <silent> <A-t>c :tabclose<CR>
"Close every tab except the current one
nnoremap <silent> <A-t>o :tabonly<CR>
" switch to tab
nnoremap <silent> <A-1> 1gt
nnoremap <silent> <A-2> 2gt
nnoremap <silent> <A-3> 3gt
nnoremap <silent> <A-4> 4gt
nnoremap <silent> <A-5> 5gt
nnoremap <silent> <A-6> 6gt
nnoremap <silent> <A-7> 7gt
nnoremap <silent> <A-8> 8gt
nnoremap <silent> <A-9> 9gt

" Remap window movements
nnoremap <silent> <A-h> <C-w>h
nnoremap <silent> <A-j> <C-w>j
nnoremap <silent> <A-k> <C-w>k
nnoremap <silent> <A-l> <C-w>l

tnoremap <silent> <A-h> <C-\><C-n><C-w>h
tnoremap <silent> <A-j> <C-\><C-n><C-w>j
tnoremap <silent> <A-k> <C-\><C-n><C-w>k
tnoremap <silent> <A-l> <C-\><C-n><C-w>l
" Remap window resizing
nnoremap <silent> <Up>      :resize +2<CR>
nnoremap <silent> <Down>    :resize -2<CR>
nnoremap <silent> <Right>    :vertical resize +2<CR>
nnoremap <silent> <Left>   :vertical resize -2<CR>


" Do a regex search in very magic mode (starts with \v)
nnoremap <leader>/ /\v

" Stop highlighting from last search
nnoremap <silent> <ESC> <ESC>:nohlsearch<CR>

" Use spacebar to fold/unfold
nnoremap <silent> <SPACE> za<CR>
nnoremap <silent> <C-SPACE> zA<CR>

" Delete trailing whitespaces
nnoremap <silent> <leader>wd :%s#\v\s+$##g<CR>:nohlsearch<CR>

" Toggle spelling check
nnoremap <silent> <leader>i :setlocal spell! spelllang=en_gb<CR>
nnoremap <silent> <leader>I :setlocal spell spelllang=it<CR>

" Print the date of today
command! Time echo strftime("%H:%M :: %A %d %B %Y")
" print time
nnoremap <silent> <leader>c :Time<CR>
" Print the Last Edit time
command! LastEdit echo strftime("%H:%M :: %A %d %B %Y", getftime("".@%))
" Display infos about current file
command! Infos echo "Informations about file "."'".expand("%:t")."'"."\nFile Type:\t".toupper(&filetype)."\nFile Encoding:\t".toupper(&fenc)."\nFile Format:\t".toupper(&ff)
" Display current battery status
command! Battery echo system("acpi | awk '{print $3,$4,$5,$6}'")[:-2]

"}}}


" Put all the autocmd here
"{{{

augroup compilation
    autocmd!

    " C compilation
    autocmd filetype c setlocal makeprg=gcc
    autocmd filetype c nnoremap <buffer> <silent> <localleader>c :make % -o %:r.out<CR>
    autocmd filetype c nnoremap <buffer> <silent> <localleader>e :!./%:r.out<CR>

    " C++ compilation
    autocmd filetype cpp setlocal makeprg=g++
    autocmd filetype cpp nnoremap <buffer> <silent> <localleader>c :make % -o %:r.out<CR>
    autocmd filetype cpp nnoremap <buffer> <silent> <localleader>e :!./%:r.out<CR>

    " Python execution
    autocmd FileType python compiler pyunit
    "autocmd filetype python setlocal makeprg=python
    autocmd filetype python nnoremap <buffer> <silent> <localleader>c :make %<CR>

    " Lua execution
    autocmd FileType lua setlocal makeprg=lua5.3
    autocmd FileType lua nnoremap <buffer><silent> <localleader>c :make %<CR>

augroup END

augroup Latex
    autocmd!

    " use detex and wc to count how many words have been written
    autocmd filetype tex nnoremap <buffer><silent> <localleader>wc :echo "Word count: ".system("detex ".@%." \| wc -w")[:-2]." words"<CR>

    " Use texdoc as keywordprogram to look up documentation of a word
    autocmd FileType tex nnoremap <buffer><silent> K :!texdoc <cword><CR>

    autocmd FileType tex vnoremap <buffer><silent> K :!texdoc <cword><CR>

    autocmd FileType tex nnoremap <buffer><silent> <localleader>ss :VimtexCompileSS<CR>

    " invoke help from ArteLaTeX
    autocmd FileType tex nnoremap <buffer><silent> <localleader>h :!zathura /home/a0z1/Documents/Manuali/Latex/ArteLaTeX.pdf &<CR>
    " symbols table
    autocmd FileType tex nnoremap <buffer><silent> <localleader>H :!zathura /home/a0z1/Documents/Manuali/Latex/symbols.pdf &<CR>

augroup END


" Start a python instance
augroup python
    autocmd!

    " Set folding in Python files
    autocmd FileType python setlocal foldmethod=indent foldlevel=50

augroup END

augroup C
    autocmd!
    autocmd FileType c nnoremap <buffer><silent> <localleader>; A;<ESC>
augroup END

" Enable folding for vim files
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END


" Some useful autocmds for bash scripting
augroup bash
    autocmd!

    " THis autocmd checks if a bash script is empty
    " if it is, it writes the shebang
    autocmd FileType sh call SheBang()
    " This autocm makes the file executable
    autocmd BufWritePost * if &filetype ==# "sh" | call system('chmod 755 '.@%) | endif
augroup END


" Close a filetype=nofile by simply pressing q
augroup nofile
    autocmd!
    autocmd FileType help nnoremap <buffer><silent> q :bd<CR>
    autocmd FileType netrw nnoremap <buffer><silent> q :bd<CR>
    autocmd BufEnter * if &buftype ==# "nofile" | nnoremap <buffer><silent> q :q<CR> | endif

augroup END

"}}}


" Put all your functions here
"{{{

" Displays filetype. None if no filetype
function! TypeFile()
    if &filetype !=# ""
        let status = "%Y"
    else
        let status = "NONE"
    endif

    return status
endfunction

" This function checks if a bash script
" is empty, and if it is will add
" the shebang
function! SheBang()
    if line("$") ==# 1 && getline(1) ==# ""
        let @" = "#!/bin/sh\n\n"
        norm! PG
        startinsert
    endif
endfunction

"}}}


" Source additional plugins here
"{{{

" TODO lists
source /home/a0z1/.config/nvim/plugins/todo.vim
" tab completion
source /home/a0z1/.config/nvim/plugins/tabcompletion.vim
" abbreviations
source /home/a0z1/.config/nvim/plugins/abbreviations.vim
" launch file browser
source /home/a0z1/.config/nvim/plugins/lf2.vim
" temrinal plugin
source /home/a0z1/.config/nvim/plugins/terminal.vim
" statusline
source /home/a0z1/.config/nvim/plugins/simple_status.vim
" enable using nvim as less
source /home/a0z1/.config/nvim/plugins/less.vim

"}}}


" Welcome message
execute "echo 'Welcome back. Today is' strftime(\"%A %d %B %Y\")"
