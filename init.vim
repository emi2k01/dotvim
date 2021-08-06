let mapleader = " "

call plug#begin('~/.config/nvim/plugged')
Plug 'nvim-lua/lsp-status.nvim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf.vim'
Plug 'emi2k01/nord-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'preservim/nerdtree'
call plug#end()

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

nmap <silent> <leader>F <cmd>Files<CR>
nmap <silent> <leader>R <cmd>Rg<CR>
nmap <silent> <leader>B <cmd>Buffers<CR>
nmap <silent> <leader>M <cmd>Marks<CR>
nmap <silent> <leader>h :tabprevious<CR>
nmap <silent> <leader>l :tabnext<CR>
nmap <silent> <leader>tn :tabnew<CR>
nmap <silent> <leader><S-h> :tabmove -1<CR>
nmap <silent> <leader><S-l> :tabmove +1<CR>
nmap <silent> <leader>ne :exec "tcd " . expand("%:p:h")<CR>:exec "NERDTree " . expand("%:p:h")<CR><C-w>p
tnoremap <Esc> <C-\><C-n>

set sessionoptions-=blank
set sessionoptions+=tabpages,globals
set noshowmode
set shortmess+=c
set completeopt=menuone,noinsert,noselect
set termguicolors
set signcolumn=yes
set hidden
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set updatetime=600
set inccommand=split
set mouse=a
set tabstop=4
set shiftwidth=4
set softtabstop=0
set smarttab
set expandtab
set number
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set completeopt-=preview
set pumheight=20
set cmdheight=1
set hidden
set scrolloff=5
set nowrap
set splitbelow
set splitright
set undofile
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines
set ignorecase
set smartcase
set gdefault
set signcolumn=yes
set relativenumber
set number
set colorcolumn=90
set exrc
set secure
set clipboard=unnamed

nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> <leader><Esc> <Esc>:nohlsearch<CR><Esc>
nnoremap k gk
nnoremap j gj

set background=dark
colorscheme nord

lua << EOF
local lsp_status = require('lsp-status')
lsp_status.register_progress()
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  lsp_status.on_attach(client, bufnr)
  require'completion'.on_attach(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>aw', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>sd', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("i", "<Tab>", "v:lua.expand_tab()", { silent = true, expr = true })

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

nvim_lsp.rust_analyzer.setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
}

local function feedkeys(s)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(s, true, true, true), 'n', true)
end

function _G.expand_tab()
  if vim.fn.pumvisible() == 1 then
    if vim.fn.complete_info({"selected"})["selected"] == -1 then
      vim.api.nvim_input("<C-n><Plug>(completion_confirm_completion)")
    else
      vim.api.nvim_input("<Plug>(completion_confirm_completion)")
    end
  else
    if vim.fn["vsnip#jumpable"](1) == 1 then
        vim.api.nvim_input("<Plug>(vsnip-jump-next)")
    else
        feedkeys("<Tab>")
    end
  end
  return ""
end
EOF

let g:completion_enable_snippet = 'vim-vsnip'

smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction


let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'lspstatus' ] ]
      \ },
      \ 'component_function': {
      \   'lspstatus': 'LspStatus'
      \ },
      \ }

