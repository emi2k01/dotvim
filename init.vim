lua << EOF
  require('config')
EOF

set completeopt=menuone,noinsert,noselect
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
      \             [ 'readonly', 'relativepath', 'modified', 'lspstatus' ] ]
      \ },
      \ 'component_function': {
      \   'lspstatus': 'LspStatus'
      \ },
      \ }

nmap <leader>T <cmd>NERDTreeToggle<CR>
nmap <leader>so <cmd>SymbolsOutline<CR>
imap <expr> <C-Space> compe#complete()
