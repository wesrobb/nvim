-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.pack.add {
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    { src = 'https://github.com/saghen/blink.cmp' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-refactor' },
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/nvim-mini/mini.files' },
}

-- Setup colorscheme
require('tokyonight').setup({
    style = 'night',  -- Options: 'storm', 'moon', 'night', 'day'
    transparent = false,
    styles = {
        comments = { italic = true },
    },
})
vim.cmd.colorscheme('tokyonight')

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
    ensure_installed = {
        "lua_ls",
        "stylua",
	"clangd",
    }
})

-- Configure diagnostics to show virtual text
vim.diagnostic.config({
    virtual_lines = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Setup blink.cmp
require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show', 'hide' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
    sources = {
        default = { 'lsp', 'path', 'buffer' },
    },
})

-- Setup treesitter
require('nvim-treesitter.configs').setup({
    ensure_installed = { 'c', 'lua' },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            scope_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                [']m'] = '@function.outer',
                [']c'] = '@class.outer',
                [']a'] = '@parameter.inner',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']C'] = '@class.outer',
                [']A'] = '@parameter.inner',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[c'] = '@class.outer',
                ['[a'] = '@parameter.inner',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[C'] = '@class.outer',
                ['[A'] = '@parameter.inner',
            },
        },
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = 'grr',
            },
        },
    },
})

-- Setup treesitter-context
require('treesitter-context').setup({
    enable = true,
    max_lines = 3,
    trim_scope = 'outer',
})

-- Setup mini.files
require('mini.files').setup()
vim.keymap.set('n', '-', function()
    require('mini.files').open()
end, { desc = 'Open file explorer' })

-- Build keybinding
vim.keymap.set('n', '<leader>b', function()
    local build_cmd
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
        build_cmd = 'pwsh -File build.ps1'
    else
        build_cmd = './build.sh'
    end
    vim.cmd('botright split | terminal ' .. build_cmd)
end, { desc = 'Run build script' })

-- Run keybinding
vim.keymap.set('n', '<leader>r', function()
    local run_cmd
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
        run_cmd = 'pwsh -File run.ps1'
    else
        run_cmd = './run.sh'
    end
    vim.cmd('botright split | terminal ' .. run_cmd)
end, { desc = 'Run application' })

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})
