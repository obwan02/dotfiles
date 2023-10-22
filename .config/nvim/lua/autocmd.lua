vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
	pattern = '*',
	command = "IBLDisable"
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufReadPost'}, {
	pattern = {'*.yaml', '*.md'},
	command = "IBLEnable"
})
