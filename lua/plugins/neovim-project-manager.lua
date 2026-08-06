---@type Config
local config = require 'config'

local projects = { '~/.config/nvim' }
vim.list_extend(projects, config.project_directories)

vim.pack.add { {
  src = gh 'Shatur/neovim-session-manager',
}, {
  src = gh 'coffebar/neovim-project',
} }

require('neovim-project').setup {
  projects = projects,
  picker = {
    type = 'telescope',
  },
}

vim.keymap.set('n', '<leader>sp', '<CMD>NeovimProjectDiscover history<CR>', {
  desc = 'Open recent projects',
})
