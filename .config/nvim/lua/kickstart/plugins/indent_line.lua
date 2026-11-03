return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      -- Underlines are drawn by the scope highlight below (ibl skips the end line in most cases)
      scope = { show_start = false, show_end = false },
    },
    config = function(_, opts)
      require('ibl').setup(opts)

      -- Highlight the background of the current scope and underline its first and last lines.
      -- The scope itself is the same treesitter node ibl uses for its scope line.
      local ns = vim.api.nvim_create_namespace 'scope-highlight'
      local ibl_scope = require 'ibl.scope'
      local ibl_config = require 'ibl.config'

      local function update(buf)
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        if vim.bo[buf].buftype ~= '' then return end

        local ok, node = pcall(ibl_scope.get, buf, ibl_config.get_config(buf))
        if not ok or not node then return end

        local start_row, _, end_row = node:range()
        if start_row == end_row then return end

        for row = start_row, end_row do
          vim.api.nvim_buf_set_extmark(buf, ns, row, 0, { line_hl_group = 'ScopeBg', priority = 1 })
        end
        for _, row in ipairs { start_row, end_row } do
          local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ''
          local first_col = line:find '%S'
          if first_col then
            vim.api.nvim_buf_set_extmark(buf, ns, row, first_col - 1, { end_col = #line, hl_group = 'ScopeEdge', priority = 1024 })
          end
        end
      end

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufWinEnter', 'TextChanged', 'TextChangedI' }, {
        group = vim.api.nvim_create_augroup('scope-highlight', { clear = true }),
        callback = function(args) update(args.buf) end,
      })
      vim.api.nvim_create_autocmd('BufLeave', {
        group = 'scope-highlight',
        callback = function(args) vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1) end,
      })
    end,
  },
}
