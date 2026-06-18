require('mini.files').setup {
  mappings = {
    go_in_plus = '<CR>',
  },
}

vim.keymap.set('n', '\\', function()
  local is_open = MiniFiles.get_explorer_state() ~= nil
  if is_open then
    MiniFiles.close()
  else
    local current_buffer = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(current_buffer, false)
    MiniFiles.reveal_cwd()
  end
end, { desc = 'Mini files toggle', silent = true })

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local b = args.data.buf_id

    vim.keymap.set('n', 'gYa', function()
      local entry = require('mini.files').get_fs_entry()
      if entry then
        vim.fn.setreg('+', entry.path)
        print('Copied path: ' .. entry.path)
      end
    end, { buffer = b, desc = 'Copy absolute path' })

    vim.keymap.set('n', 'gYr', function()
      local entry = require('mini.files').get_fs_entry()
      if entry then
        local rel_path = vim.fn.fnamemodify(entry.path, ':.')
        vim.fn.setreg('+', rel_path)
        print('Copied path: ' .. rel_path)
      end
    end, { buffer = b, desc = 'Copy relative path' })
  end,
})
