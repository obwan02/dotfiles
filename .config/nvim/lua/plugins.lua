
-- Bootstrapping code for packer, the package manager
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
	-- Manage itself
	use 'wbthomason/packer.nvim'

	-- Requirements for neo-tree
	use 'nvim-lua/plenary.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use 'MunifTanjim/nui.nvim'

	-- File System Stuff - NeoTree for Explorer, and FZF for search
	use 'nvim-neo-tree/neo-tree.nvim'
	use { 'ibhagwan/fzf-lua',
		requires = { "nvim-tree/nvim-web-devicons" }
	}	

-- Shows indentation - can set it up so that it only shows
	-- on certain file type
	use 'lukas-reineke/indent-blankline.nvim'

	-- Status line
	use 'feline-nvim/feline.nvim'

	-- Command line tools as neovim commands (might remove)
	use 'tpope/vim-eunuch'

	-- Git tools as neovim commands (might remove)
	use 'tpope/vim-fugitive'

	-- Commands such as 'gc' for commenting blocks of code
	use 'tpope/vim-commentary'

	-- Catppuccin colorscheme
	-- use {'catppuccin/nvim', as = 'catppuccin'}
		
	-- Jelly beans colortheme
	use 'rktjmp/lush.nvim'
	use 'obwan02/jellybeans2-nvim'


	-- TODO: Add alpha dashboard

	-- Tree sitter for the BEST syntax higlighting for like
	-- literally every file type
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

	-- **** LSP STUFF ****
	use 'neovim/nvim-lspconfig'
	-- Rust specific LSP tools
	use 'simrat39/rust-tools.nvim'
	-- The autocompletion frontend
	use 'hrsh7th/nvim-cmp'
	-- Autocompletion backend
	use 'L3MON4D3/LuaSnip'
	-- Completions for nvim's lsp
	use 'hrsh7th/cmp-nvim-lsp'

	-- Image pasting for markdown
	use 'dfendr/clipboard-image.nvim'

	if packer_bootstrap then
		require('packer').sync()
  	end

end)

require("ibl").setup {
    -- for example, context is off by default, use this to turn it on
    -- show_current_context = true,
    -- show_current_context_start = true,
}

-- require("catppuccin").setup({
--     flavour = "mocha", -- latte, frappe, macchiato, mocha
--     integrations = {
--         cmp = true,
--         gitsigns = true,
--         nvimtree = true,
--         telescope = true,
--         treesitter = true,
--     },
-- })

vim.cmd('colorscheme jellybeans2-nvim')

-- Feline status bar + catppuccin integration
-- local ctp_feline = require('catppuccin.groups.integrations.feline')
-- require('feline').setup { components = ctp_feline.get() }

-- Tree sitter setup
require 'nvim-treesitter.configs'.setup {
	highlight = { 
		enable = true,
		addtional_vim_regex_highlighting = false
	} 
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.vhdl = {
	install_info = {
		url = "https://github.com/alemuller/tree-sitter-vhdl",
		files = {"src/parser.c"},
		branch = "main"
	},

	filetype = "vhd"
}

-- Setup LSP w/ Auto-Complete Capabilities
local nvim_lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Some common LSP servers
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
nvim_lsp.clangd.setup{capabilities=capabilities}

-- Setup for rust tools: additional LSP stuff
require 'rust-tools'.setup {
	tools = { inlay_hints = { only_current_line = true }}
}

-- Auto Complete Full Setup
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
