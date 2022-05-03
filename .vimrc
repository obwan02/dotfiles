set t_Co=256

" set the runtime path to include Vundle and initialize
 
call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'tomasiser/vim-code-dark'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree'

call plug#end()

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
" (coc.vim)
set updatetime=300

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Formats a file with clang-format
function! CXXFormatFile()
	let l:lines = "all"
	py3f /usr/share/clang/clang-format-10/clang-format.py
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" always show signcolumns
set signcolumn=yes

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set autoindent
set number
set relativenumber
set autoread
set keywordprg=:Man 
let mapleader=","
set nohlsearch

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

colorscheme codedark
let g:airline_theme = 'codedark'
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers

set switchbuf+=useopen
nnoremap <SPACE> i <Esc>
nnoremap <C-f> :FZF<CR>
nnoremap <C-k> O<Esc>j
nnoremap <C-j> o<Esc>k
nnoremap <C-d> :call CocActionAsync('jumpDefinition')<CR>

nnoremap <leader>h :noh<CR> 
nnoremap <leader>f :NERDTreeToggle<CR>
nnoremap <leader>cf :!cargo fmt<CR>
nnoremap <leader>ev :vsplit ~/.vimrc<CR>

inoremap <C-v> +

" Abbreviations
" iabbrev ssig obwan02 - obwan02@hotmail.co. nz

" For quick diagnostics
command CD CocDiagnostics

autocmd Filetype c,go setlocal cin
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype json,html setlocal tabstop=2 shiftwidth=2 softtabstop=2

" For Neovide
let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_cursor_trail_length = 0
let g:neovide_cursor_animation_length = 0.1
