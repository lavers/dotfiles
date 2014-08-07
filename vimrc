
if filereadable(expand("~/.vim/autoload/pathogen.vim"))
	execute pathogen#infect()
endif

autocmd VimEnter * :call Setup()
au BufWinEnter *.php setlocal matchpairs-=<:> " Stop terminal bells when typing -> 

function! Setup()
	
	if exists('g:loaded_airline')
		set noshowmode
	endif

endfunction

filetype plugin on 

" Enable syntax highlighting

syntax on

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

" KEY MAPPINGS
" -------------------------------------------------------------

inoremap kj <Esc>

let mapleader = "\\"

" Leader key stuff

nmap <Leader>w <C-w>
nmap <Leader>ln :setlocal number<CR>
nmap <Leader>lr :setlocal relativenumber<CR>
nmap <Leader>t :NERDTreeTabsToggle<CR>
nmap <Leader>e :CtrlP<CR>
nmap <Leader>o :TlistToggle<CR><Leader>wh
nmap <Leader>ws :vsplit<CR><Leader>wl
nmap <Leader>ss :SSave<CR><CR>y<CR>
nmap <Leader>no o<Esc>k
nmap <Leader>nO O<Esc>j

" Make j & k move between screen rows instead of lines

nmap j gj
nmap k gk

" For when you forget sudo

cmap w!! w !sudo tee > /dev/null %

" Add \v to search by default, essentially makes perl style regex default

nnoremap / /\v
vnoremap / /\v

" For Learning

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

