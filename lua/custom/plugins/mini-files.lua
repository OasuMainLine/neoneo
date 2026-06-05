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
    MiniFiles.open()
  end
end, { desc = 'NeoTree reveal', silent = true })
