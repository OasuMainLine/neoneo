vim.pack.add { {
  src = gh 'Shatur/neovim-session-manager',
}, {
  src = gh 'coffebar/neovim-project',
} }

require('neovim-project').setup {
  projects = {
    '~/Documents/development/personal/*',
    '~/Documents/development/work/groups360/repos/*',
    '~/.config/nvim'
  },
  picker = {
    type = 'telescope',
  },
}

vim.keymap.set('n', '<leader>sp', '<CMD>NeovimProjectDiscover history<CR>', {
  desc = 'Open recent projects',
})
