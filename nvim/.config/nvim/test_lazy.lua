local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = {
        { "folke/flash.nvim" },
        { "flash.nvim", enabled = false }
    }
})
local f = io.open("lazy_output.txt", "w")
for name, p in pairs(require("lazy.core.config").plugins) do
    f:write(name .. ": " .. tostring(p.dir) .. "\n")
end
f:close()
