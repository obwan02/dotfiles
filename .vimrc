set mouse=a
set termguicolors

" Set spelling language
set spelllang=en_us

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8
set signcolumn=number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set number
set autoindent
set autoread
let mapleader=","
set nohlsearch
set smartcase
set clipboard=unnamedplus
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

set switchbuf+=useopen
nnoremap <SPACE> i <Esc>
nnoremap <C-k> O<Esc>j
nnoremap <C-j> o<Esc>k

" Spellcheck
nnoremap <leader>sc :setlocal spell!<CR>

" for highlighting searches
nnoremap <leader>hs :set hlsearch!<CR>

" Shortcut to edit .vimrc
nnoremap <leader>ev :vsplit ~/.vimrc<CR>

" Remap Shift-Tab to exit insert mode
inoremap <S-Tab> <Esc>
vnoremap <S-Tab> <Esc>

" Remap shift-A in visual mode to work as expected always
vnoremap <expr> <S-a> mode() ==# "V" ? "<C-v>$<S-a>" : "<S-a>"
vnoremap <expr> <S-i> mode() ==# "V" ? "<C-v>^<S-i>" : "<S-i>"

command -nargs=1 Count :%s/<args>//gn
command CloseOtherBuffers :%bdelete|edit #|normal `"

function TemplateCompletion(...) 
	return map(glob("~/.vim-templates/*", 1, 1), 'fnamemodify(v:val, ":t")')
endfunction

command -nargs=1 -complete=customlist,TemplateCompletion Template :execute 'normal ggdG' | r ~/.vim-templates/<args> | normal ggdd

autocmd! BufNewFile,BufRead *.shader set ft=glsl
autocmd Filetype c,cpp setlocal cin tabstop=8 shiftwidth=8 softtabstop=8
autocmd Filetype c,cpp,go setlocal cin
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype json,html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype yaml,markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 tw=60

" Always turn spaces into tabs for these file types
autocmd BufWritePre *.md,*.markdown,*.yaml,*.yml retab

" For some reason this is needed?
autocmd BufNewFile,BufRead * setlocal number
