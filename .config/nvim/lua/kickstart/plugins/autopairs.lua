-- autopairs
-- https://github.com/windwp/nvim-autopairs

local comment_fts = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' }

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'

    npairs.setup { map_cr = false }

    -- Auto-close block comments: /* -> /* */
    npairs.add_rules {
      Rule('/*', '*/', comment_fts):with_cr(function() return false end),
      -- Space inside /*|*/ pads both sides: /* | */
      Rule(' ', ' ', comment_fts):with_pair(function(opts)
        return opts.line:sub(opts.col - 2, opts.col + 1) == '/**/'
      end),
    }

    -- <CR> inside /*|*/ or /**|*/ expands into a multiline comment block:
    --   /**
    --    * |
    --    */
    vim.keymap.set('i', '<CR>', function()
      if vim.tbl_contains(comment_fts, vim.bo.filetype) then
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col '.' - 1
        local indent, opening = line:sub(1, col):match '^(%s*)(/%*%*?)%s*$'
        if indent and vim.trim(line:sub(col + 1)) == '*/' then
          local row = vim.fn.line '.'
          vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
            indent .. opening,
            indent .. ' * ',
            indent .. ' */',
          })
          vim.api.nvim_win_set_cursor(0, { row + 1, #indent + 3 })
          return
        end

        -- <CR> on a ` * text` line continues the comment with the same leader
        local leader = line:match '^(%s*%* ?)'
        if leader and not line:match '^%s*%*/' and col >= #leader then
          local row = vim.fn.line '.'
          vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
            (line:sub(1, col):gsub('%s+$', '')),
            leader .. line:sub(col + 1):gsub('^%s+', ''),
          })
          vim.api.nvim_win_set_cursor(0, { row + 1, #leader })
          return
        end
      end
      vim.api.nvim_feedkeys(npairs.autopairs_cr(), 'in', false)
    end, { desc = 'Autopairs <CR> with block comment expansion' })
  end,
}
