vim.pack.add {
  {
    src = gh 'linux-cultist/venv-selector.nvim',
    version = 'main',
  },
}

require('venv-selector').setup()

