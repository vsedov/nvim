local tools = {}
local conf = require("modules.tools.config")

tools["kristijanhusak/vim-dadbod-ui"] = {
  cmd = { "DBUIToggle", "DBUIAddConnection", "DBUI", "DBUIFindBuffer", "DBUIRenameBuffer", "DB" },
  config = conf.vim_dadbod_ui,
  requires = { "tpope/vim-dadbod", ft = { "sql" } },
  opt = true,
  setup = function()
    vim.g.dbs = {
      eraser = "postgres://postgres:password@localhost:5432/eraser_local",
      staging = "postgres://postgres:password@localhost:5432/my-staging-db",
      wp = "mysql://root@localhost/wp_awesome",
    }
  end,
}

tools["camspiers/snap"] = {
  -- event = {'CursorMoved', 'CursorMovedI'},
  -- rocks = {'fzy'},
  opt = true,
  config = conf.snap,
}

tools["editorconfig/editorconfig-vim"] = {
  opt = true,
  cmd = { "EditorConfigReload" },
  -- ft = { 'go','typescript','javascript','vim','rust','zig','c','cpp' }
}

tools["rktjmp/paperplanes.nvim"] = {
  opt = true,
  config = conf.paperplanes,
}

tools["ThePrimeagen/harpoon"] = {
  opt = true,
  config = function()
    require("harpoon").setup({
      global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
      },
    })
    require("telescope").load_extension("harpoon")
  end,
}

-- github GH ui
-- tools['pwntester/octo.nvim'] ={
--   cmd = {'Octo', 'Octo pr list'},
--   config=function()
--     require"octo".setup()
--   end
-- }

-- tools["wellle/targets.vim"] = {}
tools["TimUntersberger/neogit"] = {
  cmd = { "Neogit" },
  config = function()
    local neogit = require("neogit")
    neogit.setup({})
  end,
}
tools["liuchengxu/vista.vim"] = { cmd = "Vista", setup = conf.vim_vista, opt = true }

tools["kamykn/spelunker.vim"] = {
  opt = true,
  fn = { "spelunker#check" },
  setup = conf.spelunker,
  config = conf.spellcheck,
}
tools["rhysd/vim-grammarous"] = {
  opt = true,
  cmd = { "GrammarousCheck" },
  ft = { "markdown", "txt" },
  setup = conf.grammarous,
}

tools["plasticboy/vim-markdown"] = {
  ft = "markdown",
  requires = { "godlygeek/tabular" },
  cmd = { "Toc" },
  setup = conf.markdown,
  opt = true,
}

tools["iamcco/markdown-preview.nvim"] = {
  ft = { "markdown", "pandoc.markdown", "rmd" },
  cmd = { "MarkdownPreview" },
  setup = conf.mkdp,
  run = [[sh -c "cd app && yarn install"]],
  opt = true,
}

tools["turbio/bracey.vim"] = {
  ft = { "html", "javascript", "typescript" },
  cmd = { "Bracey", "BraceyEval" },
  run = 'sh -c "npm install --prefix server"',
  opt = true,
}

-- nvim-toggleterm.lua ?
-- tools["voldikss/vim-floaterm"] = {
--   cmd = {"FloatermNew", "FloatermToggle"},
--   setup = conf.floaterm,
--   opt = true
-- }

tools["akinsho/toggleterm.nvim"] = {
  cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
  config = function()
    require("modules.tools.toggleterm")
  end,
}

--
tools["nanotee/zoxide.vim"] = { cmd = { "Z", "Lz", "Zi" } }

tools["liuchengxu/vim-clap"] = {
  cmd = { "Clap" },
  run = function()
    vim.fn["clap#installer#download_binary"]()
  end,
  setup = conf.clap,
  config = conf.clap_after,
}

tools["wakatime/vim-wakatime"] = {}

tools["sindrets/diffview.nvim"] = {
  cmd = {
    "DiffviewOpen",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewRefresh",
  },
  config = conf.diffview,
}

tools["lewis6991/gitsigns.nvim"] = {
  config = conf.gitsigns,
  -- keys = {']c', '[c'},  -- load by lazy.lua
  opt = true,
}

tools["kdheepak/lazygit.nvim"] = {
  opt = true,
  cmd = { "LazyGit" },
  requires = "nvim-lua/plenary.nvim",
  config = function()
    vim.g.lazygit_floating_window_winblend = 2
    vim.g.lazygit_floating_window_use_plenary = 1
  end,
}

tools["brooth/far.vim"] = {
  cmd = { "Farr", "Farf" },
  run = function()
    require("packer").loader("far.vim")
    vim.cmd([[UpdateRemotePlugins]])
  end,
  config = conf.far,
  opt = true,
} -- brooth/far.vim

tools["ray-x/sad.nvim"] = {
  cmd = { "Sad" },
  requires = "ray-x/guihua.lua",
  opt = true,
  config = function()
    require("sad").setup({
      diff = "delta", -- you can use `diff`, `diff-so-fancy`
      ls_file = "fd", -- also git ls_file
      exact = false, -- exact match
    })
  end,
}

tools["ray-x/viewdoc.nvim"] = {
  requires = "ray-x/guihua.lua",
  cmd = { "Viewdoc" },
  opt = true,
  config = function()
    require("viewdoc").setup({ debug = true, log_path = "~/tmp/neovim_debug.log" })
  end,
}

-- early stage...
-- tools['tanvirtin/vgit.nvim'] = { -- gitsign has similar features
--   setup = function()
--     vim.o.updatetime = 2000
--   end,
--   cmd = {'VGit'},
--   -- after = {"telescope.nvim"},
--   opt = true,
--   config = conf.vgit
-- }

-- tools["tpope/vim-fugitive"] = {
--   cmd = {"Gvsplit", "Git", "Gedit", "Gstatus", "Gdiffsplit", "Gvdiffsplit"},
--   opt = true
-- }

tools["rmagatti/auto-session"] = { config = conf.session }

tools["rmagatti/session-lens"] = {
  cmd = "SearchSession",
  after = { "telescope.nvim" },
  config = function()
    require("packer").loader("telescope.nvim")
    require("telescope").load_extension("session-lens")
    require("session-lens").setup({
      path_display = { "shorten" },
      theme_conf = { border = true },
      previewer = true,
    })
  end,
}

tools["kevinhwang91/nvim-bqf"] = {
  opt = true,
  event = { "CmdlineEnter", "QuickfixCmdPre" },
  config = conf.bqf,
}

tools["vim-test/vim-test"] = {
  opt = true,
}

tools["rcarriga/vim-ultest"] = {
  requires = { "vim-test/vim-test", opt = true },
  run = ":UpdateRemotePlugins",
  config = conf.ultest,
  opt = true,
}

-- lua require'telescope'.extensions.project.project{ display_type = 'full' }
tools["ahmedkhalf/project.nvim"] = {
  opt = true,
  after = { "telescope.nvim" },
  -- keys = { "<M>", "<Leader>" },
  config = conf.project,
}

tools["jvgrootveld/telescope-zoxide"] = {
  opt = true,
  -- keys = { "<M>", "<Leader>" },
  after = { "telescope.nvim" },
  config = function()
    require("utils.telescope")
    require("telescope").load_extension("zoxide")
  end,
}

tools["AckslD/nvim-neoclip.lua"] = {
  opt = true,
  -- keys = { "<M>", "<Leader>" },
  after = { "telescope.nvim" },
  requires = { "tami5/sqlite.lua", module = "sqlite" },
  config = function()
    require("utils.telescope")
    require("neoclip").setup({
      history = 1000,
      enable_persistant_history = true,
      db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
      filter = nil,
      preview = true,
      default_register = "+",
      content_spec_column = true,
      on_paste = {
        set_reg = true,
      },
      keys = {
        telescope = {
          i = {
            select = "<cr>",
            paste = "<c-p>",
            -- C-P and C-;
            paste_behind = "<c-;>",
            custom = {},
          },
          n = {
            select = "<cr>",
            paste = "p",
            paste_behind = "P",
          },
        },
      },
    })
  end,
}

-- This can be lazy loaded probably, figure out how ?
tools["camspiers/animate.vim"] = {
  opt = true,
}

tools["nvim-telescope/telescope-frecency.nvim"] = {
  keys = { "<M>", "<Leader><Leader><Leader>" },
  after = { "telescope.nvim" },
  requires = { "tami5/sqlite.lua", module = "sqlite", opt = true },
  opt = true,
  config = function()
    local telescope = require("telescope")
    telescope.load_extension("frecency")
    telescope.setup({
      extensions = {
        frecency = {
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*" },
          disable_devicons = false,
          workspaces = {
            -- ["conf"] = "/home/my_username/.config",
            -- ["data"] = "/home/my_username/.local/share",
            -- ["project"] = "/home/my_username/projects",
            -- ["wiki"] = "/home/my_username/wiki"
          },
        },
      },
    })
    -- vim.api.nvim_set_keymap("n", "<leader><leader>p", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", {noremap = true, silent = true})
  end,
}

tools["chentau/marks.nvim"] = {
  opt = true,
  event = { "BufReadPost" },
  branch = "master",
  config = function()
    require("marks").setup({
      default_mappings = true,
      builtin_marks = { "<", ">", "^" },
      -- whether movements cycle back to the beginning/end of buffer. default true
      cyclic = true,
      -- whether the shada file is updated after modifying uppercase marks. default false
      force_write_shada = false,
      -- how often (in ms) to redraw signs/recompute mark positions.
      -- higher values will have better performance but may cause visual lag,
      -- while lower values may cause performance penalties. default 150.
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      bookmark_0 = {
        sign = "⚑",
        virt_text = "BookMarks",
      },
    })
  end,
}

tools["fladson/vim-kitty"] = {
  opt = true,
}

tools["relastle/vim-nayvy"] = {
  ft = "python",

  config = function()
    vim.g.nayvy_import_config_path = "$HOME/nayvy.py"
  end,
}

-- Dont know why, but i kinda enjoy this
tools["sQVe/sort.nvim"] = {
  cmd = "Sort",
  config = function()
    require("sort").setup({
      -- Input configuration here.
      -- Refer to the configuration section below for options.
    })
  end,
}
return tools
