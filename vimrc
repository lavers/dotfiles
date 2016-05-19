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

" New Filetypes

Plug 'tikhomirov/vim-glsl'	
Plug 'cakebaker/scss-syntax.vim'

" Behavior / Features

Plug 'mhinz/vim-startify'			" Start screen & sessions
Plug 'ctrlpvim/ctrlp.vim'			" Fuzzy file finding
Plug 'tpope/vim-fugitive'			" Git plugin
Plug 'tpope/vim-surround'			" Surround text
Plug 'airblade/vim-gitgutter'		" Git signs in the gutter
Plug 'vim-airline/vim-airline'		" Better status bar
Plug 'paranoida/vim-airlineish'		" Theme for better status bar
Plug 'easymotion/vim-easymotion'	" Quicker motions

" Language Features / Autocompletion

Plug 'scrooloose/syntastic'			" Syntax checking
Plug 'vim-scripts/taglist.vim'		" Browser for functions/variables

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

" Add markdown extension

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.zsh-theme set filetype=sh

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

" Enable completion

" set omnifunc=syntaxcomplete#Complete
set completeopt-=preview

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
set sidescroll=1		" Side scroll 1 character at a time 
set visualbell			" No bloody beeping
set number				" Show line numbers
set splitbelow			" Open new splits below rather than above
set splitright			" Open splits right rather than left
set hidden				" Hide buffers instead of closing them

set cursorline			" Show the cursor line
set breakindent			" Indent wrapped lines to the same level as the broken line
set showbreak=>>		" Break indent indicator

" Vim 7.3+ specific

silent! set colorcolumn=100		" Print margin column
silent! set relativenumber		" Relative line numbers

" shellslash Causes problems with syntastic on windows

set noshellslash

" no bloody swap files littering the place

set noswapfile

"--------------------------------------------------------------
" COMMANDS
"--------------------------------------------------------------

" Alias these because i keep mistyping them

command! W w 
command! Q q

"--------------------------------------------------------------
" KEY MAPPINGS
"--------------------------------------------------------------

inoremap kj <Esc>

let mapleader = "\\"

" Make j & k move between screen rows instead of lines

nmap j gj
nmap k gk

nmap <Bar> :vsplit<CR>
nmap _ :split<CR>
nmap <Tab> <C-w>w

" Because bending your little finger back is stupid

nmap <Leader>w <C-w>
nmap <Leader>ww :vertical resize 

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
nmap <Leader>t :TlistToggle<CR>

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

nmap <Leader>p "*p
nmap <Leader>y "*y

" Paste mode so autoindent doesnt fuck up pasting code in putty

nmap <F12> :set paste!<CR>:AirlineRefresh<CR>

" Compiling latex documents

nmap <Leader>lc :!pdflatex %<CR>

" For when you forget to open with sudo

cmap w!! w !sudo tee > /dev/null %

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
	set mouse=""		" No mouse events

	" Bigger default window size
	
	set lines=40 columns=160

endif

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

let g:startify_custom_header = [
	\ '			 _			   ', 
	\ '			(_)			   ',
	\ '	__   __  _   _ __ ___  ',
	\ '	\ \ / / | | | ''_ ` _ \',
	\ '	 \ V /  | | | | | | | |',
	\ '	  \_/   |_| |_| |_| |_|',
	\ '						   ',
	\ ]

"--------------------------------------------------------------
" AIRLINE
"--------------------------------------------------------------

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#whitespace#enabled = 0
let g:airline_theme = 'airlineish'
let g:airline_symbols.readonly = 'RO'
let g:airline_section_c = '%<%{airline#util#wrap(airline#parts#readonly(),0)}%f %m'
let g:airline_section_y = ' %{airline#util#wrap(printf("%s : %s", &fenc, &ff),0)} '
let g:airline_section_z = '%#__accent_bold#%4l%#__restore__# :%3c '
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

"--------------------------------------------------------------
" GITGUTTER
"--------------------------------------------------------------

highlight clear SignColumn

"--------------------------------------------------------------
" CTRLP
"--------------------------------------------------------------

let g:ctrlp_custom_ignore = '_compile\|_upload'
let g:ctrlp_switch_buffer = 'et'

"--------------------------------------------------------------
" SYSTEM-SPECIFIC VIMRC
"--------------------------------------------------------------

call SourceIfExists('~/.vim/system-vimrc.vim')

