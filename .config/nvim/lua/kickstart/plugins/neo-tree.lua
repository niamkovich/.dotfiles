-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  init = function()
    -- A restored session (e.g. after :restart) recreates neo-tree windows as empty buffers
    -- with the same name, so neo-tree fails with E95. Wipe them and reopen the real tree.
    vim.api.nvim_create_autocmd('SessionLoadPost', {
      callback = function()
        local had_tree = false
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_name(buf):match 'neo%-tree [^/]*%[%d+%]$' and vim.bo[buf].filetype ~= 'neo-tree' then
            had_tree = true
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
        if had_tree then vim.cmd 'Neotree show' end
      end,
    })
  end,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
