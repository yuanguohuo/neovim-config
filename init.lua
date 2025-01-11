--++++++++++++++++++++++++++++++++++++++++ basic configurations begin ++++++++++++++++++++++++++++++++++++++++
-- vim options :help lua-vim-options
--     init.lua            vimrc/init.vim
--     vim.o.{opt}  =      set {opt} =
--     vim.go.{opt} =      setglobal {opt} =
--     vim.bo.{opt} =      setlocal {opt}  =   for buffer-scoped options
--     vim.wo.{opt} =      setlocal {opt}  =   for window-scoped options (can be double indexed)

-- copy on select
vim.o.mouse = ''

-- line number
vim.o.number = true

-- when 'confirm' is on, certain operations that would normally fail because of unsaved changes
-- to a buffer, e.g. ":q" and ":e", instead raise a dialog asking if you wish to save the current
-- file(s). You can still use a ! to unconditionally |abandon| a buffer.
vim.o.confirm = true

-- whether a window has a status line.
--  0: A window never has a status line;
--  1: If there are more than one windows, each has a status line;
--  2: A window always has a status line;
vim.o.laststatus = 2

vim.o.so = 5

-- execute vim-script commands. :help lua-vim
vim.cmd([[
    filetype on
    filetype plugin on
    filetype indent on
    syntax on
]])

-- variables:
--     init.lua            vimrc/init.vim
--     vim.g.{var} =       let g:{var} =    global variables
--     vim.b.{var} =       let b:{var} =    buffer variables
--     vim.w.{var} =       let w:{var} =    window variables
--     vim.t.{var} =       let t:{var} =    tabpage variables
--     vim.v.{var} =       let v:{var} =    predefined Vim variables
--     vim.env.{e} =       environment variables
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- mappings
vim.keymap.set('', 'J', '16j')
vim.keymap.set('', 'K', '16k')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {desc = 'switch windonw left'})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {desc = 'switch windonw right'})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {desc = 'switch windonw up'})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {desc = 'switch windonw down'})

-- auto command: commands to be executed automatically
--     - when reading or writing a file,
--     - when entering or leaving a buffer or window,
--     - and when exiting Vim.
-- for example, you can create an autocommand to set the 'cindent' option for
-- files matching *.c;

local programmer = vim.api.nvim_create_augroup('programmer_auto_group', { clear = true })

local function setup_opts_by_ft(expandtab, tabstop, shiftwidth, textwidth)
    vim.o.expandtab  = expandtab
    vim.o.tabstop    = tabstop
    vim.o.shiftwidth = shiftwidth
    vim.o.textwidth  = textwidth
end

vim.api.nvim_create_autocmd(
    'FileType',
    {
        pattern = "*",
        group = programmer,
        callback = function()
            local ft = vim.bo.filetype
            if ft == "c" then
                setup_opts_by_ft(true, 4, 4, 120)
            elseif ft == "cpp" then
                setup_opts_by_ft(true, 4, 4, 120)
            elseif ft == "lua" then
                setup_opts_by_ft(true, 4, 4, 120)
            elseif ft == "sh" then
                setup_opts_by_ft(true, 4, 4, 120)
            elseif ft == "vim" then
                setup_opts_by_ft(true, 4, 4, 120)
            elseif ft == "xml" then
                setup_opts_by_ft(true, 4, 4, nil)
            elseif ft == "markdown" then
                setup_opts_by_ft(true, 4, 4, nil)
            elseif ft == "text" then
                setup_opts_by_ft(false, 4, 4, nil)
            else
                setup_opts_by_ft(false, 4, 4, nil)
            end
        end
    }
)

-- :help restore-cursor
vim.api.nvim_create_autocmd(
    'BufReadPost',
    {
        pattern = "*",
        group = programmer,
        callback = function()
            local c = vim.fn.line([['"]])
            local m = vim.fn.line("$")
            if c > 0 and c <= m then
                vim.cmd([[normal! g`"]])
            end
        end
    }
)

-- :help skeleton
vim.api.nvim_create_autocmd('BufNewFile', {pattern = "*.c",  group = programmer, command = '0r ~/.config/nvim/templates/skeleton.c'})
vim.api.nvim_create_autocmd('BufNewFile', {pattern = "*.sh", group = programmer, command = '0r ~/.config/nvim/templates/skeleton.sh'})
vim.api.nvim_create_autocmd('BufNewFile', {pattern = {"*.cc", "*.cxx", "*.cpp"},  group = programmer, command = '0r ~/.config/nvim/templates/skeleton.cpp'})

local init_fname = '~/.config/nvim/init.lua'
local function switch_to_init_buf()
    local window_number = vim.fn.bufwinnr(init_fname)
    if window_number ~= -1 then
        -- found the window of "init_fname" in current tab, go to it!
        vim.cmd(tostring(window_number) .. "wincmd w")  -- :help wincmd  go to window {window_number}
        return
    end

    -- not found in current tab, search all tabs
    -- switch to the 1st tab
    vim.cmd[[tabfirst]]
    local tabn = 1
    while tabn < vim.fn.tabpagenr('$') do
        window_number = vim.fn.bufwinnr(init_fname)
        if window_number ~= -1 then
            -- found the window of "init_fname" in tabn, go to it!
            vim.cmd("normal " .. tostring(tabn) .. "gt")    -- :help gt      go to tab page {tabn}
            vim.cmd(tostring(window_number) .. "wincmd w")  -- :help wincmd  go to window {window_number}
            return
        end
        vim.cmd[[tabnext]]
        tabn = tabn + 1
    end

    -- not found in any tab, create a new tab for it
    vim.cmd("tabnew " .. init_fname)
end

local function re_execute_init()
    vim.cmd("source " .. init_fname)
end

vim.keymap.set('', '<Leader>ee', switch_to_init_buf, {silent=true})
vim.keymap.set('', '<Leader>ss', re_execute_init, {silent=true})

-- load lazy (the plugin manager) and plugins
require("config.lazy")
