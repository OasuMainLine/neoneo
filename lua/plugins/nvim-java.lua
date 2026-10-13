vim.pack.add {
  {
    src = 'https://github.com/JavaHello/spring-boot.nvim',
    version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
  },
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-java/nvim-java',
}

require('java').setup {
  java_debug_adapter = {
    enable = false,
  },
  jdk = {
    auto_install = false,
  },
}
