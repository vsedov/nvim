local editor = {}

local conf = require("modules.editor.config")

-- alternatives: steelsojka/pears.nvim
-- windwp/nvim-ts-autotag  'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue'
-- windwp/nvim-autopairs

editor["junegunn/vim-easy-align"] = { opt = true, cmd = "EasyAlign" }

editor["windwp/nvim-autopairs"] = {
  -- keys = {{'i', '('}},
  -- keys = {{'i'}},
  requires = "nvim-treesitter",
  after = { "nvim-cmp" }, -- "nvim-treesitter", nvim-cmp "nvim-treesitter", coq_nvim
  -- event = "InsertEnter",  --InsertCharPre
  -- after = "hrsh7th/nvim-compe",
  config = conf.autopairs,
  opt = true,
}

editor["kana/vim-niceblock"] = {
  opt = true,
}

-- I like this plugin, but 1) offscreen context is slow
-- 2) it not friendly to lazyload and treesitter startup
-- editor["andymass/vim-matchup"] = {
--   opt = true,
--   event = {"CursorMoved", "CursorMovedI"},
--   cmd = {'MatchupWhereAmI?'},
--   config = function()
--     vim.g.matchup_enabled = 1
--     vim.g.matchup_surround_enabled = 1
--     -- vim.g.matchup_transmute_enabled = 1
--     vim.g.matchup_matchparen_deferred = 1
--     vim.g.matchup_matchparen_offscreen = {method = 'popup'}
--     vim.cmd([[nnoremap <c-s-k> :<c-u>MatchupWhereAmI?<cr>]])
--   end
-- }

editor["ggandor/lightspeed.nvim"] = {
  as = "lightspeed",
  event = "BufReadPost",
  opt = true,
  config = conf.lightspeed,
}

editor["rlane/pounce.nvim"] = {
  cmd = { "Pounce" },
  opt = true,
  config = function()
    require("pounce").setup({
      accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
      debug = false,
    })
  end,
}

--max397574
editor["max397574/which-key.nvim"] = {
  opt = true,
  after = "nvim-treesitter",
  config = function()
    require("modules.editor.which_key")
  end,
}

-- -- HOP BROKEN
-- editor["indianboy42/hop-extensions"] = { after = "hop", opt = true }
-- editor["phaazon/hop.nvim"] = {
--   as = "hop",
--   cmd = { "HopWord", "HopWordBC", "HopWordAC", "HopLineStartAC", "HopLineStartBC", "HopeLine" },
--   config = function()
--     require("hop").setup({ keys = "adghklqwertyuiopzxcvbnmfjADHKLWERTYUIOPZXCVBNMFJ1234567890" })
--   end,
-- }

editor["blackCauldron7/surround.nvim"] = {
  keys = { "<F3>" },
  config = function()
    require("surround").setup({
      mappings_style = "sandwich",
      pairs = {
        nestable = {
          { "(", ")" },
          { "[", "]" },
          { "{", "}" },
          { "/", "/" },
          {
            "*",
            "*",
          },
        },
        linear = { { "'", "'" }, { "`", "`" }, { '"', '"' } },
      },
      prefix = "<F3>",
    })
  end,
}

-- nvim-colorizer replacement
editor["rrethy/vim-hexokinase"] = {
  -- ft = { 'html','css','sass','vim','typescript','typescriptreact'},
  config = conf.hexokinase,
  run = "make hexokinase",
  opt = true,
  cmd = { "HexokinaseTurnOn", "HexokinaseToggle" },
}

-- Its hard for this because binds are weird
editor["booperlv/nvim-gomove"] = {
  event = { "CursorMoved", "CursorMovedI" },
  opt = true,
  config = conf.gomove,
}

-- editor["kevinhwang91/nvim-hlslens"] = {
--   -- keys = {"/", "?", '*', '#'}, --'n', 'N', '*', '#', 'g'
--   -- opt = true,
--   -- config = conf.hlslens
-- }

editor["mg979/vim-visual-multi"] = {
  keys = {
    "<Ctrl>",
    "<M>",
    "<C-n>",
    "<C-n>",
    "<M-n>",
    "<S-Down>",
    "<S-Up>",
    "<M-Left>",
    "<M-i>",
    "<M-Right>",
    "<M-D>",
    "<M-Down>",
    "<C-d>",
    "<C-Down>",
    "<S-Right>",
    "<C-LeftMouse>",
    "<M-LeftMouse>",
    "<M-C-RightMouse>",
  },
  opt = true,
  setup = conf.vmulti,
}

-- Currently needs to be calle , not sure if i have to lazy load this or not.
editor["andweeb/presence.nvim"] = {
  opt = true,
  config = conf.discord,
  requires = "plenary.nvim",
}

editor["beauwilliams/focus.nvim"] = {
  cmd = { "FocusNicely", "FocusToggle", "FocusEnable" },
  event = "InsertEnter",
  config = function()
    require("focus").setup({
      cursorline = false,
      number = false,
      signcolumn = false,
      colorcolumn = { enable = true, width = tonumber(vim.o.colorcolumn) },
      excluded_filetypes = { "toggleterm", "SidebarNvim" },
    })
  end,
}

-- REMOVED FTERM

-- NORMAL mode:
-- `gcc` - Toggles the current line using linewise comment
-- `gbc` - Toggles the current line using blockwise comment
-- `[count]gcc` - Toggles the number of line given as a prefix-count
-- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- `gb[count]{motion}` - (Op-pending) Toggles the region using linewise comment

-- VISUAL mode:
-- `gc` - Toggles the region using linewise comment
-- `gb` - Toggles the region using blockwise comment

-- NORMAL mode
-- `gco` - Insert comment to the next line and enters INSERT mode
-- `gcO` - Insert comment to the previous line and enters INSERT mode
-- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- NORMAL mode
-- `g>[count]{motion}` - (Op-pending) Comments the region using linewise comment
-- `g>c` - Comments the current line using linewise comment
-- `g>b` - Comments the current line using blockwise comment
-- `g<[count]{motion}` - (Op-pending) Uncomments the region using linewise comment
-- `g<c` - Uncomments the current line using linewise comment
-- `g<b`- Uncomments the current line using blockwise comment

-- VISUAL mode
-- `g>` - Comments the region using single line
-- `g<` - Unomments the region using single line

-- `gcw` - Toggle from the current cursor position to the next word
-- `gc$` - Toggle from the current cursor position to the end of line
-- `gc}` - Toggle until the next blank line
-- `gc5l` - Toggle 5 lines after the current cursor position
-- `gc8k` - Toggle 8 lines before the current cursor position
-- `gcip` - Toggle inside of paragraph
-- `gca}` - Toggle around curly brackets

-- # Blockwise

-- `gb2}` - Toggle until the 2 next blank line
-- `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
-- `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

editor["numToStr/Comment.nvim"] = {
  keys = { "g", "<ESC>" },
  config = conf.comment,
}

-- TODO do shit to this
editor["LudoPinelli/comment-box.nvim"] = {
  keys = { "<Leader>cb", "<Leader>cc", "<Leader>cl", "<M-p>" },
  cmd = { "CBlbox", "CBcbox", "CBline", "CBcatalog" },
  opt = true,
  config = conf.comment_box,
}
-- copy paste failed in block mode when clipboard = unnameplus"
editor["bfredl/nvim-miniyank"] = {
  keys = { "p", "y", "<C-v>" },
  opt = true,
  setup = function()
    vim.api.nvim_command("map p <Plug>(miniyank-autoput)")
    vim.api.nvim_command("map P <Plug>(miniyank-autoPut)")
  end,
}

editor["dhruvasagar/vim-table-mode"] = { cmd = { "TableModeToggle" } }

-- fix terminal color
editor["norcalli/nvim-terminal.lua"] = {
  opt = true,
  ft = { "log", "terminal" },
  config = function()
    require("terminal").setup()
  end,
}

editor["simnalamburt/vim-mundo"] = {
  opt = true,
  cmd = { "MundoToggle", "MundoShow", "MundoHide" },
  run = function()
    vim.cmd([[packadd vim-mundo]])
    vim.cmd([[UpdateRemotePlugins]])
  end,
  setup = function()
    -- body
    vim.g.mundo_prefer_python3 = 1
  end,
}
editor["mbbill/undotree"] = { opt = true, cmd = { "UndotreeToggle" } }
editor["AndrewRadev/splitjoin.vim"] = {
  opt = true,
  cmd = { "SplitjoinJoin", "SplitjoinSplit" },
  setup = function()
    vim.g.splitjoin_split_mapping = ""
    vim.g.splitjoin_join_mapping = ""
  end,
  -- keys = {'<space>S', '<space>J'}
}

editor["chaoren/vim-wordmotion"] = {
  opt = true,
  fn = {
    "<Plug>WordMotion_w",
    "<Plug>WordMotion_b",
    "<Plug>WordMotion_gE",
  },
  keys = { "w", "W", "gE", "b", "B" },
}

editor["folke/zen-mode.nvim"] = {
  opt = true,
  requires = { "folke/twilight.nvim", opt = true, config = conf.twilight },
  cmd = { "ZenMode" },
  config = conf.zen,
}

editor["nvim-neorg/neorg"] = {
  requires = { "max397574/neorg-zettelkasten" },
  config = function()
    require("modules.editor.neorg")
  end,
}

editor["psf/black"] = { ft = "python" }

editor["famiu/bufdelete.nvim"] = {
  opt = true,
  cmd = { "Bdelete", "Bwipeout" },
}

editor["nvim-lua/popup.nvim"] = {
  opt = true,
}

editor["raimon49/requirements.txt.vim"] = {
  ft = { "requirements" },
}

editor["max397574/better-escape.nvim"] = {
  event = "InsertEnter",
  config = function()
    require("better_escape").setup({
      timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      clear_empty_lines = true, -- clear line after escaping if ther is only whitespace      })
    })
  end,
}

editor["monaqa/dial.nvim"] = {
  keys = { "<Plug>(dial-" },
  opt = true,
  setup = conf.dial_setup(),
  config = function()
    local dial = require("dial")
    dial.config.searchlist.normal = {
      "number#decimal",
      "number#hex",
      "number#binary",
      "date#[%Y/%m/%d]",
      "markup#markdown#header",
    }
    if vim.o.ft == "norg" or vim.o.ft == "markdown" then
      table.insert(dial.config.searchlist.normal, "date#[%ja]")
      table.insert(dial.config.searchlist.normal, "char#alph#small#word")
      table.insert(dial.config.searchlist.normal, "char#alph#small#str")
      table.insert(dial.config.searchlist.normal, "char#alph#capital#word")
    end
  end,
}

-- Test for now
editor["ethanholz/nvim-lastplace"] = {
  event = "BufRead",
  config = function()
    require("nvim-lastplace").setup({
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = {
        "gitcommit",
        "gitrebase",
        "svn",
        "hgcommit",
      },
      lastplace_open_folds = true,
    })
  end,
}

-- Latest dont work .
editor["sidebar-nvim/sidebar.nvim"] = {
  ft = { "python", "lua", "c", "cpp", "prolog" },
  -- Section is loaded through cache .
  opt = true,
  branch = "dev",
  config = conf.side_bar,
}

editor["nyngwang/NeoZoom.lua"] = {
  event = "BufRead",
  after = "which-key.nvim",
  config = function()
    require("which-key").register({ g = { z = { "<Cmd>NeoZoomToggle<CR>", "Toggle Zoom" } } }, { prefix = "<c-w>" })
  end,
}

editor["rmagatti/alternate-toggler"] = {
  opt = true,
  cmd = "ToggleAlternate",
}

editor["jbyuki/nabla.nvim"] = {
  opt = true,
  ft = "norg",
  requires = { "nvim-lua/popup.nvim" },
}

return editor
