local tokyonight_opts = {
    style = "night",
    styles = {
        keywords = { italic = false },
    }
}

local function tokyonight_config()
    require("tokyonight").setup(tokyonight_opts)
    vim.cmd([[colorscheme tokyonight]])
end

return {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = tokyonight_config,
}
