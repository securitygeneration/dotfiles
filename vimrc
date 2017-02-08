" VIM Configuration 
" SJ - 7 Feb 2017

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cancel the compatibility with Vi. Essential if you want
" to enjoy the features of Vim
set nocompatible

" Load Pathogen - removed in favour of vim-plug below.
"execute pathogen#infect()

" Auto-install vim-plug if not installed
if has('unix') || has('macunix')
	if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
endif

" Load vim-plug and plugins and themes
call plug#begin()
	" Plugins
	Plug 'jeffkreeftmeijer/vim-numbertoggle'
	Plug 'scrooloose/nerdtree'
	Plug 'yegappan/mru'
	" Themes
	Plug 'croaker/mustang-vim'
	Plug 'altercation/vim-colors-solarized'
call plug#end()

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>


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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" Set theme
if has("gui_running")
  set t_Co=256
  set background=dark
  colorscheme solarized
else
  colorscheme mustang
endif

" Use system clipboard
set clipboard=unnamedplus

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Movement/editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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