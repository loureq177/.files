-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.scrolloff = 8

vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.cmdheight = 0

-- Use system clipboard for yank/paste (requires wl-clipboard on Wayland)
vim.opt.clipboard = "unnamedplus"
