" VIM Configuration
" SJ - 27 Feb 2017

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cancel the compatibility with Vi
set nocompatible

" Set editor root depending on vim/nvim
if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
else
    let s:editor_root=expand("~/.vim")
endif

" Auto-install vim-plug if not installed
if has('unix') || has('macunix')
	if empty(glob(s:editor_root . '/autoload/plug.vim'))
		silent execute "!curl -fLo" . s:editor_root . "/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
		silent autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
elseif has('win32')
	" Auto-install for Windows
	" Use with caution as this is configured for my portable gVim
	set shell=powershell
	set shellcmdflag=-command
	if empty(glob($VIMRUNTIME."\\autoload\\plug.vim"))
		if empty(glob($VIMRUNTIME."\\autoload"))
			silent execute "!md ".$VIMRUNTIME."\\autoload"
		endif
		silent execute "!$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim';(New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('".$VIMRUNTIME."\\autoload\\plug.vim'))"
		autocmd VimEnter * PlugInstall --sync
	endif
endif

" Load vim-plug, plugins and themes
silent! call plug#begin()
	" Plugins
	Plug 'jeffkreeftmeijer/vim-numbertoggle' " enables relative numbering - Ctrl-N toggles
	Plug 'scrooloose/nerdtree'	 	 " visual file tree
	Plug 'yegappan/mru'			 " recently used files
	Plug 'kien/ctrlp.vim'			 " fuzzy file/buffer/* finder
	Plug 'vim-syntastic/syntastic'		 " syntax checker
	Plug 'Lokaltog/vim-easymotion'		 " easy jumping around the screen
	Plug 'vim-airline/vim-airline'		 " custom tab bar and baseline
	Plug 'tpope/vim-surround'		 " easy add/remov/chang/ing of surrounding brackets/tags
	Plug 'tpope/vim-repeat'			 " adds '.' repeat support for plugins
	Plug 'tpope/vim-commentary'		 " easy commenting: <leader>gcc to toggle
	Plug 'tpope/vim-endwise'		 " auto-adds closing tags (e.g. endif, etc)
	Plug 'raimondi/delimitmate'		 " auto-adds closing quote/brackets
	Plug 'nathanaelkane/vim-indent-guides'	 " visual indentation guides (<Leader>ig)
	Plug 'joeytwiddle/sexy_scroller.vim'	 " Smooth scrolling
	Plug 'terryma/vim-multiple-cursors'	 " Sublime-text style multiple cursors
	Plug 'dkarter/bullets.vim'		 " auto-bulleting/numbering lists
	Plug 'vim-scripts/ScrollColors'		 " scroll through color schemes with :SCROLLCOLOR
	Plug 'jkramer/vim-checkbox'		 " checkboxes: create '[ ]' complete with <leader>tt
	Plug 'lifepillar/vim-cheat40'		 " Vim Cheat Sheet: <leader>?
	Plug 'airblade/vim-gitgutter'		 " Git diff in gutter: <leader>gd to toggle, ]c & [c for next and previous change
	Plug 'Valloric/YouCompleteMe'		 " Tab completion
	Plug 'tmhedberg/SimpylFold'		 " Python folding
	Plug 'tpope/vim-fugitive'		 " Git wrapper
	" Themes
	" Plug 'altercation/vim-colors-solarized'
	" Plug 'croaker/mustang-vim'
	" Plug 'tomasr/molokai'
	Plug 'flazz/vim-colorschemes'		 " mass-load color schemes
	Plug 'frankier/neovim-colors-solarized-truecolor-only' " Solarized for nvim
call plug#end()

" enable the moose!
" set mouse=a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" -- Display
set title                 " Update the title of your window or your terminal
set number                " Display line numbers
set ruler                 " Display cursor position
set wrap                  " Wrap lines when they are too long
set linebreak		  " Don't truncate words on wrap

set scrolloff=3           " Display at least 3 lines around you cursor (for scrolling)

set guioptions=T          " Enable the toolbar

" -- Search
set ignorecase            " Ignore case when searching
set smartcase             " If there is an uppercase in your search term
" search case sensitive again
set incsearch             " Highlight search results when typing
set hlsearch              " Highlight search results

" -- Beep
set visualbell            " Prevent Vim from beeping
set noerrorbells          " Prevent Vim from beeping

" Backspace behaves as expected
set backspace=indent,eol,start

" Hide buffer (file) instead of abandoning when switching
" to another buffer
set hidden

" Properly disable sound on errors on MacVim
if has("gui_macvim")
	autocmd GUIEnter * set vb t_vb=
endif

" Enable wildmenu
set wildmenu

" Set window size
if has("gui_running")
	" GUI is running or is about to start.
	" Maximize gvim window (for an alternative on Windows, see simalt below).
	set lines=999 columns=150
elseif !has('nvim')
	" This is console Vim.
	if exists("+lines")
		set lines=50
	endif
	if exists("+columns")
		set columns=100
	endif
endif

" Enable lazyredraw to speed up scrolling
set lazyredraw

" Autoindent to match adjacent lines
set autoindent

" Make line wraps more evident
set showbreak=↪

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set theme - solarized > mustang > desert
if has("gui_running") || has("nvim")
	set termguicolors
	set t_Co=256
	set background=dark
	try
		silent! colorscheme solarized
	catch /^Vim\%((\a\+)\)\=:E185/
		try
			colorscheme mustang
		catch /^Vim\%((\a\+)\)\=:E185/
			silent! colorscheme desert
		endtry
	endtry
else
	try
		colorscheme mustang
	catch /^Vim\%((\a\+)\)\=:E185/
		silent! colorscheme desert
	endtry
endif

" Highlight the current line
set cursorline
hi CursorLine term=bold cterm=bold

" Use system clipboard
if has('clipboard')
	if has('unnamedplus')  " When possible use + register for copy-paste
		set clipboard=unnamed,unnamedplus
	else         " On mac and Windows, use * register for copy-paste
		set clipboard=unnamed
	endif
endif

" TODO: Configure fonts
"if has('gui_running')
"if LINUX() && has("gui_running")
"    set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
"elseif OSX() && has("gui_running")
"    set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
"elseif WINDOWS() && has("gui_running")
"    set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
"endif
"endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Map Leader (,)
let mapleader = ","
let g:mapleader = ","

" Map ; to : for even moar efficiency!
nnoremap ; :

" Window splitting
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s

" Fast saving
nnoremap <leader>w :w!<cr>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" See a diff of your unsaved changes
" *nix-only (requires diff)
command! Diff w !diff % -

" ,/ redraws the screen and removes any search highlighting.
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>rv :so $MYVIMRC<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Movement/editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Disabling arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Avoid jumping over wrapped lines when going up and down
nnoremap j gj
nnoremap k gk

" Map jk to Esc
imap jk <Esc>

" Mapping to move lines up/down with Alt-j/k
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Insert new lines above or below current line without entering insert mode (Enter/,-Enter)
nnoremap <leader><CR> O<Esc>j
nnoremap <CR> o<Esc>k

" Neovim-specific bindings
if has('nvim')
	" Map ESC for Terminal mode (Neovim)
	tnoremap <Esc> <C-\><C-n>
	tnoremap jk <C-\><C-n>
	" Map Alt-dir to move windows
	tnoremap <C-h> <C-\><C-n><C-w>h
	tnoremap <C-j> <C-\><C-n><C-w>j
	tnoremap <C-k> <C-\><C-n><C-w>k
	tnoremap <C-l> <C-\><C-n><C-w>l
endif

" Buffer navigation
nnoremap <C-S-tab> :bprevious<CR>
nnoremap <leader>H :bprevious<CR>
nnoremap <C-tab>   :bnext<CR>
nnoremap <leader>L :bnext<CR>

" Easy window navigation Ctrl-HJKL
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Map <Leader>i and <Leader>a to insert/append a single character
"   Mappings below are simpler, but can't be repeated with '.'
"    nnoremap <leader>i i_<Esc>r
"    nnoremap <leader>a a_<Esc>r
function! <SID>InsertChar(char, count)
	return repeat(a:char, a:count)
endfunction

nnoremap <silent> <Plug>InsertChar :<C-U>exec "normal i".<SID>InsertChar(nr2char(getchar()), v:count1)<CR>

if !exists('g:insert_char_no_default_mapping') || (g:insert_char_no_default_mapping == 0)
	nmap <leader>i <Plug>InsertChar
end

function! <SID>AppendChar(char, count)
	return repeat(a:char, a:count)
endfunction

nnoremap <silent> <Plug>AppendChar :<C-U>exec "normal a".<SID>AppendChar(nr2char(getchar()), v:count1)<CR>

if !exists('g:append_char_no_default_mapping') || (g:append_char_no_default_mapping == 0)
	nmap <leader>a <Plug>AppendChar
end

" Create a checkbox
imap <leader>cb [ ]
nmap <leader>cb I[ ] <Esc>

" Activate folding - disabled
" command! Fold set foldmethod=indent


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin-specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_error_symbol = "✗"
let g:syntastic_sh_checkers = ['shellcheck']

" Easymotion settings
" change ,,w to forward & backward
nmap <Leader><Leader>w <Plug>(easymotion-bd-w)
" <Leader>f{char} to move to {char}
nmap <Leader><Leader>f <Plug>(easymotion-overwin-f2)
" forward in current line only
map <Leader>l <Plug>(easymotion-lineforward)
" down column only
map <Leader>j <Plug>(easymotion-j)
" up column only
map <Leader>k <Plug>(easymotion-k)
" backward in line only
map <Leader>h <Plug>(easymotion-linebackward)
" keep cursor column when JK motion
let g:EasyMotion_startofline = 0

" Airplane settings
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

" Bullets.vim
let g:bullets_enabled_file_types = ['markdown', 'text', 'gitcommit', 'scratch']
let g:bullets_enable_in_empty_buffers = 1

" Sexy_scroller
:let g:SexyScroller_ScrollTime = 15
:let g:SexyScroller_EasingStyle = 1
:let g:SexyScroller_CursorTime = 5
:let g:SexyScroller_MaxTime = 500

" Gitgutter
map <leader>gd <Plug>GitGutterToggle

" Python folding
" Show docstring preview
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 0
