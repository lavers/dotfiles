
if filereadable(expand("~/.vim/autoload/pathogen.vim"))
	execute pathogen#infect()
endif

" AUTOCOMMANDS & FUNCTIONS
" -------------------------------------------------------------

" Setup function called when vim starts (can read g:loaded_ vars)

function! Setup()
	
	if exists('g:loaded_airline')
		set noshowmode
	endif

endfunction

autocmd VimEnter * :call Setup()

" Stop looking for a matching < when typing -> in php

autocmd BufWinEnter *.php setlocal matchpairs-=<:>

" GENERAL, ENVIRONMENT, TABS & SEARCH
" -------------------------------------------------------------

" Enable filetype detection

filetype plugin on 

" Enable syntax highlighting

syntax on

" Set colorscheme

silent! colorscheme molokai

" Molokai uses a near-invisible select background for some reason

highlight Visual ctermbg=240 

" Enable completion

set omnifunc=syntaxcomplete#Complete

" Similar filename completion to bash

set wildmode=longest,list,full

" Search Options

set incsearch	" Start search as you type
set hlsearch	" Highlight matches
set ignorecase	" Case insensitive search by default
set smartcase	" If search contains an uppercase, make it case sensitive

" Backspace Options

set backspace=indent,eol,start " Allow backspace over autoindent and lines

" Indentation & Tabs

set autoindent
set smartindent
set tabstop=4		" Tabs are 4 columns wide
set shiftwidth=4	" Text indented by 4 columns when using indent operations
set softtabstop=4	" Tab in insert mode is 4 columns
set tw=0			" No auto line wrapping

" Environment

set ruler
set laststatus=2 
set showcmd
set showmatch
set scrolloff=1000
set visualbell
set number
set splitbelow
set splitright
set colorcolumn=100

" KEY MAPPINGS
" -------------------------------------------------------------

inoremap kj <Esc>

let mapleader = "\\"

" Because typing these is hard

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

nmap <Leader>t :NERDTreeToggle<CR>
nmap <Leader>e :CtrlP<CR>
nmap <Leader>o :TlistToggle<CR>

" Session saving (ONLY USE WHEN YOUVE ALREADY SET THE SESSION NAME)

nmap <Leader>ss :NERDTreeClose<CR>:SSave<CR><CR>y

" Add a newline above/below/above&below (no insert mode)

nmap <Leader>no o<Esc>k
nmap <Leader>nO O<Esc>j
nmap <Leader>ns O<Esc>jo<Esc>k

" Clear highlighting from last search

nmap <Leader>c :noh<CR>

" Toggle line wrapping

nmap <Leader>r :set wrap! wrap?<CR>

" Split the window and open ~/.vimrc on the right

nmap <Leader>v :vsplit ~/.vimrc<CR>

" Make j & k move between screen rows instead of lines

nmap j gj
nmap k gk

" For when you forget to open with sudo

cmap w!! w !sudo tee > /dev/null %

" For learning

nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" Startify
" -------------------------------------------------------------------------------

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

" NERDTree
" ------------------------------------------------------------------------------

let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeIgnore = [
	\ '\.\(DS_Store\|settings\|git\|buildpath\|project\|swp\|swo\)$',
	\ ]

" Airline
" ------------------------------------------------------------------------------

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#whitespace#enabled = 0
let g:airline_theme = 'airlineish'
let g:airline_symbols.readonly = '🔒  '
let g:airline_section_c = '%<%{airline#util#wrap(airline#parts#readonly(),0)}%f %m'
let g:airline_section_y = ' %{airline#util#wrap(printf("%s : %s", &fenc, &ff),0)} '
let g:airline_section_z = '%#__accent_bold#%4l%#__restore__# :%3c '

" GitGutter
" ------------------------------------------------------------------------------

highlight clear SignColumn

" Taglist
" ------------------------------------------------------------------------------

let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Sort_Type = "name"

