return {
    "neovim/nvim-lspconfig",
    config = function()
        local lsp_conf     = require("lspconfig")
        local lsp_util     = require("lspconfig.util")
        local user_home    = os.getenv("HOME")
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local ccls_opts = {
            cmd = {'ccls', '--log-file=' .. user_home .. '/ccls/log'},
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
                return lsp_util.root_pattern('compile_commands.json', '.ccls')(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
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
                    directory = user_home .. '/ccls/cache',
                },
            },

            capabilities = capabilities,
        }

        lsp_conf.ccls.setup(ccls_opts)
    end
}
