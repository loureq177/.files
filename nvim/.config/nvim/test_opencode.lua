local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = {
        { "nickjvandyke/opencode.nvim" }
    }
})
local opencode = require("opencode")
for k, v in pairs(opencode) do
    print(k, type(v))
end
