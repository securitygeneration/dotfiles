" VIM Configuration
" SJ - 14 Feb 2017

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cancel the compatibility with Vi. Essential if you want
" to enjoy the features of Vim
set nocompatible

 Auto-install vim-plug if not installed
if has('unix') || has('macunix')
	if empty(glob('~/.vim/autoload/plug.vim'))
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	  silent autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
elseif has('win32')
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
	Plug 'jeffkreeftmeijer/vim-numbertoggle'
	Plug 'scrooloose/nerdtree'
	Plug 'yegappan/mru'
	Plug 'kien/ctrlp.vim'
	Plug 'tpope/vim-surround'
	Plug 'vim-syntastic/syntastic'
	Plug 'Lokaltog/vim-easymotion'
	Plug 'vim-repeat'
	" Themes
	Plug 'croaker/mustang-vim'
	Plug 'altercation/vim-colors-solarized'
	Plug 'tomasr/molokai'
call plug#end()


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

set scrolloff=3           " Display at least 3 lines around you cursor
                          " (for scrolling)

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
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=100
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set theme - solarized > mustang > desert
if has("gui_running")
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
" => Movement/editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Disabling directional keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

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

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>


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

