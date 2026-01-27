return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        vim.keymap.set('n', '<leader>b', ':NvimTreeToggle<CR>', {
            noremap = true
        })
        require("nvim-tree").setup()
    end

}
