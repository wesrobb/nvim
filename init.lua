local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.scrolloff = 4
vim.o.number = true
vim.o.expandtab = true

local plugins = {
    { "ellisonleao/gruvbox.nvim", priority = 1000 },
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    "beauwilliams/focus.nvim",
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
}
require("lazy").setup(plugins)

-- Gruvbox
require("gruvbox").setup({
    italic = {
        strings = false,
    },
})
vim.cmd("colorscheme gruvbox")

-- Telescope
require("telescope").load_extension('fzf')
require("telescope").setup({
    defaults = {
        layout_config = {
            horizontal = {
                width = 0.9
            },
        },
    },
})
local ts_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', ts_builtin.find_files, {})
vim.keymap.set('n', '<leader>s', ts_builtin.grep_string, {})

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end


local keymap = vim.keymap.set
local ts_opts = { noremap = true, silent = true }

keymap('n', '<leader>g', ':Telescope current_buffer_fuzzy_find<cr>', ts_opts)
keymap('v', '<leader>g', function()
	local text = vim.getVisualSelection()
	ts_builtin.current_buffer_fuzzy_find({ default_text = text })
end, ts_opts)

keymap('n', '<leader>G', ':Telescope live_grep<cr>', ts_opts)
keymap('v', '<leader>G', function()
	local text = vim.getVisualSelection()
	ts_builtin.live_grep({ default_text = text })
end, ts_opts)

-- Telescope file browser
require("telescope").load_extension("file_browser")
vim.api.nvim_set_keymap( "n", "<leader>b", ":Telescope file_browser<CR>", { noremap = true })

-- Treesitter
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
})

-- LSP + Mason
require("mason").setup()
require("mason-lspconfig").setup()

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>fo', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require("lspconfig").powershell_es.setup {}
require("lspconfig").azure_pipelines_ls.setup {}
require("lspconfig").bicep.setup {}
require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
        },
    },
}

-- Neovide
if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono NFM:h14"
    vim.g.neovide_cursor_animation_length = 0.05
    vim.g.neovide_cursor_trail_size = 0.6

    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set("n", "<m-=>", function()
        print("here")
        change_scale_factor(1.25)
    end)
    vim.keymap.set("n", "<m-->", function()
        print("here")
        change_scale_factor(1/1.25)
    end)
end

-- Focus
require("focus").setup()
