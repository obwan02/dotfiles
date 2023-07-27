set mouse=a
set termguicolors

" set the runtime path to include Vundle and initialize

call plug#begin('~/.vim/plugged')

" Requirements for neo-tree
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'

Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

" Jellybeans colorscheme
Plug 'nanotech/jellybeans.vim'

" Show indentation. Have setup so it's only enabled for YAML files
Plug 'lukas-reineke/indent-blankline.nvim'
" Cool status bar
Plug 'feline-nvim/feline.nvim'
" Command line tools as commands
Plug 'tpope/vim-eunuch'
" Git tools
Plug 'tpope/vim-fugitive'
" Easy commenting
Plug 'tpope/vim-commentary'
" Color Scheme
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
" Bashboard when opening neovim
Plug 'glepnir/dashboard-nvim'

" LSP Stuff

" Language Server Client Config
Plug 'neovim/nvim-lspconfig'
" Rust specific LSP tools
Plug 'simrat39/rust-tools.nvim'
" Tree sitter for the BEST syntax higlighting for like
" literally every file type
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" The autocompletion frontend
Plug 'hrsh7th/nvim-cmp'
" Autocompletion backend
Plug 'L3MON4D3/LuaSnip'
" Completions for nvim's lsp
Plug 'hrsh7th/cmp-nvim-lsp'

" Goofy plugin
Plug 'eandrju/cellular-automaton.nvim' 
" For changing surroundings such as " ( { <p> etc. 
Plug 'tpope/vim-surround'
" For moving around easily
Plug 'justinmk/vim-sneak'

" Debugging
Plug 'mfussenegger/nvim-dap'
" Good defaults for nvim-dap
Plug 'rcarriga/nvim-dap-ui'
Plug 'mfussenegger/nvim-dap-python'
call plug#end()

" For nvim dashboard
let g:dashboard_default_executive = 'fzf'
let g:neo_tree_remove_legacy_commands = 1

lua << EOF


require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

require("dapui").setup()

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
}

require'fzf-lua'.setup {
  grep = { git_icons = false },
  files = { git_icons = false },
}

require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    transparent_background = false,
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

local ctp_feline = require('catppuccin.groups.integrations.feline')

require("feline").setup({
	components = ctp_feline.get(),
})

require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

local home = os.getenv('HOME')
local db = require('dashboard')

db.custom_center = {
	{icon = '  ',
		desc = 'Recently laset session                  ',
		shortcut = 'SPC s l',
		action ='SessionLoad'},
	{icon = '  ',
		desc = 'Recently opened files                   ',
		action =  'DashboardFindHistory',
		shortcut = 'SPC f h'},
	{icon = '  ',
		desc = 'Find  File                              ',
		action = 'FZF',
		shortcut = 'SPC f f'},
	{icon = '  ',
		desc ='File Browser                            ',
		action =  'Neotree filesystem reveal=false float',
		shortcut = 'SPC f b'},
	{icon = '  ',
		desc = 'Find  word                              ',
		aciton = 'DashboardFindWord',
		shortcut = 'SPC f w'},
	{icon = '  ',
		desc = 'Open .vimrc                             ',
		action = 'edit ~/.vimrc',
		shortcut = 'SPC f d'},
}

local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.vhdl = {
	install_info = {
		url = "https://github.com/alemuller/tree-sitter-vhdl",
		files = {"src/parser.c"},
		branch = "main"
	},

	filetype = "vhd"
}

--  Configure java server
nvim_lsp.jdtls.setup{capabilities=capabilities}
nvim_lsp.zls.setup{capabilities=capabilities}
nvim_lsp.pylsp.setup{
	capabilities=capabilities,
	pylsp = {
		plugins = {
			black = { enabled = true },
			flake8 = { enabled = true },
			pycodestyle = { enabled = true },
		}
	}
}
nvim_lsp.gopls.setup{capabilities=capabilities}
nvim_lsp.tsserver.setup{capabilities=capabilities}
nvim_lsp.vhdl_ls.setup{capabilities=capabilities}
nvim_lsp.clangd.setup{capabilities=capabilities}

-- Rust tools setup up lsp for us
require('rust-tools').setup({
	tools = {
		inlay_hints = {
			only_current_line = true,
		}
	}
})

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require('luasnip')
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	mapping = cmp.mapping.preset.insert({
	['<CR>'] = cmp.mapping.confirm {
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	},
	['<C-Down>'] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		else
			fallback ()
		end
		end, { 'i', 's' }),
	['<C-Up>'] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		else
			fallback()
		end
		end, { 'i', 's' }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	window = {
		documentation = cmp.config.window.bordered()
	},
}
EOF

" You will have bad experience for diagnostic messages when it's default 4000.
" (coc.vim)
set updatetime=300

" Set spelling language
set spelllang=en_us

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

set signcolumn=number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set number
set autoindent
set autoread
set keywordprg=:Man 
let mapleader=","
set nohlsearch
set smartcase
set clipboard=unnamedplus
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

let g:catppuccin_flavour = "dusk"
colorscheme catppuccin

set switchbuf+=useopen
set rtp+=/opt/homebrew/opt/fzf
nnoremap <SPACE> i <Esc>
nnoremap <leader>f :FzfLua files<CR>
nnoremap <C-k> O<Esc>j
nnoremap <C-j> o<Esc>k

" -- LSP BINDINGS

lua << EOF

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function()
		local bufmap = function(mode, lhs, rhs)
			local opts = {buffer = true}
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		-- Displays hover information about the symbol under the cursor
		bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

		-- Jump to the definition
		bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

		-- Jump to declaration
		bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

		-- Lists all the implementations for the symbol under the cursor
		bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

		-- Jumps to the definition of the type symbol
		bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

		-- Lists all the references 
		bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

		-- Displays a function's signature information
		bufmap('n', '<C-d>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

		-- Renames all references to the symbol under the cursor
		bufmap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>')

		-- Selects a code action available at the current cursor position
		bufmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>')
		bufmap('x', '<leader>a', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

		-- Show diagnostics in a floating window
		bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

		-- Move to the previous diagnostic
		bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

		-- Move to the next diagnostic
		bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
	end
})

EOF

" Silly stuff
nnoremap <leader>shit :CellularAutomaton make_it_rain<CR>

" Shortcut for neotree
nnoremap <leader>x :Neotree filesystem reveal=false float<CR>
nnoremap <leader>X :Neotree filesystem reveal=true float<CR>

" Ripgrep for text searcing files using fzf
nnoremap <leader>ss :lua require("fzf-lua").grep_project()<CR>

" Spellcheck
nnoremap <leader>sc :setlocal spell!<CR>

" for highlighting searches
nnoremap <leader>hs :set hlsearch!<CR>

nnoremap <leader>ht :IndentBlanklineToggle<CR>

" DEBUGGING COMMANDS

nnoremap <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>dc :lua require'dap'.continue()<CR>
nnoremap <leader>dss :lua require'dap'.step_over()<CR>
nnoremap <leader>dS :lua require'dap'.step_over()<CR>
nnoremap <leader>dsi :lua require'dap'.step_into()<CR>
nnoremap <leader>dt :DapTerminate<CR>

nnoremap <leader>du :lua require'dapui'.toggle()<CR>

" Shortcut to edit .vimrc
nnoremap <leader>ev :vsplit ~/.vimrc<CR>


" Remap Shift-Tab to exit insert mode
inoremap <S-Tab> <Esc>
vnoremap <S-Tab> <Esc>

" Remap shift-A in visual mode to work as expected always
vnoremap <expr> <S-a> mode() ==# "V" ? "<C-v>$<S-a>" : "<S-a>"
vnoremap <expr> <S-i> mode() ==# "V" ? "<C-v>^<S-i>" : "<S-i>"

" Abbreviations
" iabbrev ssig obwan02 - obwan02@hotmail.co.nz

command -nargs=1 Count :%s/<args>//gn
command CloseOtherBuffers :%bdelete|edit #|normal `"

function TemplateCompletion(...) 
	return map(glob("~/.nvim-templates/*", 1, 1), 'fnamemodify(v:val, ":t")')
endfunction

command -nargs=1 -complete=customlist,TemplateCompletion Template :execute 'normal ggdG' | r ~/.nvim-templates/<args> | normal ggdd

autocmd BufNewFile,BufRead * :IndentBlanklineDisable
autocmd BufNewFile,BufReadPost *.yaml,*.md :IndentBlanklineEnable
autocmd BufWritePre * silent lua vim.lsp.buf.format()

autocmd! BufNewFile,BufRead *.shader set ft=glsl
autocmd Filetype c,cpp setlocal cin tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype c,cpp,go setlocal cin
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype json,html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype yaml,markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 tw=60

autocmd BufWritePre *.md,*.markdown,*.yaml,*.yml retab

" For some reason this is needed?
autocmd BufNewFile,BufRead * setlocal number
