return {
  "ojroques/vim-oscyank",
  vim.keymap.set('n', '<leader>c', '<Plug>OSCYankOperator'),
  vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true}),
  vim.keymap.set('v', '<leader>c', '<Plug>OSCYankVisual'),
  -- Yank to clipboard and use OSCYank
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = '*',
    callback = function()
      if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
        vim.cmd('OSCYankRegister +')
      end
    end,
  })
}
