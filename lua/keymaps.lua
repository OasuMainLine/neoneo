local map = vim.keymap.set

-- Disable uppercase move behavior
map({ 'n', 'x' }, 'H', 'h')
map({ 'n', 'x' }, 'J', 'j')
map({ 'n', 'x' }, 'K', 'k')
map({ 'n', 'x' }, 'L', 'l')
map('n', 'Ñ', vim.lsp.buf.hover, { desc = 'LSP hover information' })
map('n', '<leader>u', '<cmd>update<CR>', { desc = 'Updates the current buffer if it changed' })
map('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close all buffers except current' })
map('n', '<leader>bx', '<cmd>:bd!<cr>', { desc = 'Close current buffer' })
map('n', '<leader>ba', '<cmd>:%bd!<cr>', { desc = 'Close all buffers' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
