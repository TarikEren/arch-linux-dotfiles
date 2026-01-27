vim.opt.number=true
vim.opt.wrap=false
vim.opt.relativenumber=true
vim.opt.signcolumn='yes:1'
vim.opt.showcmd = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = {
    eol = '.',
    tab = '>-',
    trail = '~',
    nbsp = '␣',
    extends = '>',
    precedes = '<',
}
vim.o.timeoutlen = 300
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.confirm = true
vim.o.inccommand = 'split'

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
