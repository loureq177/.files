-- return {
--    { "akinsho/bufferline.nvim", enabled = false },
-- }
return {
    -- Inne pluginy (jeśli masz, np. wyłączony bufferline z poprzedniego kroku)
    {
        "folke/snacks.nvim",
        opts = {
            terminal = {
                win = {
                    wo = {
                        winbar = "", -- Tutaj Snacks włączał ten pasek, więc go pacyfikujemy
                    },
                },
            },
        },
    },
}
