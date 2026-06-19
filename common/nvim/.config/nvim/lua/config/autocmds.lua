-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text" },
    callback = function()
        vim.opt_local.spell = false
        vim.opt_local.textwidth = 0
        vim.opt_local.formatoptions:remove("t")
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

local theme_file = vim.fn.expand("$HOME/.cache/theme-mode")
local function apply_theme()
    local mode = vim.fn.filereadable(theme_file) == 1 and vim.fn.readfile(theme_file)[1] or "dark"
    local colorscheme = mode == "light" and "tokyonight-day" or "tokyonight-moon"
    if vim.g.colors_name ~= colorscheme then
        vim.cmd.colorscheme(colorscheme)
    end
end

apply_theme()

local timer = vim.uv.new_fs_event()
timer:start(theme_file, {}, vim.schedule_wrap(function()
    apply_theme()
end))
