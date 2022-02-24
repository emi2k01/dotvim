require('plugins')

vim.g.mapleader = " "

vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.updatetime = 600
vim.o.inccommand = "split"
vim.o.mouse = "a"
vim.o.listchars = "tab:» ,extends:›,precedes:‹,nbsp:·,trail:·"
vim.o.completeopt = "menuone,noselect"
vim.o.pumheight = 20
vim.o.cmdheight = 1
vim.o.hidden = true
vim.o.scrolloff = 5
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.gdefault = true
vim.o.undofile = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.formatoptions = "croqnljb"

vim.bo.undofile = vim.o.undofile
vim.bo.expandtab = vim.o.expandtab
vim.bo.shiftwidth = vim.o.shiftwidth
vim.bo.tabstop = vim.o.tabstop
vim.bo.formatoptions = vim.o.formatoptions

vim.wo.signcolumn = "yes"
vim.wo.foldmethod = "indent"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.number = true
vim.wo.list = true
vim.wo.listchars = vim.o.listchars
vim.wo.wrap = false
vim.wo.relativenumber = true
vim.wo.colorcolumn = "110"

vim.g.NERDTreeUseTcd = 1
vim.g.startify_session_persistence = 1

require('hop').setup({})

local function set_keymap(...) vim.api.nvim_set_keymap(...) end
local vimp = require('vimp')
set_keymap('n', '<leader><leader>f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
set_keymap('n', '<leader><leader>F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})

local pickers = require('telescope.builtin')
vimp.nnoremap('<leader>F', function()
    pickers.find_files()
end)
vimp.nnoremap('<leader>R', function()
    pickers.live_grep()
end)
vimp.nnoremap('<leader>B', function()
    pickers.buffers()
end)
vimp.nnoremap('<leader>M', function()
    pickers.marks()
end)

set_keymap('n', '<leader><Esc>', "<Esc>:noh<CR><Esc>", {})
set_keymap('n', 'n', "nzz", {})
set_keymap('n', 'N', "Nzz", {})
set_keymap('n', '*', "*zz", {})
set_keymap('n', '#', "#zz", {})
set_keymap('n', 'j', "gj", {})
set_keymap('n', 'k', "gk", {})

set_keymap('n', '<leader>l', "<cmd>tabnext<CR>", {})
set_keymap('n', '<leader>h', "<cmd>tabprevious<CR>", {})
set_keymap('n', '<leader>tn', "<cmd>tabnew<CR>", {})
set_keymap('n', '<leader><S-l>', "<cmd>tabmove +1<CR>", {})
set_keymap('n', '<leader><S-h>', "<cmd>tabmove -1<CR>", {})

set_keymap('n', '<leader>cd', ':exec "tcd " . expand("%:p:h")<CR>', {silent = true})
set_keymap('n', '<leader>ne', '<cmd>NERDTreeToggle<CR>', {})

local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}
require('nvim-treesitter.configs').setup {
    ensure_installed = { "norg", "haskell", "cpp", "c", "javascript", "rust", "css" },
    highlight = {
        enable = true
    },
}

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = false,
}

require("nvim-gps").setup()

local previewers = require('telescope.previewers')
local builtin = require('telescope.builtin')
local conf = require('telescope.config')

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
  if entry.status == '??' or 'A ' then
      return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value }
    end
    return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!', '--', entry.current_file }
  end
}

my_git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = {
    delta,
    previewers.git_commit_message.new(opts),
    previewers.git_commit_diff_as_was.new(opts),
  }

  builtin.git_bcommits(opts)
end


my_git_status = function(opts)
  opts = opts or {}
  opts.previewer = delta

  builtin.git_status(opts)
end

local wk = require('which-key')

wk.setup {
}

wk.register({
    g = {
        name = "Git",
        s = { my_git_status, "Status" }
    },
    r = {
        name = "rust",
        h = { "<cmd>lua require'rust-tools.hover_actions'.hover_actions()<CR>", "Hover actions" },
        e = { "<cmd>lua require'rust-tools.expand_macro'.expand_macro()<CR>", "Expand macro" },
        d = { "<cmd>RustDebuggables<CR>", "Debuggables" },
        r = { "<cmd>RustReloadWorkspace<CR>", "Reload workspace" },
        p = { "<cmd>RustParentModule<CR>", "Parent module" },
    }
}, { prefix = "," })
