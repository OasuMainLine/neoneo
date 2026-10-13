vim.pack.add {
  {
    src = gh 'chomosuke/typst-preview.nvim',
    version = vim.version.range '1.*',
  },
}

-- Calling `setup` implicitly downloads the binaries the plugin depends on
-- (websocat, and tinymist unless provided). We reuse the Mason-installed
-- `tinymist` so it isn't downloaded a second time.
require('typst-preview').setup {
  dependencies_bin = {
    tinymist = 'tinymist',
  },
}

vim.keymap.set('n', '<leader>tp', '<CMD>TypstPreviewToggle<CR>', {
  desc = '[T]ypst [P]review toggle',
})
