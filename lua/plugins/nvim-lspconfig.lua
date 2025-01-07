local ccls_opts = {
    cmd = {'ccls', '--log-file=' .. os.getenv("HOME") .. '/ccls/log'},
    filetypes = {
        'c',
        'cpp',
        'objc',
        'objcpp','cuda'
    },

    offset_encoding = 'utf-32',
    -- ccls does not support sending a null root directory
    single_file_support = false,

    root_dir = function(fname)
        return require("lspconfig.util").root_pattern('compile_commands.json', '.ccls')(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,

    init_options = {
        compilationDatabaseDirectory = "build",
        index = {
            threads = 0,
        },
        clang = {
            excludeArgs = { "-frounding-math"},
        },
        cache = {
            directory = os.getenv("HOME") .. '/ccls/cache',
        },
    },

    capabilities = require('cmp_nvim_lsp').default_capabilities(),
}


return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")

        lspconfig.ccls.setup(ccls_opts)

        vim.opt.signcolumn = 'yes'
    end
}
