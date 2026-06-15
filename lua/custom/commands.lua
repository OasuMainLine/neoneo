-- Custom commands
--
do
  vim.api.nvim_create_user_command('RelPath', function()
    local rel_path = vim.fn.expand '%:.'
    vim.fn.setreg('+', rel_path)
    vim.notify('Copied path: ' .. rel_path)
  end, { desc = 'Copy the relative path to the current buffer' })

  vim.api.nvim_create_user_command('CleanSwap', function()
    if vim.fn.confirm('Delete all .swp files in ~/.local/state/nvim/swap?', '&Yes\n&No', 2) ~= 1 then return end

    local deleted = 0
    local failed = 0

    local swap_dir = vim.fn.expand '~/.local/state/nvim/swap'
    if vim.fn.isdirectory(swap_dir) == 1 then
      for name, type_ in vim.fs.dir(swap_dir) do
        if type_ == 'file' and name:sub(-4) == '.swp' then
          if vim.fn.delete(vim.fs.joinpath(swap_dir, name)) == 0 then
            deleted = deleted + 1
          else
            failed = failed + 1
          end
        end
      end
    end

    vim.notify(('Cleaned %d swap file%s%s'):format(deleted, deleted == 1 and '' or 's', failed > 0 and (', ' .. failed .. ' failed') or ''))
  end, { desc = 'Clean the swap files folder (with confirmation)' })

  vim.api.nvim_create_user_command('OpenInFileSystem', function()
    local abs_path = vim.api.nvim_buf_get_name(0)
    abs_path = vim.fs.dirname(abs_path)
    vim.uv.spawn('dolphin', {
      stdio = { nil, nil, nil },
      args = { abs_path },
    }, function() print 'Started dolphin instance' end)
  end, { desc = 'Opens current buffer in the file system' })

  -- Rust only
  --

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    callback = function(ev)
      vim.api.nvim_buf_create_user_command(ev.buf, 'RustCheck', function()
        local clients = vim.lsp.get_clients {
          bufnr = 0,
          name = 'rust_analyzer',
        }

        for _, client in ipairs(clients) do
          local params = vim.lsp.util.make_text_document_params()
          client:notify('rust-analyzer/runFlycheck', params)
        end
      end, { desc = 'Run check analyzer against current buffer' })
    end,
  })
end
