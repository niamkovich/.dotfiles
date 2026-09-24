return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggle', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Open Diffview' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File History' },
  },
  opts = {
    enhanced_diff_hl = true, -- как раз даёт тот более плотный/яркий diff-хайлайт, что виден на скрине
    use_icons = true,
  },
}
