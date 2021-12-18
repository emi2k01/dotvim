vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tami5/lspsaga.nvim'
  use 'simrat39/symbols-outline.nvim'
  use 'nvim-lua/lsp-status.nvim'
  use 'itchyny/lightline.vim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'emi2k01/nord-vim'
  use 'neovim/nvim-lspconfig'
  use 'preservim/nerdtree'
  use 'tpope/vim-fugitive'
  use 'phaazon/hop.nvim'
  use 'mattn/emmet-vim'
  use 'kana/vim-textobj-user'
  use 'Julian/vim-textobj-variable-segment'
  use 'simrat39/rust-tools.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-vsnip'
  use 'folke/lua-dev.nvim'
  use 'mhinz/vim-startify'
  use 'svermeulen/vimpeccable'
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }
  use  {
    "nvim-neorg/neorg",
    config = function()
        require('neorg').setup {
            load = {
                ["core.defaults"] = {}, -- Load all the default modules
                ["core.norg.concealer"] = {}, -- Allows for use of icons
                ["core.norg.dirman"] = { -- Manage your directories with Neorg
                    config = {
                        workspaces = {
                            my_workspace = "~/.local/share/neorg"
                        }
                    }
                },
                ["core.norg.completion"] = {
                    config = {
                        engine = 'nvim-cmp'
                    }
                }
            },
        }
    end,
    requires = "nvim-lua/plenary.nvim"
  }
  use 'jbyuki/nabla.nvim'
  use 'junegunn/goyo.vim'
  use 'williamboman/nvim-lsp-installer'
  -- use {
  --     'neoclide/coc.nvim',
  --     branch = "release",
  -- }
  use 'gcmt/taboo.vim'
  use 'lukas-reineke/indent-blankline.nvim'
  use {
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter"
  }
  use 'ChristianChiarulli/nvcode-color-schemes.vim'

end)
