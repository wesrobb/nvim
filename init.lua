-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic editor options
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.winborder = 'rounded'
vim.o.clipboard = 'unnamedplus'

-- Set PowerShell as the default shell on Windows
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.o.shell = 'pwsh'
    vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
end

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
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/nvim-mini/mini.files' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/numToStr/Comment.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
}

-- Setup colorscheme
require('vague').setup({ transparent = true })
vim.cmd('colorscheme vague')
vim.cmd(':hi statusline guibg=NONE')

-- Setup Telescope
require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
})

vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', require('telescope.builtin').live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags, { desc = 'Find help' })
vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_document_symbols, { desc = 'Find symbols' })
vim.keymap.set('n', '<leader>*', require('telescope.builtin').grep_string, { desc = 'Grep word under cursor' })

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
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    modules = {},
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
    },
})

-- Setup treesitter-context
require('treesitter-context').setup({
    enable = true,
    max_lines = 3,
    trim_scope = 'outer',
})

-- Setup which-key
require('which-key').setup()

-- Setup Comment.nvim
require('Comment').setup()

-- Setup mini.files
require('mini.files').setup()
vim.keymap.set('n', '-', function()
    require('mini.files').open()
end, { desc = 'Open file explorer' })

-- Jump to definition (same as C-])
vim.keymap.set('n', 'gd', '<C-]>', { desc = 'Jump to definition' })

-- Show diagnostic in float and copy to clipboard
vim.keymap.set('n', '<leader>e', function()
    local diags = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #diags > 0 then
        vim.fn.setreg('+', diags[1].message)
    end
    vim.diagnostic.open_float()
end, { desc = 'Show diagnostic in float and copy' })

-- Terminal keybindings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Configure makeprg
if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    vim.o.makeprg = 'pwsh -File build.ps1'
    -- MSVC error format with catch-all for non-error lines
    vim.o.errorformat = '%f(%l\\,%c): %t%*[^:]: %m,%f(%l): %t%*[^:]: %m,%+G%.%#'
else
    vim.o.makeprg = './build.sh'
    -- Use default errorformat for gcc/clang with catch-all
    vim.o.errorformat = vim.o.errorformat .. ',%+G%.%#'
end

-- Build keybinding
vim.keymap.set('n', '<leader>b', function()
    vim.cmd('make')
    vim.cmd('botright copen')
end, { desc = 'Run build script and show errors' })

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
