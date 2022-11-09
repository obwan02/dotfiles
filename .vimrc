set mouse=a
set termguicolors

" set the runtime path to include Vundle and initialize

call plug#begin('~/.vim/plugged')

" Requirements for neo-tree
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'

Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

Plug 'sheerun/vim-polyglot' " Provides basic syntax highlighting for filetypes without language server and built in syntax support (mainly obscure filtypes such as fish scripts)

Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
Plug 'L3MON4D3/LuaSnip' " For snippet engine
Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-path' " Path completion for nvim-cmp
Plug 'simrat39/rust-tools.nvim' " Rust specific plugin for LSP

Plug 'feline-nvim/feline.nvim'
Plug 'tpope/vim-eunuch'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'glepnir/dashboard-nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" For nvim dashboard
let g:dashboard_default_executive = 'fzf'
let g:neo_tree_remove_legacy_commands = 1

lua << EOF

require'fzf-lua'.setup {
  grep = { git_icons = false },
  files = { git_icons = false },
}


local lsp_installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")

lsp_installer.setup {}

lspconfig.util.default_config = vim.tbl_extend(
"force",
lspconfig.util.default_config,
{
	-- Add additional capabilities supported by nvim-cmp
	capabilities = require('cmp_nvim_lsp').update_capabilities(
	vim.lsp.protocol.make_client_capabilities()	
	),
	on_attach = function(client, bufnr)
	vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
	end
}
)

for _, server in ipairs(lsp_installer.get_installed_servers()) do
	lspconfig[server.name].setup({})
end

require('luasnip.loaders.from_vscode').lazy_load()
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

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
		{ name = 'path' },
	},
	window = {
		documentation = cmp.config.window.bordered()
	},
}

require('rust-tools').setup({})

local catppuccin = require('catppuccin')
catppuccin.setup({
	transparent_background = false,
	term_colors = true,
	styles = {
		comments = "italic",
		conditionals = "italic",
		loops = "NONE",
		functions = "NONE",
		keywords = "NONE",
		strings = "NONE",
		variables = "NONE",
		numbers = "NONE",
		booleans = "NONE",
		properties = "NONE",
		types = "NONE",
		operators = "NONE",
	},
	integrations = {
		treesitter = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = "italic",
				hints = "italic",
				warnings = "italic",
				information = "italic",
			},
			underlines = {
				errors = "underline",
				hints = "underline",
				warnings = "underline",
				information = "underline",
			},
		},
		lsp_trouble = false,
		cmp = true,
		lsp_saga = false,
		gitgutter = false,
		gitsigns = true,
		telescope = true,
		nvimtree = {
			enabled = false,
			show_root = false,
			transparent_panel = false,
		},
		neotree = {
			enabled = true,
			show_root = false,
			transparent_panel = true,
		},
		which_key = false,
		indent_blankline = {
			enabled = false,
			colored_indent_levels = false,
		},
		dashboard = true,
		neogit = false,
		vim_sneak = false,
		fern = false,
		barbar = false,
		bufferline = false,
		markdown = true,
		lightspeed = false,
		ts_rainbow = false,
		hop = false,
		notify = false,
		telekasten = false,
		symbols_outline = false,
	}
})

require("feline").setup({
components = require('catppuccin.core.integrations.feline'),
})

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
  -- disable virtual text (virtual text is the text that appears near an error)
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
	style = "minimal",
	border = "rounded"
  }
}

vim.diagnostic.config(config)

function LspDiagnosticsFocus()
    vim.api.nvim_command('set eventignore=WinLeave')
    vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
	local _, win_id = vim.diagnostic.open_float(nil, {focusable = false, scope = 'line', close_events = {"CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave"}})
	if (win_id ~= nil) then
	    vim.api.nvim_command('hi! def link NormalFloat Normal')
	end
end

-- Show error when hovering over error message
vim.api.nvim_command('autocmd CursorHold * lua LspDiagnosticsFocus()')
vim.api.nvim_set_keymap('n', '<leader>d', '<Cmd>lua LspDiagnosticsFocus()<CR>', {silent = true})

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

EOF

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
" (coc.vim)
set updatetime=300

" Set spelling language
set spelllang=en_nz

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
set autoindent
set number
set autoread
set keywordprg=:Man 
let mapleader=","
set nohlsearch

let g:catppuccin_flavour = "dusk"
colorscheme catppuccin

set switchbuf+=useopen
nnoremap <SPACE> i <Esc>
nnoremap <C-f> :FzfLua files<CR>
nnoremap <C-k> O<Esc>j
nnoremap <C-j> o<Esc>k

" -- LSP BINDINGS

lua << EOF
vim.api.nvim_create_autocmd('User', {
	pattern = 'LspAttached',
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

" Shortcut for neotree
nnoremap <leader>x :Neotree filesystem reveal=false float<CR>
nnoremap <leader>X :Neotree filesystem reveal=true left<CR>

" Ripgrep for text searcing files using fzf
nnoremap <leader>ss :lua require("fzf-lua").grep_project()<CR>

" Spellcheck
nnoremap <leader>sc :setlocal spell!<CR>

" for highlighting searches
nnoremap <leader>hs :set hlsearch!<CR>

" Templates for various languages
nnoremap <silent> <leader>tp ggO#!/usr/bin/env python3<CR><CR>if __name__ == "__main__":<CR>pass<Esc><C-o>

" Shortcut to edit .vimrc
nnoremap <leader>ev :vsplit ~/.vimrc<CR>


" Remap Shift-Tab to exit insert mode
inoremap <S-Tab> <Esc>
vnoremap <S-Tab> <Esc>
" Abbreviations
" iabbrev ssig obwan02 - obwan02@hotmail.co.nz

" For quick diagnostics
command CD CocDiagnostics

autocmd! BufNewFile,BufRead *.shader set ft=glsl
autocmd Filetype c,go setlocal cin
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype json,html setlocal tabstop=2 shiftwidth=2 softtabstop=2

" For Neovide
let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_cursor_trail_length = 0
let g:neovide_cursor_animation_length = 0.1
