vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'itchyny/lightline.vim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'preservim/nerdtree'
  use 'tpope/vim-fugitive'
  use 'phaazon/hop.nvim'
  use 'mattn/emmet-vim'
  use 'kana/vim-textobj-user'
  use 'Julian/vim-textobj-variable-segment'
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
  use {
      'neoclide/coc.nvim',
      branch = "release",
  }
  use 'gcmt/taboo.vim'
  use 'lukas-reineke/indent-blankline.nvim'
  use {
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter"
  }
  use 'ChristianChiarulli/nvcode-color-schemes.vim'
  use 'mhinz/vim-crates'
  use "folke/which-key.nvim"
  use 'tpope/vim-sleuth'
  use 'yuezk/vim-js'
  use 'MaxMEllon/vim-jsx-pretty'
  use 'Shatur/neovim-ayu'

end)
