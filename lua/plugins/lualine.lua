local function lualine_config()
    -- local custom_gruvbox = require'lualine.themes.gruvbox'
    -- custom_gruvbox.normal.c.bg = '#222233'

    local lualine_opts = {
        options = {
            icons_enabled = true,
            -- theme  = custom_gruvbox,
            -- theme = 'auto',
            -- theme = 'Tomorrow',
            -- theme = 'powerline',
            theme = 'gruvbox_dark',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {{'filename', file_status=true, path=2}},  -- path: 0 -> just filename; 1 -> relative path; 2 -> absolute path
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    }

    require('lualine').setup(lualine_opts)
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = lualine_config
}
