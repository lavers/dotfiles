set nocompatible

"--------------------------------------------------------------
" UTILITY FUNCTIONS
"--------------------------------------------------------------

function! SourceIfExists(filename)

	let l:expanded = expand(a:filename)

	if filereadable(l:expanded)
		execute 'source '.fnameescape(l:expanded)
	endif
endfunction

"--------------------------------------------------------------
" PLUGINS 
"--------------------------------------------------------------

call plug#begin()

" Color Schemes

Plug 'tomasr/molokai'
Plug 'paranoida/vim-airlineish'

" Tools / Interface

Plug 'mhinz/vim-startify'			" Start screen & sessions
Plug 'ctrlpvim/ctrlp.vim'			" Fuzzy file finding
Plug 'tpope/vim-fugitive'			" Git plugin
Plug 'tpope/vim-obsession'			" Session managment
Plug 'airblade/vim-gitgutter'		" Git signs in the gutter
Plug 'vim-airline/vim-airline'		" Better status bar
Plug 'majutsushi/tagbar'			" Ctags lists
Plug 'ycm-core/YouCompleteMe'

" Language Features / Autocompletion

Plug 'tikhomirov/vim-glsl'	
Plug 'scrooloose/syntastic'			" Syntax checking
Plug 'jiangmiao/auto-pairs'			" Auto insert brackets
Plug 'easymotion/vim-easymotion'	" Quicker motions
Plug 'AndrewRadev/splitjoin.vim'	" Split/join tags
Plug 'tpope/vim-surround'			" Surround text
Plug 'tweekmonster/wstrip.vim'		" Strip trailing whitespace from changed lines

" System-specific Plugin File

call SourceIfExists('~/.vim/system-plugins.vim')
call plug#end()

"--------------------------------------------------------------
" AUTOCOMMANDS & FUNCTIONS
"--------------------------------------------------------------

" Setup function called when vim starts (can read g:loaded_ vars)

function! Setup()

	" Set noshowmode if Airline is loaded (stops duplicating the --INSERT-- message)
	
	if exists('g:loaded_airline')
		set noshowmode
	endif
endfunction

autocmd VimEnter * :call Setup()

" Stop looking for a matching < when typing -> in php

autocmd BufWinEnter *.php setlocal matchpairs-=<:>

" Stop the default vim sass/rust indent file using spaces rather than tabs

autocmd BufNewFile,BufReadPost *.sass set shiftwidth=4 noexpandtab
autocmd BufNewFile,BufReadPost *.rs set shiftwidth=4 noexpandtab

" Non-default extension mappings

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.zsh-theme set filetype=sh
autocmd BufNewFile,BufReadPost *.rasi set filetype=css

augroup AutoHideCursorLine
	autocmd BufWinEnter,WinEnter * setlocal cursorline
	autocmd WinLeave * setlocal nocursorline
augroup END

" Vim tries to write to some random directory that doesnt exist by default 

if has("win32")
	set directory=.,$TEMP
endif

" -------------------------------------------------------------
" GENERAL, ENVIRONMENT, TABS & SEARCH
"--------------------------------------------------------------

" Enable filetype detection

filetype plugin on 

" Enable syntax highlighting

syntax on

" Set colorscheme

silent! colorscheme molokai

" Molokai uses a near-invisible select background for some reason

highlight Visual ctermbg=240 
highlight CursorColumn ctermbg=236
highlight CursorLine ctermbg=236
highlight MatchParen ctermfg=015 ctermbg=202

" Enable completion

" set omnifunc=syntaxcomplete#Complete
"set completeopt-=preview

" Similar filename completion to bash

set wildmode=longest,list,full

" Search 

set incsearch	" Start search as you type
set hlsearch	" Highlight matches
set ignorecase	" Case insensitive search by default
set smartcase	" If search contains an uppercase, make it case sensitive

" Backspace 

set backspace=indent,eol,start " Allow backspace over autoindent and lines

" Indentation & Tabs

set autoindent
set smartindent
set tabstop=4		" Tabs are 4 columns wide
set shiftwidth=4	" Text indented by 4 columns when using indent operations
set softtabstop=4	" Tab in insert mode is 4 columns
set tw=0			" No auto line wrapping

" Environment

set ruler				" Show where the cursor is
set laststatus=2		" Always show the status line
set showcmd				" Show the command as its being typed
set showmatch			" Show the matching bracket after closing a bracket
set scrolloff=10		" Keep the cursor centered in the screen
set sidescrolloff=5		" Only require 5 characters visible when side scrolling (stops huge jumps)
set sidescroll=5		" Side scroll 1 character at a time 
set number				" Show line numbers
set splitbelow			" Open new splits below rather than above
set splitright			" Open splits right rather than left
set hidden				" Hide buffers instead of closing them

"set cursorline			" Show the cursor line
"set cursorcolumn		" Show the cursor column
set breakindent			" Indent wrapped lines to the same level as the broken line
set showbreak=>>	" Break indent indicator

" Vim 7.3+ specific

silent! set colorcolumn=100		" Print margin column
silent! set relativenumber		" Relative line numbers

" shellslash is needed on windows for Ctrl-P to work with forward slash

set shellslash

" no bloody swap files littering the place

set noswapfile

"--------------------------------------------------------------
" COMMANDS
"--------------------------------------------------------------

" Alias these because i keep mistyping them

command! W w 
command! Q q
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|botright cwindow|redraw!

"--------------------------------------------------------------
" KEY MAPPINGS
"--------------------------------------------------------------

inoremap kj <Esc>

let mapleader = "\\"

" Make j & k move between screen rows instead of lines

nmap j gj
nmap k gk

nmap <Bar> :vsplit<CR>:CtrlP<CR>
nmap _ :split<CR>:CtrlP<CR>
nmap <Tab> <C-w>w

" Because bending your little finger back is stupid

nmap <Leader>w <C-w>
nmap <Leader>ww :vertical resize 
nmap <bs> <C-w><C-P>

" For quick easymotion activation

nmap <Space> <Leader><Leader>

" Split a window in half and move to the right window

nmap <Leader>ws :vsplit<CR><Leader>wl

" Toggling between relative and absolute line numbers

nmap <Leader>ln :setlocal number<CR>
nmap <Leader>lr :setlocal relativenumber<CR>

" Opening plugin windows

nmap <Leader>e :CtrlP<CR>
nmap <Leader>b :CtrlPBuffer<CR>
nmap <Leader>t :TagbarToggle<CR>

" Session saving (ONLY USE WHEN YOUVE ALREADY SET THE SESSION NAME)

nmap <Leader>ss :SSave<CR><CR>y

" Add a newline above/below/above&below (no insert mode)

nmap <Leader>no o<Esc>k
nmap <Leader>nO O<Esc>j
nmap <Leader>ns O<Esc>jo<Esc>k

" Clear highlighting from last search

nmap <Leader>c :noh<CR>

" Toggle line wrapping

nmap <Leader>r :setlocal wrap! wrap?<CR>

" Split the window and open ~/.vimrc on the right

nmap <Leader>v :vsplit ~/.vimrc<CR>

" System yank & paste

nmap <Leader>p "+p
nmap <Leader>y "+y

" Move tabs left & right

nmap <Leader>< :tabm -1<CR>
nmap <Leader>> :tabm +1<CR>

" Paste mode so autoindent doesnt fuck up pasting code in putty

nmap <F12> :set paste!<CR>:AirlineRefresh<CR>

" Compiling latex documents

nmap <Leader>lc :!pdflatex %<CR>

" Search for word or WORD under cursor

nmap <Leader>fw :Ag "\b<C-R><C-W>\b"<CR>
nmap <Leader>fW :Ag "\b<C-R><C-A>\b"<CR>

" Grep for last search string

nmap <Leader>f/ :Ag <C-R>/<CR>

" Manual grep

nmap <Leader>ff :Ag<SPACE>

" Close quickfix window

nmap <Leader>fq :ccl<CR>

" Highlight occurances of word under cursor

nmap <Leader>h *<C-o>

" For when you forget to open with sudo

cmap w!! w !sudo tee > /dev/null %

let html_no_rendering=1

" Maven stuff

function! MavenRunCurrentClass()

	let l:class = substitute(substitute(expand("%:r"), "\/", ".", "g"), "\\", ".", "g")

	execute ":Mvn exec:java -Dexec.mainClass=".substitute(l:class, "src.main.java.", "", "")

endfunction

nmap <Leader>mc :Mvn compile<CR>
nmap <Leader>mr :call MavenRunCurrentClass()<CR>

" Eclim stuff

nmap <Leader>jc :JavaCorrect<CR>

"--------------------------------------------------------------
" GVIM SETTINGS
"--------------------------------------------------------------

if has("gui_running")

	set guifont=Consolas:h10:cANSI

	set guioptions-=T	" No toolbar
	set guioptions-=r	" No right scrollbar
	set guioptions-=m	" No menu bar
	set guioptions-=L	" No left scrollbar
	set mouse=""		" No mouse events

	" Bigger default window size
	
	set lines=40 columns=160

endif

let i = 1

while i <= 9
	execute 'nnoremap <Leader>'.i.' :'.i.'wincmd w<CR>'
	let i += 1
endwhile

"--------------------------------------------------------------
" STARTIFY
"--------------------------------------------------------------

let g:startify_session_persistence = 0
let g:startify_change_to_vcs_root = 1

let g:startify_list_order = [
	\ ['Sessions'], 
	\ 'sessions', 
	\ ['Bookmarks'], 
	\ 'bookmarks', 
	\ ['Recents in current working directory'], 
	\ 'dir', 
	\ ['Recents everywhere'], 
	\ 'files'
	\ ]

let g:startify_bookmarks = [
	\ '~/.vimrc',
	\ '~/.profile',
	\ ]

"--------------------------------------------------------------
" AIRLINE
"--------------------------------------------------------------

function! GetWindowNumber()
	return tabpagewinnr(tabpagenr())
endfunction

function! StatusLineFileInfo()
	return printf(
		\ ' #%d%s%s%s ', 
		\ GetWindowNumber(), 
		\ &l:bomb ? ' ! BOM ! ' : '',
		\ strlen(&enc) > 0 ? ' : '.&enc : '', 
		\ strlen(&ff) > 0 ? ' : '.&ff : ''
	\)
endfunction

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_theme = 'airlineish'
let g:airline_symbols.readonly = 'RO'
let g:airline_highlighting_cache = 1
let g:airline_section_c = '%<%{airline#util#wrap(airline#parts#readonly(),0)}%f %m'
let g:airline_section_y = '%{airline#util#wrap(StatusLineFileInfo(), 0)}'
let g:airline_section_z = '%#__accent_bold#%4l%#__restore__# :%3c'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tagbar#enabled = 0

"--------------------------------------------------------------
" GITGUTTER
"--------------------------------------------------------------

highlight GitGutterAdd    guifg=#009900 ctermfg=2 ctermbg=235
highlight GitGutterChange guifg=#bbbb00 ctermfg=3 ctermbg=235
highlight GitGutterDelete guifg=#ff2222 ctermfg=1 ctermbg=235

"--------------------------------------------------------------
" CTRLP
"--------------------------------------------------------------

let g:ctrlp_custom_ignore = '_compile\|_upload\|node_modules\|platforms'
let g:ctrlp_switch_buffer = 'e'
let g:ctrlp_match_window = 'max:15,results:15'

"--------------------------------------------------------------
" WStrip
"--------------------------------------------------------------

let g:wstrip_auto = 1

"--------------------------------------------------------------
" SYSTEM-SPECIFIC VIMRC
"--------------------------------------------------------------

if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l --nocolor --ignore="*.png" --ignore="*.jpg" --ignore="*.jpeg" --ignore="*.gif" -g ""'
	set grepprg=ag\ --nogroup\ --nocolor
endif

call SourceIfExists('~/.vim/system-vimrc.vim')

