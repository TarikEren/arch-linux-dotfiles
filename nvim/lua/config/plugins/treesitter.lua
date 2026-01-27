return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    main = "nvim-treesitter.config",
    opts = {
        "bash",
        "c",
        "diff",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc"
    },
    autoinstall = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
    ui = {
        icons = vim.g.have_nerd_font and {}
    }
}
