-- Most keybindings that are specific to neovim/lua (aka are from plugins)
-- will go here. Otherwise, put the keybinds in the .vimrc file so they are universal

vim.api.nvim_set_keymap('n', '<leader>f', ':FzfLua files<CR>', { noremap = true, silent = true })

-- LSP Keybinds
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

-- Shortcut for neotree
vim.api.nvim_set_keymap('n', '<leader>x', ':Neotree filesystem reveal=false float<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>X', ':Neotree filesystem reveal=true float<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ss', "<cmd>lua require'fzf-lua'.grep_project()<CR>", {noremap = true})

-- For indent blankline
vim.api.nvim_set_keymap('n', '<leader>ht', ':IndentBlanklineToggle<CR>', {noremap = true})
