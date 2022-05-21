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

require('nvim-window').setup({
    normal_hl = 'WindowSwitch',
})

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
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                if vim.fn["vsnip#jumpable"](1) == 1 then
                    vim.api.nvim_input("<Plug>(vsnip-jump-next)")
                else
                    fallback()
                end
            end
        end)
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
  buf_set_keymap('n', '<leader>d', "<Cmd>Telescope diagnostics bufnr=0<CR>", opts)
  buf_set_keymap('n', '<leader>D', "<Cmd>Telescope diagnostics<CR>", opts)
  buf_set_keymap('n', '<leader>pd', "<Cmd>lua require'lspsaga.provider'.preview_definition()<CR>", opts)
  buf_set_keymap('n', '<leader>aw', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap('v', '<leader>aw', "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
  buf_set_keymap('n', 'K', "<cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>", opts)
  buf_set_keymap('n', '<C-k>', "<cmd>lua require'lspsaga.signaturehelp'.signature_help()<CR>", opts)
  buf_set_keymap('n', '<leader>rn', "<cmd>lua require'lspsaga.rename'.rename()<CR>", opts)
  buf_set_keymap('n', '<leader>dl', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)
  buf_set_keymap('n', '[d', "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  buf_set_keymap('n', ']d', "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)

  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.diagnostics.eslint,
    },
    on_attach = on_attach,
})


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

local function feedkeys(s)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(s, true, true, true), 'n', true)
end

require'lspconfig'.ccls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
}

local extension_path = '/home/emi2k01/.vscode/extensions/vadimcn.vscode-lldb-1.6.10/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

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
                },
                checkOnSave = {
                    command = "clippy"
                },
                rustfmt = {
                    extraArgs = { "+nightly" }
                }
            }
        }
    },
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path)
    },
})

require('hop').setup({})

local vimp = require('vimp')
set_keymap('n', '<leader><leader>f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
set_keymap('n', '<leader><leader>F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})

local pickers = require('telescope.builtin')
vimp.nnoremap('<leader>F', function()
    pickers.find_files()
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
}

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = false,
}

require("nvim-gps").setup()

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

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = { capabilities = capabilities, on_attach = on_attach }

    if server.name == "tsserver" then
        opts.init_options = {
            preferences = {
                includeCompletionsWithSnippetText = true,
                includeCompletionsForImportStatements = true,
            },
        }
    end

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)

local dap = require('dap')

local dap = require('dap')
dap.adapters.codelldb = function(on_adapter)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  -- CHANGE THIS!
  local cmd = '/home/emi2k01/.vscode/extensions/vadimcn.vscode-lldb-1.6.10/adapter/codelldb'

  local handle, pid_or_err
  local opts = {
    stdio = {nil, stdout, stderr},
    detached = true,
  }
  handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
    stdout:close()
    stderr:close()
    handle:close()
    if code ~= 0 then
      print("codelldb exited with code", code)
    end
  end)
  assert(handle, "Error running codelldb: " .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      local port = chunk:match('Listening on port (%d+)')
      if port then
        vim.schedule(function()
          on_adapter({
            type = 'server',
            host = '127.0.0.1',
            port = port
          })
        end)
      else
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end
  end)
  stderr:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
end

-- dap.adapters.lldb = {
--   type = 'executable',
--   command = '/usr/bin/lldb-vscode', -- adjust as needed
--   name = "lldb"
-- }

local dap = require('dap')
-- dap.configurations.cpp = {
--   {
--     name = "Launch",
--     type = "lldb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--     args = {},
-- 
--     runInTerminal = false,
--   },
-- }

local dap = require('dap')
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}


-- If you want to use this for rust and c, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/src/vscode-chrome-debug/out/src/chromeDebug.js"} -- TODO adjust
}

dap.configurations.javascript = { -- change this to javascript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}

dap.configurations.typescript = { -- change to typescript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}

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
    d = {
        name = "debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", "Set breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<CR>", "Run/Continue" },
        o = { "<cmd>lua require'dap'.step_over()<CR>", "Step over" },
        i = { "<cmd>lua require'dap'.step_into()<CR>", "Step into" },
        h = { "<cmd>lua require('dap.ui.widgets').hover()<CR>", "Hover value" },
        f = { function()
            local widgets = require('dap.ui.widgets')
            local my_sidebar = widgets.sidebar(widgets.frames)
            my_sidebar.open()
        end, "Frames" },
        s = { function()
            local widgets = require('dap.ui.widgets')
            local my_sidebar = widgets.sidebar(widgets.scopes)
            my_sidebar.open()
        end, "Scopes" },
        S = { function()
            local widgets = require('dap.ui.widgets')
            local my_sidebar = widgets.sidebar(widgets.scopes)
            my_sidebar.open()
        end, "Centered scopes" },
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
