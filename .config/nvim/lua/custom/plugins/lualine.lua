return {
  'nvim-lualine/lualine.nvim',
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        section_separators = '',
        component_separators = '',
      },
      dependencies = { 'nvim-tree/nvim-web-devicons' },
    }
  end,
}
