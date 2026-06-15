do
  local custom_group = vim.api.nvim_create_augroup('custom_autocmds', {})

  vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'Silently save when exiting insert mode',
    pattern = '*',
    group = custom_group,
    callback = function()
      local buftype = vim.bo.buftype
      if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly and buftype == '' then vim.cmd 'silent write' end
    end,
  })

  vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'Runs rust check after leaving insert mode',
    pattern = '*.rs',
    group = custom_group,
    callback = function()
	vim.cmd 'RustCheck'
    end,
  })
end
