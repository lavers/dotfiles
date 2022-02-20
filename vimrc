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

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf.vim'

" Language Features / Autocompletion

Plug 'tikhomirov/vim-glsl'
Plug 'jiangmiao/auto-pairs'
Plug 'easymotion/vim-easymotion'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'tweekmonster/wstrip.vim'

if has("nvim")
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/nvim-compe'
	Plug 'simrat39/rust-tools.nvim'
	Plug 'simrat39/symbols-outline.nvim'
	Plug 'ray-x/lsp_signature.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'mfussenegger/nvim-dap'
	Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
	Plug 'nvim-treesitter/playground'
endif

call SourceIfExists('~/.config/nvim/plugins.vim')
call plug#end()

"--------------------------------------------------------------
" AUTOCOMMANDS & FUNCTIONS
"--------------------------------------------------------------

function! Setup()
	if exists('g:loaded_airline')
		" Set noshowmode if Airline is loaded (stops duplicating the --INSERT-- message)
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

" -------------------------------------------------------------
" GENERAL, ENVIRONMENT, TABS & SEARCH
"--------------------------------------------------------------

filetype plugin indent on
syntax on
silent! colorscheme molokai
set noswapfile
let html_no_rendering=1

" Molokai uses a near-invisible select background for some reason

highlight Visual ctermbg=240
highlight CursorColumn ctermbg=236
highlight CursorLine ctermbg=236
highlight MatchParen ctermfg=015 ctermbg=202

"set backspace=indent,eol,start " Allow backspace over autoindent and lines

" Similar filename completion to bash

set wildmode=longest,list,full
set wildignorecase

" Search

set incsearch	" Start search as you type
set hlsearch	" Highlight matches
set ignorecase	" Case insensitive search by default
set smartcase	" If search contains an uppercase, make it case sensitive

if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading
	set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Indentation & Tabs

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
set breakindent			" Indent wrapped lines to the same level as the broken line
set showbreak=>>		" Break indent indicator
set shortmess+=cI		" unsure
set updatetime=300		" Delay before gitgutter updates
set foldlevel=99		" Open all folds by default

" Vim 7.3+ specific

silent! set colorcolumn=100		" Print margin column
silent! set relativenumber		" Relative line numbers

"--------------------------------------------------------------
" COMMANDS
"--------------------------------------------------------------

"command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|botright cwindow|redraw!

command! W w
command! Wq wq
command! Q q
command! Qa qa

"--------------------------------------------------------------
" KEY MAPPINGS
"--------------------------------------------------------------

inoremap kj <Esc>
let mapleader = "\\"
set pastetoggle=<F12>

" Make j & k move between screen rows instead of lines (on wrapped lines)
nmap j gj
nmap k gk

nmap Q <nop>

" split and open
nmap <Bar> :vsplit<CR>:FZF<CR>
nmap _ :split<CR>:FZF<CR>

" tab between windows
nmap <Tab> <C-w>w

" swap between current window and last used window
nmap <bs> <C-w><C-P>

" increment/decrement
nmap + <C-a>
nmap - <C-x>

" For quick easymotion activation
nmap <Space> <Leader><Leader>

" quickly reload vimrc
nmap <leader>s :source ~/.config/nvim/init.vim<CR>

" easier window shortcuts
nmap <Leader>w <C-w>
" Split a window in half
nmap <Leader>ws :vsplit<CR>

" Toggling between relative and absolute line numbers
nmap <Leader>ln :setlocal relativenumber!<CR>

" Toggle line wrapping
nmap <Leader>lw :setlocal wrap!<CR>

" Add a newline above/below/above&below (no insert mode)
nmap <Leader>no o<Esc>k
nmap <Leader>nO O<Esc>j
nmap <Leader>ns O<Esc>jo<Esc>k

" Opening plugin windows
nmap <Leader>e :FZF<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>t :SymbolsOutline<CR>

" Clear highlighting from last search
nmap <Leader>c :noh<CR>

" Split the window and open ~/.vimrc on the right
nmap <Leader>v :vsplit ~/.dotfiles/vimrc<CR>

" System clipboard yank & paste
nmap <Leader>p "+p
nmap <Leader>y "+y

" Move tabs left & right
nmap <Leader>< :tabm -1<CR>
nmap <Leader>> :tabm +1<CR>

" Compiling latex documents
nmap <Leader>lc :!pdflatex %<CR>

" Search for word or WORD under cursor
nmap <Leader>fw :grep "\b<C-R><C-W>\b"<CR>
nmap <Leader>fW :grep "\b<C-R><C-A>\b"<CR>

" Grep for last search string
nmap <Leader>f/ :grep <C-R>/<CR>

" Manual grep
nmap <Leader>ff :grep<SPACE>

" Close quickfix window
nmap <Leader>fq :ccl<CR>

" Highlight occurances of word under cursor
nmap <Leader>* *<C-o>

" For when you forget to open with sudo
cmap w!! w !sudo tee > /dev/null %

" move to a specific window number
let i = 1
while i <= 9
	execute 'nnoremap <Leader>'.i.' :'.i.'wincmd w<CR>'
	let i += 1
endwhile

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

let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_theme = 'airlineish'
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
" WStrip
"--------------------------------------------------------------

let g:wstrip_auto = 1

"--------------------------------------------------------------
" Host-specific config
"--------------------------------------------------------------

call SourceIfExists('~/.config/vim/local.vim')
call SourceIfExists('~/.config/nvim/local.vim')

"--------------------------------------------------------------
" Neovim specific config (all in lua to keep it separate)
"--------------------------------------------------------------

if has("nvim")
	lua require('init')
endif
