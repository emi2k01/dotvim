require('plugins')

vim.g.mapleader = " "
vim.api.nvim_command("colorscheme nord")

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
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.number = true
vim.wo.list = true
vim.wo.listchars = vim.o.listchars
vim.wo.wrap = false
vim.wo.relativenumber = true
vim.wo.colorcolumn = "110"

vim.g.NERDTreeUseTcd = 1
vim.g.startify_session_persistence = 1

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local cmp = require'cmp'
require('lspsaga').init_lsp_saga()

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true})
            else
                if vim.fn["vsnip#jumpable"](1) == 1 then
                    vim.api.nvim_input("<Plug>(vsnip-jump-next)")
                else
                    fallback()
                end
            end
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'neorg' },
    },
})

local function set_keymap(...) vim.api.nvim_set_keymap(...) end

local on_attach = function(client, bufnr)
  lsp_status.on_attach(client)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', "<Cmd>Telescope lsp_type_definitions<CR>", opts)
  buf_set_keymap('n', 'gd', "<Cmd>Telescope lsp_definitions<CR>", opts)
  buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', '<leader>sd', "<Cmd>Telescope lsp_document_diagnostics<CR>", opts)
  buf_set_keymap('n', '<leader>sD', "<Cmd>Telescope lsp_workspace_diagnostics<CR>", opts)
  buf_set_keymap('n', '<leader>pd', "<Cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
  buf_set_keymap('n', '<leader>aw', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap('v', '<leader>aw', "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
  buf_set_keymap('n', 'K', "<cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>", opts)
  buf_set_keymap('n', '<C-k>', "<cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>", opts)
  buf_set_keymap('n', '<leader>rn', "<cmd>lua require'lspsaga.rename'.rename()<CR>", opts)
  buf_set_keymap('n', '<leader>dl', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)
  buf_set_keymap('n', '[g', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
  buf_set_keymap('n', ']g', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)

  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
capabilities = vim.tbl_extend('keep', capabilities, { experimental = { snippetTextEdit = false }})

-- local function feedkeys(s)
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(s, true, true, true), 'n', true)
-- end

-- function _G.expand_tab()
--     if cmp.visible() then
--         cmp.confirm({ select = true })
--     else
--         if vim.fn["vsnip#jumpable"](1) == 1 then
--             vim.api.nvim_input("<Plug>(vsnip-jump-next)")
--         else
--             feedkeys("<Tab>")
--         end
--     end
--     return ""
-- end
-- 
-- set_keymap("i", "<Tab>", "v:lua.expand_tab()", { silent = true, expr = true })

require'lspconfig'.ccls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
}

require('rust-tools').setup({
    server = {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                diagnostics = {
                    disabled = { "missing-unsafe" }
                },
                experimental = {
                    procAttrMacros = true
                }
            }
        }
    }
})

require('hop').setup({})

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
	ensure_installed = { "norg", "haskell", "cpp", "c", "javascript", "rust" },
}

local luadev = require("lua-dev").setup({
    lspconfig = {
        cmd = { "lua-language-server" },
        on_attach = on_attach,
    }
})
local lspconfig = require('lspconfig')
lspconfig.sumneko_lua.setup(luadev)
lspconfig.html.setup({
    capabilities = capabilities,
})
